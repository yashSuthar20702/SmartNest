//
//  HomeView.swift
//  SmartNest
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct HomeView: View {
    
    @EnvironmentObject private var authManager: AuthManager
    
    @State private var userName: String = ""
    @State private var householdName: String = ""
    @State private var showLogoutAlert = false
    
    @State private var budgetUsed: Double = 0.21
    @State private var totalExpenses: Double = 845.75
    @State private var remaining: Double = 1654.25
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            VStack {
                headerSection
                    .padding(.horizontal, 20)
    
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 22) {
                        
                        MonthlyBudgetCard(
                            usedPercentage: budgetUsed,
                            totalExpenses: totalExpenses,
                            remaining: remaining
                        )
                        
                        HStack(spacing: 14) {
                            StatCard(
                                title: "Chores Done",
                                value: "12",
                                icon: "checkmark.circle.fill",
                                accentColor: Color.green
                                
                            )
                            
                            StatCard(
                                title: "Low Stock",
                                value: "3",
                                icon: "exclamationmark.triangle.fill",
                                accentColor: Color.red
                            )
                        }
                        
                        HouseStatusCard(members: [
                            (name: "Yash", status: "At Home", avatar: nil),
                            (name: "Shayan", status: "Work", avatar: nil),
                            (name: "Gopal", status: "Meeting", avatar: nil)
                        ])
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
        }
        .onAppear {
            fetchUserData()
        }
        .alert("Log Out", isPresented: $showLogoutAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Log Out", role: .destructive) {
                authManager.signOut()
            }
        }
    }
    
    // MARK: - Header
    private var headerSection: some View {
        HStack {
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Welcome back,")
                    .foregroundColor(.white.opacity(0.5))
                    .font(.system(size: 13))
                
                Text(userName.isEmpty ? "Loading..." : userName)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                
                Text(householdName.isEmpty ? "No Household" : householdName)
                    .foregroundColor(Theme.accent)
                    .font(.system(size: 13, weight: .medium))
            }
            
            Spacer()
            
            Button {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                showLogoutAlert = true
            } label: {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .foregroundColor(Theme.accent)
                    .padding(10)
                    .background(
                        Circle()
                            .fill(Color.black.opacity(0.8))
                            .overlay(
                                Circle()
                                    .stroke(Theme.accent.opacity(0.6), lineWidth: 1)
                            )
                    )
                    .shadow(color: Theme.accent.opacity(0.3), radius: 8)
            }
        }
        .padding(.top, 20)
    }
    
    // MARK: - Firebase
    private func fetchUserData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        
        db.collection("users").document(uid).getDocument { snapshot, error in
            guard let data = snapshot?.data() else { return }
            
            if let name = data["name"] as? String {
                userName = name
            } else if let email = Auth.auth().currentUser?.email {
                userName = String(email.split(separator: "@").first ?? "User")
            }
            
            if let householdId = data["householdId"] as? String {
                fetchHouseholdName(householdId: householdId)
            }
        }
    }
    
    private func fetchHouseholdName(householdId: String) {
        Firestore.firestore()
            .collection("households")
            .document(householdId)
            .getDocument { snapshot, error in
                
                if let data = snapshot?.data(),
                   let name = data["name"] as? String {
                    householdName = name
                }
            }
    }
}


#Preview {
    HomeView()
}
