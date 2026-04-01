//
//  HouseholdView.swift
//  SmartNest
//
//  Created by Yash on 2026-04-01.
//


import SwiftUI

struct HouseholdView: View {

    @EnvironmentObject private var householdVM: HouseholdViewModel
    @State private var mode: HouseholdMode = .create
    @State private var householdName = ""
    @State private var joinCode = ""
    @State private var appeared = false

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            // Glow
            Ellipse()
                .fill(Theme.accent.opacity(0.06))
                .frame(width: 300, height: 300)
                .blur(radius: 80)
                .offset(y: -160)
                .opacity(appeared ? 1 : 0)

            VStack(spacing: 0) {

                Spacer().frame(height: 72)

                // Header
                VStack(spacing: 10) {
                    BoltShape()
                        .fill(Theme.accent)
                        .shadow(color: Theme.accent.opacity(0.5), radius: 16)
                        .frame(width: 32, height: 44)
                        .scaleEffect(appeared ? 1 : 0.5)
                        .opacity(appeared ? 1 : 0)

                    Text("Set Up Household")
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .foregroundColor(.white)

                    Text("Create a new household or\njoin your roommate's.")
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                        .foregroundColor(.white.opacity(0.4))
                        .multilineTextAlignment(.center)
                }
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 16)

                Spacer().frame(height: 40)

                // Mode Toggle
                HStack(spacing: 0) {
                    modeButton(title: "Create", selected: mode == .create) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            mode = .create
                            householdVM.errorMessage = ""
                        }
                    }
                    modeButton(title: "Join", selected: mode == .join) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            mode = .join
                            householdVM.errorMessage = ""
                        }
                    }
                }
                .background(Color.white.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, 32)
                .opacity(appeared ? 1 : 0)

                Spacer().frame(height: 28)

                // Fields
                VStack(spacing: 14) {
                    if mode == .create {
                        InputField(
                            icon: "house",
                            placeholder: "Household name (e.g. Triple Threat)",
                            text: $householdName
                        )
                        .transition(.move(edge: .leading).combined(with: .opacity))
                    } else {
                        InputField(
                            icon: "number",
                            placeholder: "Enter 6-digit code",
                            text: $joinCode
                        )
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                    }

                    if !householdVM.errorMessage.isEmpty {
                        Text(householdVM.errorMessage)
                            .font(.system(size: 13))
                            .foregroundColor(.red.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .transition(.opacity)
                    }
                }
                .padding(.horizontal, 32)
                .opacity(appeared ? 1 : 0)
                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: mode)

                Spacer().frame(height: 28)

                // Primary Button
                Button {
                    if mode == .create {
                        householdVM.createHousehold(name: householdName)
                    } else {
                        householdVM.joinHousehold(code: joinCode)
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Theme.accent)
                            .frame(height: 54)

                        if householdVM.isLoading {
                            ProgressView().tint(.black)
                        } else {
                            Text(mode == .create ? "Create Household" : "Join Household")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(.black)
                        }
                    }
                }
                .padding(.horizontal, 32)
                .disabled(householdVM.isLoading)
                .opacity(appeared ? 1 : 0)

                // Hint
                if mode == .create {
                    Text("A 6-digit code will be generated\nfor your roommates to join.")
                        .font(.system(size: 12, weight: .regular, design: .rounded))
                        .foregroundColor(.white.opacity(0.25))
                        .multilineTextAlignment(.center)
                        .padding(.top, 12)
                        .opacity(appeared ? 1 : 0)
                        .transition(.opacity)
                }

                Spacer()
            }

            // Loading overlay
            if householdVM.isLoading {
                ZStack {
                    Color.black.opacity(0.6).ignoresSafeArea()
                    VStack(spacing: 16) {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .tint(Theme.accent)
                            .scaleEffect(1.2)

                        Text(mode == .create ? "Creating household..." : "Joining household...")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .padding(32)
                    .background(Color.white.opacity(0.05))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: householdVM.isLoading)

        .fullScreenCover(item: Binding(
            get: {
                householdVM.createdCode.map {
                    CreatedHousehold(code: $0, name: householdVM.createdName)
                }
            },
            set: { _ in }
        )) { created in
            HouseholdCreatedView(
                householdName: created.name,
                code: created.code
            )
            .environmentObject(householdVM)
        }

        .onAppear {
            withAnimation(.spring(response: 0.65, dampingFraction: 0.75).delay(0.1)) {
                appeared = true
            }
        }
    }

    // MARK: - Mode Button
    private func modeButton(title: String, selected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundColor(selected ? .black : .white.opacity(0.4))
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .background(selected ? Theme.accent : Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(4)
        }
    }
}

#Preview {
    HouseholdView()
        .environmentObject(HouseholdViewModel())
}
