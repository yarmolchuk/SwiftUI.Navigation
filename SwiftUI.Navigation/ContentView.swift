//
//  ContentView.swift
//  SwiftUI.Navigation
//
//  Created by Yarmolchuk on 11.08.2025.
//

import SwiftUI

enum Tab {
    case one, inventory, three
}

struct ContentView: View {
    @ObservedObject var viewModel: AppViewModel
    
    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            VStack {
                Text("One")
                Button("Go to 2nd tab") {
                    viewModel.selectedTab = .inventory
                }
            }
            .tabItem { Text("One") }
            .tag(Tab.one)
            

            NavigationView {
                InventoryView(viewModel: viewModel.inventoryViewModel)
            }
            .tabItem { Text("Two") }
            .tag(Tab.inventory)

            Text("Three")
                .tabItem { Text("Three") }
                .tag(Tab.three)
        }
    }
}

#Preview {
    ContentView(
        viewModel: .init(
            inventoryViewModel: .init(inventory: []),
            selectedTab: .inventory
        )
    )
}
