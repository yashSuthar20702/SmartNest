//
//  InputField.swift
//  SmartNest
//
//  Created by Yash on 2026-04-01.
//

import SwiftUI

struct InputField: View {

    let icon: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(.white.opacity(0.3))
                .frame(width: 20)

            if isSecure {
                SecureField("", text: $text, prompt:
                    Text(placeholder).foregroundColor(.white.opacity(0.25))
                )
                .foregroundColor(.white)
                .font(.system(size: 15, design: .rounded))
            } else {
                TextField("", text: $text, prompt:
                    Text(placeholder).foregroundColor(.white.opacity(0.25))
                )
                .foregroundColor(.white)
                .font(.system(size: 15, design: .rounded))
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 54)
        .background(Color.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(Color.white.opacity(0.08), lineWidth: 1)
        )
    }
}

#Preview {
    InputField(icon: "", placeholder: "", text: .constant(""))
}
