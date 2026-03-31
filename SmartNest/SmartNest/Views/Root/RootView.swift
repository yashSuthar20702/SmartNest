//
//  RootView.swift
//  SmartNest
//
//  Created by Yash on 2026-03-31.
//

import SwiftUI

struct RootView: View {
    
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    
    var body: some View {
        if hasSeenOnboarding {
            ContentView()
        } else {
            SplashView()
        }
    }
}

#Preview {
    RootView()
}
