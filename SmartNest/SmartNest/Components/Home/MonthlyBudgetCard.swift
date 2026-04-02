//
//  MonthlyBudgetCard.swift
//  SmartNest
//
//  Created by Yash on 2026-04-02.
//

import SwiftUI

struct MonthlyBudgetCard: View {

    var usedPercentage: Double
    var totalExpenses: Double
    var remaining: Double

    @State private var animatedPercentage: Double = 0
    @State private var animatedExpenses: Double = 0
    @State private var animatedRemaining: Double = 0
    @State private var isVisible: Bool = false

    private var progressColor: Color {
        switch usedPercentage {
        case ..<0.6: return Color(red: 0.4, green: 0.85, blue: 0.65)   // Mint green
        case ..<0.85: return Color(red: 1.0, green: 0.75, blue: 0.3)   // Amber
        default: return Color(red: 1.0, green: 0.38, blue: 0.35)       // Soft red
        }
    }

    private var statusLabel: String {
        switch usedPercentage {
        case ..<0.6: return "On Track"
        case ..<0.85: return "Caution"
        default: return "Over Budget"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // MARK: — Header
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Monthly Budget")
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundStyle(.white.opacity(0.5))
                        .tracking(0.5)
                        .textCase(.uppercase)

                    Text("April 2026")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                }

                Spacer()

                // Status pill
                Text(statusLabel)
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .foregroundStyle(progressColor)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(progressColor.opacity(0.15))
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(progressColor.opacity(0.3), lineWidth: 0.5)
                    )
                    .opacity(isVisible ? 1 : 0)
                    .scaleEffect(isVisible ? 1 : 0.8)
                    .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.3), value: isVisible)
            }
            .padding(.bottom, 22)

            // MARK: — Progress Bar
            VStack(alignment: .leading, spacing: 8) {
                // Track
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 100)
                        .fill(Color.white.opacity(0.07))
                        .frame(height: 6)

                    GeometryReader { geo in
                        RoundedRectangle(cornerRadius: 100)
                            .fill(
                                LinearGradient(
                                    colors: [progressColor, progressColor.opacity(0.7)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(
                                width: geo.size.width * CGFloat(animatedPercentage),
                                height: 6
                            )
                            .shadow(color: progressColor.opacity(0.5), radius: 4, x: 0, y: 2)
                    }
                    .frame(height: 6)
                }

                // Percentage row
                HStack {
                    Text("\(Int(animatedPercentage * 100))%")
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundStyle(progressColor)
                        .contentTransition(.numericText())
                        .animation(.easeOut(duration: 0.8), value: animatedPercentage)

                    Spacer()

                    Text("of monthly budget used")
                        .font(.system(size: 12, weight: .regular, design: .rounded))
                        .foregroundStyle(.white.opacity(0.35))
                }
            }
            .padding(.bottom, 24)

            // MARK: — Divider
            Rectangle()
                .fill(Color.white.opacity(0.07))
                .frame(height: 0.5)
                .padding(.bottom, 20)

            // MARK: — Stats Row
            HStack(spacing: 0) {
                // Total Expenses
                StatColumn(
                    value: "$\(String(format: "%.2f", animatedExpenses))",
                    label: "Spent",
                    valueColor: .white,
                    isVisible: isVisible,
                    delay: 0.1
                )

                // Separator
                Rectangle()
                    .fill(Color.white.opacity(0.08))
                    .frame(width: 0.5, height: 40)
                    .padding(.horizontal, 20)

                // Remaining
                StatColumn(
                    value: "$\(String(format: "%.2f", animatedRemaining))",
                    label: "Remaining",
                    valueColor: progressColor,
                    isVisible: isVisible,
                    delay: 0.2
                )
            }
        }
        .padding(22)
        .background {
            ZStack {
                // Base
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color(white: 0.08))

                // Subtle gradient overlay
                RoundedRectangle(cornerRadius: 24)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.04),
                                Color.clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                // Glass edge highlight (top)
                RoundedRectangle(cornerRadius: 24)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.18),
                                Color.white.opacity(0.04)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.5
                    )
            }
        }
        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
        .opacity(isVisible ? 1 : 0)
        .offset(y: isVisible ? 0 : 10)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                isVisible = true
            }
            withAnimation(.easeOut(duration: 1.0).delay(0.2)) {
                animatedPercentage = usedPercentage
            }
            withAnimation(.easeOut(duration: 0.9).delay(0.15)) {
                animatedExpenses = totalExpenses
                animatedRemaining = remaining
            }
        }
        .onChange(of: usedPercentage) { _, newValue in
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                animatedPercentage = newValue
            }
        }
        .onChange(of: totalExpenses) { _, newValue in
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                animatedExpenses = newValue
            }
        }
        .onChange(of: remaining) { _, newValue in
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                animatedRemaining = newValue
            }
        }
    }
}

// MARK: — Stat Column

private struct StatColumn: View {
    let value: String
    let label: String
    let valueColor: Color
    let isVisible: Bool
    let delay: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(value)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(valueColor)
                .contentTransition(.numericText())

            Text(label)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundStyle(.white.opacity(0.35))
                .tracking(0.3)
        }
        .opacity(isVisible ? 1 : 0)
        .offset(y: isVisible ? 0 : 6)
        .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(delay), value: isVisible)
    }
}

// MARK: — Preview

#Preview {
    ZStack {
        Color(white: 0.04).ignoresSafeArea()

        VStack(spacing: 16) {
            MonthlyBudgetCard(
                usedPercentage: 0.45,
                totalExpenses: 1247.80,
                remaining: 1502.20
            )

            MonthlyBudgetCard(
                usedPercentage: 0.78,
                totalExpenses: 2106.50,
                remaining: 643.50
            )

            MonthlyBudgetCard(
                usedPercentage: 0.94,
                totalExpenses: 2538.00,
                remaining: 212.00
            )
        }
        .padding(20)
    }
}
