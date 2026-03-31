//
//  Theme.swift
//  SmartNest
//
//  Created by Yash on 2026-03-31.
//

import Foundation

import SwiftUI

enum Theme {
    static let accent = Color(hex: "#E7F161")
    static let background = Color.black
}

enum Strings {
    static let appName = "SmartNest"
    static let tagline = "Your home, intelligently connected."
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
