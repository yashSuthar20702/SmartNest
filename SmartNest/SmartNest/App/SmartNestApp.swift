//
//  SmartNestApp.swift
//  SmartNest
//
//  Created by Yash Suthar on 2026-03-29.
//

import SwiftUI
import Firebase

@main
struct SmartNestApp: App {
    
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    
    init() {
        // Don't configure Firebase during Xcode Previews
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1" {
            FirebaseApp.configure()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            RootView(hasSeenOnboarding: hasSeenOnboarding)
        }
    }
}
