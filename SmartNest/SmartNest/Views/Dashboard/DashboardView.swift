//
//  DashboardView.swift
//  SmartNest
//
//  Created by Yash on 2026-04-01.
//

import SwiftUI

struct DashboardView: View {

    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {

            HomeView()
                .tag(0)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            ExpensesView()
                .tag(1)
                .tabItem {
                    Label("Expenses", systemImage: "creditcard.fill")
                }

            ChoresView()
                .tag(2)
                .tabItem {
                    Label("Chores", systemImage: "checkmark.circle.fill")
                }

            InventoryView()
                .tag(3)
                .tabItem {
                    Label("Inventory", systemImage: "cart.fill")
                }

            StatusView()
                .tag(4)
                .tabItem {
                    Label("Status", systemImage: "person.fill.viewfinder")
                }
        }
        .tint(Theme.accent)
    }
}

#Preview {
    DashboardView()
}
