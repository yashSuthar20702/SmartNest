//
//  HouseholdViewModel.swift
//  SmartNest
//
//  Created by Yash on 2026-04-01.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
internal import Combine

class HouseholdViewModel: ObservableObject {

    @Published var householdId: String? = nil
    @Published var householdName: String = ""
    @Published var members: [String] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var joinCode: String = ""
    
    @Published var createdCode: String? = nil
    @Published var createdName: String = ""

    private let db = Firestore.firestore()

    func fetchHousehold() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        isLoading = true

        db.collection("users").document(uid).getDocument { [weak self] snapshot, error in
            DispatchQueue.main.async {
                self?.isLoading = false

                if let data = snapshot?.data(),
                   let householdId = data["householdId"] as? String {
                    self?.householdId = householdId
                } else {
                    self?.householdId = nil
                }
            }
        }
    }

    func createHousehold(name: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard !name.isEmpty else {
            errorMessage = "Please enter a household name."
            return
        }

        isLoading = true
        errorMessage = ""

        let code = generateCode()

        let householdData: [String: Any] = [
            "name": name,
            "createdBy": uid,
            "members": [uid],
            "code": code,
            "createdAt": Timestamp()
        ]

        db.collection("households").document(code).setData(householdData) { [weak self] error in
            if let error {
                DispatchQueue.main.async {
                    self?.isLoading = false
                    self?.errorMessage = error.localizedDescription
                }
                return
            }

            DispatchQueue.main.async {
                self?.createdCode = code
                self?.createdName = name
            }

            self?.saveHouseholdToUser(householdId: code, shouldNavigate: false)
        }
    }

    func joinHousehold(code: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let trimmedCode = code
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .uppercased()

        print("Trying to join with code:", trimmedCode)

        guard !trimmedCode.isEmpty else {
            errorMessage = "Please enter a code."
            return
        }

        isLoading = true
        errorMessage = ""

        db.collection("households").document(trimmedCode).getDocument { [weak self] snapshot, error in

            if let error {
                DispatchQueue.main.async {
                    self?.isLoading = false
                    self?.errorMessage = error.localizedDescription
                    print("JOIN ERROR:", error.localizedDescription)
                }
                return
            }

            guard let snapshot = snapshot, snapshot.exists else {
                DispatchQueue.main.async {
                    self?.isLoading = false
                    self?.errorMessage = "Invalid code."
                    print("JOIN FAILED: NO DOCUMENT")
                }
                return
            }

            print("HOUSEHOLD FOUND")

            self?.db.collection("households").document(trimmedCode).updateData([
                "members": FieldValue.arrayUnion([uid])
            ]) { error in

                if let error {
                    DispatchQueue.main.async {
                        self?.isLoading = false
                        self?.errorMessage = error.localizedDescription
                        print("JOIN UPDATE FAILED:", error.localizedDescription)
                    }
                    return
                }

                print("JOIN SUCCESS")

                self?.saveHouseholdToUser(
                    householdId: trimmedCode,
                    shouldNavigate: true
                )
            }
        }
    }

    private func saveHouseholdToUser(householdId: String, shouldNavigate: Bool) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        db.collection("users").document(uid).setData([
            "householdId": householdId
        ], merge: true) { [weak self] error in
            DispatchQueue.main.async {
                self?.isLoading = false

                if let error {
                    self?.errorMessage = error.localizedDescription
                } else {
                    if shouldNavigate {
                        self?.householdId = householdId
                    }
                }
            }
        }
    }

    private func generateCode() -> String {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<6).map { _ in letters.randomElement()! })
    }

    func reset() {
        householdId = nil
        householdName = ""
        members = []
        errorMessage = ""
        joinCode = ""
        createdCode = nil
        createdName = ""
    }
}
