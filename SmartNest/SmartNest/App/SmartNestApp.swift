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
    
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
