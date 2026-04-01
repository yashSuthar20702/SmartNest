//
//  RootView.swift
//  SmartNest
//
//  Created by Yash on 2026-03-31.
//


import SwiftUI

struct RootView: View {

    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    @StateObject private var authManager = AuthManager()
    @StateObject private var householdVM = HouseholdViewModel()

    var body: some View {
        ZStack {
            if !hasSeenOnboarding {
                OnboardingView()
                    .transition(.opacity)
            } else if !authManager.isLoggedIn {
                LoginView()
                    .transition(.opacity)
            } else if householdVM.isLoading {
                loadingScreen
                    .transition(.opacity)
            } else if householdVM.householdId == nil {
                HouseholdView()
                    .transition(.opacity)
            } else {
                DashboardView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: hasSeenOnboarding)
        .animation(.easeInOut(duration: 0.3), value: authManager.isLoggedIn)
        .animation(.easeInOut(duration: 0.3), value: householdVM.householdId)
        .animation(.easeInOut(duration: 0.3), value: householdVM.isLoading)
        .environmentObject(authManager)
        .environmentObject(householdVM)
        .onAppear {
            householdVM.fetchHousehold()
        }
        .onChange(of: authManager.isLoggedIn) { _, isLoggedIn in
            if isLoggedIn {
                householdVM.fetchHousehold()
            } else {
                householdVM.reset()
            }
        }
    }

    // MARK: - Loading Screen
    private var loadingScreen: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            VStack(spacing: 16) {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(Theme.accent)
                    .scaleEffect(1.2)
                Text("Loading...")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.4))
            }
        }
    }
}
