//
//  SplashView.swift
//  SmartNest
//
//  Created by Yash on 2026-03-31.
//

import SwiftUI

struct SplashView: View {

    @State private var isActive = false
    @State private var boltAppeared = false
    @State private var textAppeared = false
    @State private var glowing = false

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            // Background glow
            Ellipse()
                .fill(Theme.accent.opacity(0.07))
                .frame(width: 300, height: 300)
                .blur(radius: 60)
                .scaleEffect(glowing ? 1.15 : 0.9)
                .opacity(boltAppeared ? 1 : 0)

            VStack(spacing: 0) {

                Spacer()

                // Bolt icon
                BoltShape()
                    .fill(Theme.accent)
                    .shadow(color: Theme.accent.opacity(0.6), radius: glowing ? 28 : 12)
                    .frame(width: 65, height: 100)
                    .scaleEffect(boltAppeared ? 1 : 0.3)
                    .opacity(boltAppeared ? 1 : 0)

                Spacer().frame(height: 50)

                // App name
                Text(Strings.appName)
                    .font(.system(size: 42, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .opacity(textAppeared ? 1 : 0)
                    .offset(y: textAppeared ? 0 : 16)

                Spacer().frame(height: 8)

                // Tagline
                Text(Strings.tagline)
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .foregroundColor(Theme.accent.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .opacity(textAppeared ? 1 : 0)
                    .offset(y: textAppeared ? 0 : 10)

                Spacer()

            }
            .padding(.horizontal, 32)
        }
        .onAppear {
            withAnimation(.spring(response: 0.65, dampingFraction: 0.6)) {
                boltAppeared = true
            }
            withAnimation(.spring(response: 0.6, dampingFraction: 0.75).delay(0.35)) {
                textAppeared = true
            }
            withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true).delay(0.5)) {
                glowing = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                isActive = true
            }
        }
        .fullScreenCover(isPresented: $isActive) {
            OnboardingView()
        }
    }
}

#Preview {
    SplashView()
}
