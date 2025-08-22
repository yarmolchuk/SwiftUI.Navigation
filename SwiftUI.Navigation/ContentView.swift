//
//  ContentView.swift
//  SwiftUI.Navigation
//
//  Created by Dmytro Yarmolchuk on 11.08.2025.
//

import SwiftUI

enum Tab {
    case one, inventory, three
}

struct ContentView: View {
    @ObservedObject var viewModel: AppViewModel
    
    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            Text("One")
                .tabItem { Text("One") }
                .tag(Tab.one)
        
            NavigationView {
                InventoryView(viewModel: viewModel.inventoryViewModel)
            }
            .tabItem { Text("Inventory") }
            .tag(Tab.inventory)

            Text("Three")
                .tabItem { Text("Three") }
                .tag(Tab.three)
        }
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
