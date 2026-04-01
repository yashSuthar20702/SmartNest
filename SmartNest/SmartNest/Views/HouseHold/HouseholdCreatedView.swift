//
//  HouseholdCreatedView.swift
//  SmartNest
//
//  Created by Yash on 2026-04-01.
//

import SwiftUI

struct HouseholdCreatedView: View {

    let householdName: String
    let code: String

    @EnvironmentObject private var householdVM: HouseholdViewModel
    @State private var appeared = false
    @State private var copied = false

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            Ellipse()
                .fill(Theme.accent.opacity(0.07))
                .frame(width: 300, height: 300)
                .blur(radius: 70)
                .opacity(appeared ? 1 : 0)

            VStack(spacing: 0) {

                Spacer()

                ZStack {
                    Circle()
                        .fill(Theme.accent.opacity(0.1))
                        .frame(width: 100, height: 100)

                    Image(systemName: "house.fill")
                        .font(.system(size: 40, weight: .semibold))
                        .foregroundStyle(Theme.accent)
                        .shadow(color: Theme.accent.opacity(0.5), radius: 12)
                }
                .scaleEffect(appeared ? 1 : 0.5)
                .opacity(appeared ? 1 : 0)

                Spacer().frame(height: 28)

                VStack(spacing: 8) {
                    Text("Household Created!")
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .foregroundColor(.white)

                    Text(householdName)
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundColor(Theme.accent.opacity(0.8))

                    Text("Share this code with your roommates\nso they can join your household.")
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                        .foregroundColor(.white.opacity(0.4))
                        .multilineTextAlignment(.center)
                        .padding(.top, 4)
                }
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 12)

                Spacer().frame(height: 40)

                VStack(spacing: 16) {

                    Text("Your Household Code")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.35))
                        .tracking(1.2)
                        .textCase(.uppercase)

                    HStack(spacing: 10) {
                        ForEach(Array(code.enumerated()), id: \.offset) { _, char in
                            Text(String(char))
                                .font(.system(size: 28, weight: .bold, design: .monospaced))
                                .foregroundColor(Theme.accent)
                                .frame(width: 42, height: 52)
                                .background(Theme.accent.opacity(0.08))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .strokeBorder(Theme.accent.opacity(0.2), lineWidth: 1)
                                )
                        }
                    }

                    Text("Code expires never — keep it safe")
                        .font(.system(size: 11, weight: .regular, design: .rounded))
                        .foregroundColor(.white.opacity(0.2))
                }
                .padding(28)
                .background(Color.white.opacity(0.04))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(Color.white.opacity(0.07), lineWidth: 1)
                )
                .padding(.horizontal, 32)
                .opacity(appeared ? 1 : 0)

                Spacer().frame(height: 28)

                VStack(spacing: 12) {

                    Button {
                        UIPasteboard.general.string = code
                        withAnimation(.spring(response: 0.3)) {
                            copied = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation { copied = false }
                        }
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: copied ? "checkmark" : "doc.on.doc")
                            Text(copied ? "Copied!" : "Copy Code")
                        }
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(copied ? Color.green : Theme.accent)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }

                    ShareLink(
                        item: shareText,
                        subject: Text("Join my household on \(Strings.appName)"),
                        message: Text(shareText)
                    ) {
                        HStack(spacing: 8) {
                            Image(systemName: "square.and.arrow.up")
                            Text("Share Code")
                        }
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(Color.white.opacity(0.06))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .strokeBorder(Color.white.opacity(0.08), lineWidth: 1)
                        )
                    }

                    Button {
                        householdVM.createdCode = nil
                        householdVM.householdId = code
                    } label: {
                        Text("Continue to Dashboard")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.35))
                    }
                    .padding(.top, 4)
                }
                .padding(.horizontal, 32)
                .opacity(appeared ? 1 : 0)

                Spacer()
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.65, dampingFraction: 0.7).delay(0.1)) {
                appeared = true
            }
        }
        .onDisappear {
            householdVM.createdCode = nil
        }
    }

    private var shareText: String {
        "Hey! Join my household \"\(householdName)\" on \(Strings.appName). Use code: \(code)"
    }
}

#Preview {
    HouseholdCreatedView(householdName: "Triple Threat", code: "ABC123")
        .environmentObject(HouseholdViewModel())
}
