//
//  AuthManager.swift
//  SmartNest
//

import SwiftUI
import FirebaseAuth
internal import Combine

class AuthManager: ObservableObject {

    @Published var isLoggedIn: Bool = false

    init() {
        let currentUser = Auth.auth().currentUser
        isLoggedIn = currentUser != nil
        print("[AuthManager] Init — user already logged in: \(isLoggedIn), uid: \(currentUser?.uid ?? "none")")

        Auth.auth().addStateDidChangeListener { _, user in
            DispatchQueue.main.async {
                let loggedIn = user != nil
                print("[AuthManager] Auth state changed — isLoggedIn: \(loggedIn), uid: \(user?.uid ?? "none")")
                self.isLoggedIn = loggedIn
            }
        }
    }

    func signOut() {
        print("[AuthManager] Signing out")
        try? Auth.auth().signOut()
    }
}
