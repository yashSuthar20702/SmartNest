//
//  LoginView.swift
//  SmartNest
//
//  Created by Yash on 2026-04-01.
//

import SwiftUI

struct LoginView: View {

    @EnvironmentObject private var authManager: AuthManager
    @StateObject private var loginVM = LoginViewModel()
    @StateObject private var registerVM = RegisterViewModel()
    @State private var isRegisterMode = false
    @State private var appeared = false

    private var isLoading: Bool {
        isRegisterMode ? registerVM.isLoading : loginVM.isLoading
    }

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            // Background glow
            Ellipse()
                .fill(Theme.accent.opacity(0.06))
                .frame(width: 320, height: 320)
                .blur(radius: 80)
                .offset(y: -120)
                .opacity(appeared ? 1 : 0)

            VStack(spacing: 0) {
                Spacer().frame(height: 72)
                headerSection
                Spacer().frame(height: 48)
                fieldsSection
                Spacer().frame(height: 28)
                primaryButton
                Spacer()
                toggleModeButton
                    .padding(.bottom, 40)
            }
            .disabled(isLoading)

            // Full screen loading overlay
            if isLoading {
                ZStack {
                    Color.black.opacity(0.6)
                        .ignoresSafeArea()

                    VStack(spacing: 16) {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .tint(Theme.accent)
                            .scaleEffect(1.2)

                        Text(isRegisterMode ? "Creating account..." : "Signing in...")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .padding(32)
                    .background(Color.white.opacity(0.05))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .strokeBorder(Color.white.opacity(0.08), lineWidth: 1)
                    )
                }
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isLoading)
        .onAppear {
            withAnimation(.spring(response: 0.65, dampingFraction: 0.75).delay(0.1)) {
                appeared = true
            }
        }
    }

    // MARK: - Header
    private var headerSection: some View {
        VStack(spacing: 16) {
            BoltShape()
                .fill(Theme.accent)
                .shadow(color: Theme.accent.opacity(0.5), radius: 16)
                .frame(width: 36, height: 50)
                .scaleEffect(appeared ? 1 : 0.5)
                .opacity(appeared ? 1 : 0)

            VStack(spacing: 6) {
                Text(isRegisterMode ? "Create account" : "Welcome back")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.white)

                Text(isRegisterMode ? "Join \(Strings.appName) today" : "Sign in to \(Strings.appName)")
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundColor(.white.opacity(0.4))
            }
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 12)
            .animation(.spring(response: 0.4), value: isRegisterMode)
        }
    }

    // MARK: - Fields
    private var fieldsSection: some View {
        VStack(spacing: 14) {
            InputField(
                icon: "envelope",
                placeholder: "Email address",
                text: isRegisterMode ? $registerVM.email : $loginVM.email
            )

            InputField(
                icon: "lock",
                placeholder: "Password",
                text: isRegisterMode ? $registerVM.password : $loginVM.password,
                isSecure: true
            )

            if isRegisterMode {
                InputField(
                    icon: "lock.fill",
                    placeholder: "Confirm password",
                    text: $registerVM.confirmPassword,
                    isSecure: true
                )
                .transition(.move(edge: .top).combined(with: .opacity))
            }

            if !isRegisterMode {
                HStack {
                    Spacer()
                    Button("Forgot password?") {
                        loginVM.sendPasswordReset()
                    }
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundColor(Theme.accent.opacity(0.8))
                }
                .padding(.horizontal, 4)
                .transition(.opacity)
            }

            let errorMessage = isRegisterMode ? registerVM.errorMessage : loginVM.errorMessage
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(.system(size: 13))
                    .foregroundColor(.red.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .transition(.opacity)
            }
        }
        .padding(.horizontal, 32)
        .opacity(appeared ? 1 : 0)
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isRegisterMode)
    }

    // MARK: - Primary Button
    private var primaryButton: some View {
        Button {
            withAnimation {
                isRegisterMode ? registerVM.register() : loginVM.signIn()
            }
        } label: {
            RoundedRectangle(cornerRadius: 16)
                .fill(Theme.accent)
                .frame(height: 54)
                .overlay(
                    Text(isRegisterMode ? "Create Account" : "Sign In")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(.black)
                )
        }
        .padding(.horizontal, 32)
        .opacity(appeared ? 1 : 0)
    }

    // MARK: - Toggle Mode
    private var toggleModeButton: some View {
        HStack(spacing: 4) {
            Text(isRegisterMode ? "Already have an account?" : "Don't have an account?")
                .font(.system(size: 13))
                .foregroundColor(.white.opacity(0.35))

            Button(isRegisterMode ? "Sign In" : "Sign Up") {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    isRegisterMode.toggle()
                    loginVM.errorMessage = ""
                    registerVM.errorMessage = ""
                }
            }
            .font(.system(size: 13, weight: .semibold))
            .foregroundColor(Theme.accent)
        }
        .opacity(appeared ? 1 : 0)
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthManager())
}
