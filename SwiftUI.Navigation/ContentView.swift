//
//  ContentView.swift
//  SwiftUI.Navigation
//
//  Created by Dmytro Yarmolchuk on 11.08.2025.
//

import SwiftUI

enum Tab: CaseIterable {
    case dashboard
    case inventory
    case settings
    
    var localizedTitle: String {
        switch self {
        case .dashboard:
            NSLocalizedString("Dashboard", comment: "Dashboard tab title")
        case .inventory:
            NSLocalizedString("Inventory", comment: "Inventory tab title")
        case .settings:
            NSLocalizedString("Settings", comment: "Settings tab title")
        }
    }
    
    var iconName: String {
        switch self {
        case .dashboard:
            "chart.bar.fill"
        case .inventory:
            "cube.box.fill"
        case .settings:
            "gearshape.fill"
        }
    }
    
    var accessibilityLabel: String {
        switch self {
        case .dashboard:
            NSLocalizedString(
                "Dashboard tab, shows overview and statistics",
                comment: "Dashboard tab accessibility label"
            )
        case .inventory:
            NSLocalizedString(
                "Inventory tab, manage your items and products",
                comment: "Inventory tab accessibility label"
            )
        case .settings:
            NSLocalizedString(
                "Settings tab, configure app preferences",
                comment: "Settings tab accessibility label"
            )
        }
    }
}

struct ContentView: View {
    @ObservedObject var viewModel: AppViewModel
    
    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            VStack(spacing: 20) {
                Image(systemName: "chart.bar.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.gray)
                
                Text("Dashboard")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Overview and statistics coming soon...")
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .tabItem {
                Image(systemName: Tab.dashboard.iconName)
                Text(Tab.dashboard.localizedTitle)
            }
            .tag(Tab.dashboard)
            .accessibilityLabel(Tab.dashboard.accessibilityLabel)
        
            NavigationView {
                InventoryView(viewModel: viewModel.inventoryViewModel)
            }
            .tabItem {
                Image(systemName: Tab.inventory.iconName)
                Text(Tab.inventory.localizedTitle)
            }
            .tag(Tab.inventory)
            .accessibilityLabel(Tab.inventory.accessibilityLabel)

            VStack(spacing: 20) {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.gray)
                
                Text("Settings")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("App preferences and configuration coming soon...")
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .tabItem {
                Image(systemName: Tab.settings.iconName)
                Text(Tab.settings.localizedTitle)
            }
            .tag(Tab.settings)
            .accessibilityLabel(Tab.settings.accessibilityLabel)
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(Text("Main navigation tabs"))
    }
}

#Preview {
    let keyboard = Item(
        name: "Keyboard",
        color: .blue,
        status: .inStock(quantity: 100)
    )
    
    ContentView(
        viewModel: .init(
            inventoryViewModel: .init(
                inventory: [
                    .init(item: keyboard)
                ],
                route: .add(
                    .init(item: Item(name: "MacBook 14", color: nil, status: .inStock(quantity: 1)))
                )
            ),
            selectedTab: .inventory
        )
    )
}

#Preview("Dashboard Tab") {
    ContentView(
        viewModel: .init(
            inventoryViewModel: .init(),
            selectedTab: .dashboard
        )
    )
}

#Preview("Settings Tab") {
    ContentView(
        viewModel: .init(
            inventoryViewModel: .init(),
            selectedTab: .settings
        )
    )
}
