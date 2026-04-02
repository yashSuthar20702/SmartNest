//
//  HouseStatusCard.swift
//  SmartNest
//
//  Created by Yash on 2026-04-02.
//

import SwiftUI

struct HouseStatusCard: View {

    var members: [(name: String, status: String, avatar: String? )]

    @State private var isVisible = false
    @State private var visibleRows: Set<Int> = []

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // MARK: — Header
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("House Status")
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundStyle(.white.opacity(0.4))
                        .tracking(0.5)
                        .textCase(.uppercase)

                    Text("\(homeCount) at home")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .contentTransition(.numericText())
                }

                Spacer()

                // Stacked avatars preview
                ZStack {
                    ForEach(Array(members.prefix(3).enumerated().reversed()), id: \.offset) { i, member in
                        AvatarBadge(name: member.name, color: statusColor(member.status), size: 30)
                            .offset(x: CGFloat(i) * -18)
                            .zIndex(Double(3 - i))
                    }
                }
                .frame(width: CGFloat(min(members.count, 3)) * 18 + 30, height: 34)
                .opacity(isVisible ? 1 : 0)
                .animation(.spring(response: 0.5, dampingFraction: 0.75).delay(0.2), value: isVisible)
            }
            .padding(.bottom, 20)

            // MARK: — Member Rows
            VStack(spacing: 0) {
                ForEach(Array(members.enumerated()), id: \.element.name) { index, member in
                    MemberRow(
                        member: member,
                        isVisible: visibleRows.contains(index)
                    )

                    if index < members.count - 1 {
                        Rectangle()
                            .fill(Color.white.opacity(0.06))
                            .frame(height: 0.5)
                            .padding(.leading, 52)
                    }
                }
            }
        }
        .padding(20)
        .background {
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color(white: 0.08))

                RoundedRectangle(cornerRadius: 24)
                    .fill(
                        LinearGradient(
                            colors: [Color.white.opacity(0.04), Color.clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                RoundedRectangle(cornerRadius: 24)
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
        .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
        .opacity(isVisible ? 1 : 0)
        .offset(y: isVisible ? 0 : 10)
        .animation(.spring(response: 0.55, dampingFraction: 0.8), value: isVisible)
        .onAppear {
            isVisible = true
            for i in members.indices {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15 + Double(i) * 0.07) {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                        _ = visibleRows.insert(i)
                    }
                }
            }
        }
    }

    private var homeCount: Int {
        members.filter { $0.status.lowercased() == "at home" }.count
    }
}

// MARK: — Member Row

private struct MemberRow: View {
    let member: (name: String, status: String, avatar: String?)
    let isVisible: Bool

    var body: some View {
        HStack(spacing: 12) {
            // Avatar
            AvatarBadge(name: member.name, color: statusColor(member.status), size: 38)

            // Name + status text
            VStack(alignment: .leading, spacing: 2) {
                Text(member.name)
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)

                Text(member.status)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.4))
            }

            Spacer()

            // Status pill
            HStack(spacing: 5) {
                Circle()
                    .fill(statusColor(member.status))
                    .frame(width: 6, height: 6)
                    .shadow(color: statusColor(member.status).opacity(0.7), radius: 3)

                Text(statusIcon(member.status))
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .foregroundStyle(statusColor(member.status))
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(statusColor(member.status).opacity(0.1))
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(statusColor(member.status).opacity(0.2), lineWidth: 0.5)
            )
        }
        .padding(.vertical, 10)
        .opacity(isVisible ? 1 : 0)
        .offset(x: isVisible ? 0 : -12)
    }
}

// MARK: — Avatar Badge

private struct AvatarBadge: View {
    let name: String
    let color: Color
    let size: CGFloat

    var initials: String {
        let parts = name.split(separator: " ")
        if parts.count >= 2 {
            return "\(parts[0].prefix(1))\(parts[1].prefix(1))"
        }
        return String(name.prefix(2)).uppercased()
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(color.opacity(0.18))

            Circle()
                .stroke(color.opacity(0.35), lineWidth: 0.5)

            Text(initials)
                .font(.system(size: size * 0.34, weight: .semibold, design: .rounded))
                .foregroundStyle(color)
        }
        .frame(width: size, height: size)
    }
}

// MARK: — Helpers (file-scope so MemberRow can reach them)

private func statusColor(_ status: String) -> Color {
    switch status.lowercased() {
    case "at home":   return Color(red: 0.35, green: 0.85, blue: 0.60)
    case "work":      return Color(red: 0.40, green: 0.72, blue: 1.00)
    case "meeting":   return Color(red: 1.00, green: 0.65, blue: 0.20)
    case "shopping":  return Color(red: 0.72, green: 0.50, blue: 1.00)
    case "dnd":       return Color(red: 1.00, green: 0.38, blue: 0.35)
    case "sleeping":  return Color(red: 0.45, green: 0.60, blue: 0.90)
    case "gym":       return Color(red: 1.00, green: 0.55, blue: 0.25)
    default:          return Color(white: 0.55)
    }
}

private func statusIcon(_ status: String) -> String {
    switch status.lowercased() {
    case "at home":  return "At Home"
    case "work":     return "Working"
    case "meeting":  return "Meeting"
    case "shopping": return "Shopping"
    case "dnd":      return "Do Not Disturb"
    case "sleeping": return "Sleeping"
    case "gym":      return "Gym"
    default:         return status
    }
}

// MARK: — Preview

#Preview {
    ZStack {
        Color(white: 0.04).ignoresSafeArea()

        HouseStatusCard(members: [
            (name: "Yash",    status: "At Home",  avatar: nil),
            (name: "Priya",   status: "Work",     avatar: nil),
            (name: "Rajan",   status: "Meeting",  avatar: nil),
            (name: "Sara",    status: "Shopping", avatar: nil),
            (name: "Dev",     status: "Sleeping", avatar: nil),
        ])
        .padding(20)
    }
}
