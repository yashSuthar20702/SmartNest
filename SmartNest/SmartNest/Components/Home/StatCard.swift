//
//  StatCard.swift
//  SmartNest
//
//  Created by Yash on 2026-04-02.
//

import SwiftUI

struct StatCard: View {

    var title: String
    var value: String
    var icon: String
    var accentColor: Color = Color(red: 0.4, green: 0.85, blue: 0.65)
    var trend: Trend? = nil

    enum Trend {
        case up(String)
        case down(String)
        case neutral(String)

        var label: String {
            switch self { case .up(let s), .down(let s), .neutral(let s): return s }
        }
        var icon: String {
            switch self {
            case .up: return "arrow.up.right"
            case .down: return "arrow.down.right"
            case .neutral: return "minus"
            }
        }
        var color: Color {
            switch self {
            case .up: return Color(red: 0.4, green: 0.85, blue: 0.65)
            case .down: return Color(red: 1.0, green: 0.38, blue: 0.35)
            case .neutral: return Color(white: 0.5)
            }
        }
    }

    @State private var isVisible = false
    @State private var iconScale: CGFloat = 0.6
    @State private var iconOpacity: Double = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // MARK: — Icon + Trend Row
            HStack(alignment: .center) {
                // Icon badge
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(accentColor.opacity(0.12))
                        .frame(width: 36, height: 36)

                    Image(systemName: icon)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(accentColor)
                }
                .scaleEffect(iconScale)
                .opacity(iconOpacity)
                .animation(.spring(response: 0.5, dampingFraction: 0.65).delay(0.1), value: iconScale)

                Spacer()

                // Optional trend badge
                if let trend {
                    HStack(spacing: 3) {
                        Image(systemName: trend.icon)
                            .font(.system(size: 9, weight: .bold))
                        Text(trend.label)
                            .font(.system(size: 11, weight: .semibold, design: .rounded))
                    }
                    .foregroundStyle(trend.color)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(trend.color.opacity(0.1))
                    .clipShape(Capsule())
                    .opacity(isVisible ? 1 : 0)
                    .scaleEffect(isVisible ? 1 : 0.8)
                    .animation(.spring(response: 0.45, dampingFraction: 0.7).delay(0.35), value: isVisible)
                }
            }
            .padding(.bottom, 14)

            // MARK: — Value
            Text(value)
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .tracking(-0.5)
                .opacity(isVisible ? 1 : 0)
                .offset(y: isVisible ? 0 : 6)
                .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.18), value: isVisible)
                .padding(.bottom, 4)

            // MARK: — Label
            Text(title)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundStyle(.white.opacity(0.38))
                .tracking(0.2)
                .opacity(isVisible ? 1 : 0)
                .offset(y: isVisible ? 0 : 4)
                .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.24), value: isVisible)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(white: 0.08))

                // Gradient sheen
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [Color.white.opacity(0.04), Color.clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                // Glass edge highlight
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.16),
                                Color.white.opacity(0.03)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.5
                    )
            }
        }
        .shadow(color: Color.black.opacity(0.28), radius: 16, x: 0, y: 8)
        .opacity(isVisible ? 1 : 0)
        .offset(y: isVisible ? 0 : 10)
        .animation(.spring(response: 0.55, dampingFraction: 0.8), value: isVisible)
        .onAppear {
            isVisible = true
            withAnimation(.spring(response: 0.5, dampingFraction: 0.65).delay(0.1)) {
                iconScale = 1.0
                iconOpacity = 1.0
            }
        }
    }
}

// MARK: — Preview

#Preview {
    ZStack {
        Color(white: 0.04).ignoresSafeArea()

        LazyVGrid(
            columns: [GridItem(.flexible()), GridItem(.flexible())],
            spacing: 12
        ) {
            StatCard(
                title: "Monthly Rent",
                value: "$2,400",
                icon: "house.fill",
                accentColor: Color(red: 0.4, green: 0.72, blue: 1.0),
                trend: .neutral("Stable")
            )
            StatCard(
                title: "Electricity",
                value: "$138",
                icon: "bolt.fill",
                accentColor: Color(red: 0.98, green: 0.78, blue: 0.3),
                trend: .down("−12%")
            )
            StatCard(
                title: "Groceries",
                value: "$412",
                icon: "cart.fill",
                accentColor: Color(red: 0.4, green: 0.85, blue: 0.65),
                trend: .up("+8%")
            )
            StatCard(
                title: "Subscriptions",
                value: "$67",
                icon: "app.badge.fill",
                accentColor: Color(red: 0.78, green: 0.55, blue: 1.0),
                trend: .up("+2%")
            )
        }
        .padding(20)
    }
}
