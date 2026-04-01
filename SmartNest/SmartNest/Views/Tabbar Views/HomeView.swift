//
//  HomeView.swift
//  SmartNest
//
//  Created by Yash on 2026-04-01.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct HomeView: View {

    @EnvironmentObject private var authManager: AuthManager
    @State private var userName: String = ""
    @State private var showLogoutAlert = false

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            VStack(spacing: 0) {
                headerSection
                Spacer()
            }
        }
        .onAppear {
            fetchUserName()
        }
        .alert("Log Out", isPresented: $showLogoutAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Log Out", role: .destructive) {
                authManager.signOut()
            }
        } message: {
            Text("Are you sure you want to log out?")
        }
    }

    // MARK: - Header
    private var headerSection: some View {
        HStack(alignment: .center) {

            VStack(alignment: .leading, spacing: 4) {
                Text("Welcome back,")
                    .font(.system(size: 13, weight: .regular, design: .rounded))
                    .foregroundColor(.white.opacity(0.4))

                Text(userName.isEmpty ? "Loading..." : userName)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }

            Spacer()

            Button {
                showLogoutAlert = true
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.system(size: 14, weight: .medium))
                    Text("Log Out")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                }
                .foregroundColor(.white.opacity(0.6))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.white.opacity(0.06))
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .strokeBorder(Color.white.opacity(0.08), lineWidth: 1)
                )
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 20)
        .padding(.bottom, 16)
    }

    // MARK: - Fetch User Name
    private func fetchUserName() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("[HomeView] No current user found")
            return
        }

        print("[HomeView] Fetching user name for uid: \(uid)")

        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, error in
            if let error {
                print("[HomeView] Failed to fetch user: \(error.localizedDescription)")

                // Fallback to email prefix if Firestore doc doesn't exist yet
                if let email = Auth.auth().currentUser?.email {
                    userName = String(email.split(separator: "@").first ?? "User")
                    print("[HomeView] Fallback to email prefix: \(userName)")
                }
                return
            }

            if let data = snapshot?.data(), let name = data["name"] as? String {
                print("[HomeView] User name fetched: \(name)")
                userName = name
            } else {
                // Fallback to email prefix
                if let email = Auth.auth().currentUser?.email {
                    userName = String(email.split(separator: "@").first ?? "User")
                    print("[HomeView] No name field found, fallback: \(userName)")
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthManager())
}
