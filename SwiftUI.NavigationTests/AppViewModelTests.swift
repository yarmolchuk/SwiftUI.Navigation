//
//  AppViewModelTests.swift
//  SwiftUI.NavigationTests
//
//  Created by Dmytro Yarmolchuk on 18.08.2025.
//

import XCTest

@testable import SwiftUI_Navigation

final class AppViewModelTests: XCTestCase {
    func testInitialization() {
        let inventoryViewModel = InventoryViewModel()
        let appViewModel = AppViewModel(
            inventoryViewModel: inventoryViewModel,
            selectedTab: .inventory
        )
        
        XCTAssertEqual(appViewModel.selectedTab, .inventory)
        XCTAssertNotNil(appViewModel.inventoryViewModel)
    }
    
    func testDefaultTabSelection() {
        let inventoryViewModel = InventoryViewModel()
        let appViewModel = AppViewModel(inventoryViewModel: inventoryViewModel)
        
        XCTAssertEqual(appViewModel.selectedTab, .inventory)
    }
    
    func testTabSelectionChange() {
        let inventoryViewModel = InventoryViewModel()
        let appViewModel = AppViewModel(inventoryViewModel: inventoryViewModel)
        
        appViewModel.selectedTab = .dashboard
        XCTAssertEqual(appViewModel.selectedTab, .dashboard)
        
        appViewModel.selectedTab = .settings
        XCTAssertEqual(appViewModel.selectedTab, .settings)
    }
    
    func testInventoryViewModelUpdate() {
        let initialInventoryViewModel = InventoryViewModel()
        let appViewModel = AppViewModel(inventoryViewModel: initialInventoryViewModel)
        
        let newInventoryViewModel = InventoryViewModel()
        appViewModel.inventoryViewModel = newInventoryViewModel
        
        XCTAssertNotNil(appViewModel.inventoryViewModel)
    }
}
