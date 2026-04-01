//
//  SplashView.swift
//  SmartNest
//
//  Created by Yash on 2026-03-31.
//

//
//  SplashView.swift
//  SmartNest
//

import SwiftUI

struct SplashView: View {

    @State private var boltAppeared = false
    @State private var textAppeared = false
    @State private var glowing = false

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            Ellipse()
                .fill(Theme.accent.opacity(0.07))
                .frame(width: 300, height: 300)
                .blur(radius: 60)
                .scaleEffect(glowing ? 1.15 : 0.9)
                .opacity(boltAppeared ? 1 : 0)

            VStack(spacing: 0) {
                Spacer()

                BoltShape()
                    .fill(Theme.accent)
                    .shadow(color: Theme.accent.opacity(0.6), radius: glowing ? 28 : 12)
                    .frame(width: 52, height: 72)
                    .scaleEffect(boltAppeared ? 1 : 0.3)
                    .opacity(boltAppeared ? 1 : 0)

                Spacer().frame(height: 32)

                Text(Strings.appName)
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .opacity(textAppeared ? 1 : 0)
                    .offset(y: textAppeared ? 0 : 16)

                Spacer().frame(height: 8)

                Text(Strings.tagline)
                    .font(.system(size: 13, weight: .regular, design: .rounded))
                    .foregroundColor(Theme.accent.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .opacity(textAppeared ? 1 : 0)
                    .offset(y: textAppeared ? 0 : 10)

                Spacer()

                Capsule()
                    .fill(Theme.accent.opacity(0.25))
                    .frame(width: 36, height: 4)
                    .opacity(textAppeared ? 1 : 0)
                    .padding(.bottom, 52)
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
        }
    }
}

#Preview {
    SplashView()
}
