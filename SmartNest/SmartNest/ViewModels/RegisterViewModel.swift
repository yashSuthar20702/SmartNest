//
//  RegisterViewModel.swift
//  SmartNest
//

import SwiftUI
import FirebaseAuth
internal import Combine

class RegisterViewModel: ObservableObject {

    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var errorMessage = ""
    @Published var isLoading = false

    func register() {
        guard validate() else {
            print("[RegisterVM] Validation failed")
            return
        }
        print("[RegisterVM] Creating user with email: \(email)")
        isLoading = true
        errorMessage = ""

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error {
                    print("[RegisterVM] Registration failed: \(error.localizedDescription)")
                    self?.errorMessage = error.localizedDescription
                } else {
                    print("[RegisterVM] Registration success — uid: \(result?.user.uid ?? "unknown")")
                    // AuthManager listener fires automatically, RootView handles navigation
                }
            }
        }
    }

    private func validate() -> Bool {
        guard !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            errorMessage = "Please fill in all fields."
            return false
        }
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return false
        }
        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters."
            return false
        }
        return true
    }
}
