//
//  OnboardingView.swift
//  SmartNest
//
//  Created by Yash on 2026-03-31.
//

//
//  OnboardingView.swift
//  SmartNest
//

import SwiftUI

struct OnboardingView: View {

    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    @State private var currentPage = 0

    private let pages: [OnboardingPage] = [
        OnboardingPage(icon: "bolt.fill", title: "Smart Living,\nSimplified.", subtitle: "Everything your home needs,\nin one place."),
        OnboardingPage(icon: "person.3.fill", title: "Built for\nRoommates.", subtitle: "Split expenses, track chores,\nand stay in sync effortlessly."),
        OnboardingPage(icon: "chart.bar.fill", title: "Know Where\nYour Money Goes.", subtitle: "AI-powered insights to help\nyou spend smarter together."),
        OnboardingPage(icon: "bell.badge.fill", title: "Always in\nthe Loop.", subtitle: "Smart notifications keep everyone\naccountable and informed.")
    ]

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            VStack(spacing: 0) {

                // Skip
                HStack {
                    Spacer()
                    if currentPage < pages.count - 1 {
                        Button {
                            hasSeenOnboarding = true
                        } label: {
                            Text("Skip")
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundColor(.white.opacity(0.35))
                        }
                        .padding(.trailing, 28)
                    }
                }
                .frame(height: 44)
                .padding(.top, 12)

                // Pages
                TabView(selection: $currentPage) {
                    ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                        OnboardingPageView(page: page)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.spring(response: 0.5, dampingFraction: 0.8), value: currentPage)

                // Bottom controls
                VStack(spacing: 24) {
                    HStack(spacing: 6) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Capsule()
                                .fill(index == currentPage ? Theme.accent : Color.white.opacity(0.15))
                                .frame(width: index == currentPage ? 24 : 6, height: 6)
                                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: currentPage)
                        }
                    }

                    Button {
                        if currentPage < pages.count - 1 {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                currentPage += 1
                            }
                        } else {
                            hasSeenOnboarding = true
                        }
                    } label: {
                        Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .background(Theme.accent)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .padding(.horizontal, 32)
                }
                .padding(.bottom, 52)
            }
        }
    }
}

#Preview {
    OnboardingView()
}
