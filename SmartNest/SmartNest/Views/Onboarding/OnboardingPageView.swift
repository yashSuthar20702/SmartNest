//
//  OnboardingPageView.swift
//  SmartNest
//
//  Created by Yash on 2026-03-31.
//

import SwiftUI

struct OnboardingPageView: View {

    let page: OnboardingPage
    @State private var appeared = false

    var body: some View {
        VStack(spacing: 0) {

            Spacer().frame(height: 60)

            // Glow + Icon stacked in ZStack so glow sits behind
            ZStack {
                Ellipse()
                    .fill(Theme.accent.opacity(0.07))
                    .frame(width: 240, height: 240)
                    .blur(radius: 50)
                    .scaleEffect(appeared ? 1.1 : 0.8)

                Circle()
                    .fill(Theme.accent.opacity(0.1))
                    .frame(width: 110, height: 110)

                Image(systemName: page.icon)
                    .font(.system(size: 42, weight: .semibold))
                    .foregroundStyle(Theme.accent)
                    .shadow(color: Theme.accent.opacity(0.5), radius: 12)
            }
            .scaleEffect(appeared ? 1 : 0.5)
            .opacity(appeared ? 1 : 0)

            Spacer().frame(height: 20)

            // Title
            Text(page.title)
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 16)

            Spacer().frame(height: 14)

            // Subtitle
            Text(page.subtitle)
                .font(.system(size: 15, weight: .regular, design: .rounded))
                .foregroundColor(.white.opacity(0.45))
                .multilineTextAlignment(.center)
                .lineSpacing(5)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 10)

            Spacer()
        }
        .padding(.horizontal, 36)
        .onAppear {
            appeared = false
            withAnimation(.spring(response: 0.65, dampingFraction: 0.7)) {
                appeared = true
            }
        }
        .onDisappear {
            appeared = false
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        OnboardingPageView(page: .init(icon: "bolt.fill", title: "Smart Living,\nSimplified.", subtitle: "Everything your home needs,\nin one place."))
    }
}
