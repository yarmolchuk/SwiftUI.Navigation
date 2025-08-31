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
        
        appViewModel.selectedTab = .one
        XCTAssertEqual(appViewModel.selectedTab, .one)
        
        appViewModel.selectedTab = .three
        XCTAssertEqual(appViewModel.selectedTab, .three)
    }
    
    func testInventoryViewModelUpdate() {
        let initialInventoryViewModel = InventoryViewModel()
        let appViewModel = AppViewModel(inventoryViewModel: initialInventoryViewModel)
        
        let newInventoryViewModel = InventoryViewModel()
        appViewModel.inventoryViewModel = newInventoryViewModel
        
        XCTAssertNotNil(appViewModel.inventoryViewModel)
    }
}
