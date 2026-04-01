//
//  LoginViewModel.swift
//  SmartNest
//

//
//  LoginViewModel.swift
//  SmartNest
//

import SwiftUI
import FirebaseAuth
internal import Combine

class LoginViewModel: ObservableObject {

    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    @Published var isLoading = false

    func signIn() {
        guard validate() else {
            print("[LoginVM] Validation failed")
            return
        }
        print("[LoginVM] Signing in with email: \(email)")
        isLoading = true
        errorMessage = ""

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error {
                    print("[LoginVM] Sign in failed: \(error.localizedDescription)")
                    self?.errorMessage = error.localizedDescription
                } else {
                    print("[LoginVM] Sign in success — uid: \(result?.user.uid ?? "unknown")")
                }
            }
        }
    }

    func sendPasswordReset() {
        guard !email.isEmpty else {
            errorMessage = "Enter your email first."
            return
        }
        print("[LoginVM] Sending password reset to: \(email)")
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            DispatchQueue.main.async {
                if let error {
                    print("[LoginVM] Password reset failed: \(error.localizedDescription)")
                    self?.errorMessage = error.localizedDescription
                } else {
                    print("[LoginVM] Password reset email sent")
                    self?.errorMessage = "Reset email sent."
                }
            }
        }
    }

    private func validate() -> Bool {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill in all fields."
            return false
        }
        return true
    }
}
