//
//  AppViewModel.swift
//  SwiftUI.Navigation
//
//  Created by Yarmolchuk on 11.08.2025.
//

import Foundation

final class AppViewModel: ObservableObject {
    @Published var inventoryViewModel: InventoryViewModel
    @Published var selectedTab: Tab
    
    init(
        inventoryViewModel: InventoryViewModel,
        selectedTab: Tab = .one
    ) {
        self.inventoryViewModel = inventoryViewModel
        self.selectedTab = selectedTab
    }
}
