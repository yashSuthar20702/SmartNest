//
//  AppIconView.swift
//  SmartNest
//
//  Created by Yash on 2026-03-31.
//

import SwiftUI

struct AppIconView: View {

    var size: CGFloat = 100

    var body: some View {
        ZStack {
            // Background
            RoundedRectangle(cornerRadius: size * 0.22)
                .fill(Color(hex: "#111111"))

            // Radial glow
            RoundedRectangle(cornerRadius: size * 0.22)
                .fill(
                    RadialGradient(
                        colors: [
                            Color(hex: "#E7F161").opacity(0.15),
                            Color(hex: "#E7F161").opacity(0)
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: size * 0.5
                    )
                )

            // Lightning bolt
            BoltShape()
                .fill(Theme.accent)
                .frame(width: size * 0.4, height: size * 0.72)
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Bolt Shape
struct BoltShape: Shape {
    func path(in rect: CGRect) -> Path {
        // Original SVG points mapped from 100x100 viewBox
        // d="M57 14 L30 54 L47 54 L43 86 L70 46 L53 46 Z"
        let points: [(CGFloat, CGFloat)] = [
            (57, 14),
            (30, 54),
            (47, 54),
            (43, 86),
            (70, 46),
            (53, 46)
        ]

        let scaleX = rect.width / 40   // bolt spans ~40pts wide (30–70)
        let scaleY = rect.height / 72  // bolt spans ~72pts tall (14–86)
        let offsetX: CGFloat = 30      // min x in SVG
        let offsetY: CGFloat = 14      // min y in SVG

        var path = Path()
        for (i, point) in points.enumerated() {
            let x = (point.0 - offsetX) * scaleX
            let y = (point.1 - offsetY) * scaleY
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        path.closeSubpath()
        return path
    }
}

#Preview {
    VStack(spacing: 24) {
        AppIconView(size: 100)
        AppIconView(size: 60)
        AppIconView(size: 40)
    }
    .padding()
    .background(Color.gray.opacity(0.2))
}
