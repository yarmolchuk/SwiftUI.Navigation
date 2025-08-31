//
//  AppViewModel.swift
//  SwiftUI.Navigation
//
//  Created by Dmytro Yarmolchuk on 11.08.2025.
//

import Foundation

final class AppViewModel: ObservableObject {
    @Published var inventoryViewModel: InventoryViewModel
    @Published var selectedTab: Tab
    
    init(
        inventoryViewModel: InventoryViewModel,
        selectedTab: Tab = .inventory
    ) {
        self.inventoryViewModel = inventoryViewModel
        self.selectedTab = selectedTab
    }
}
