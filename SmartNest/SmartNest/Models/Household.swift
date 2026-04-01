//
//  Household.swift
//  SmartNest
//
//  Created by Yash on 2026-04-01.
//

import Foundation

struct Household: Identifiable {
    let id: String
    let name: String
    let createdBy: String
    let members: [String]
}

enum HouseholdMode {
    case create, join
}

// Helper model for fullScreenCover
struct CreatedHousehold: Identifiable {
    let id = UUID()
    let code: String
    let name: String
}
