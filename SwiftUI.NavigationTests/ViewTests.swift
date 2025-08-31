//
//  ViewTests.swift
//  SwiftUI.NavigationTests
//
//  Created by Dmytro Yarmolchuk on 18.08.2025.
//

import XCTest
import SwiftUI
@testable import SwiftUI_Navigation

final class ViewTests: XCTestCase {
    func testContentViewInitialization() {
        let inventoryViewModel = InventoryViewModel()
        let appViewModel = AppViewModel(inventoryViewModel: inventoryViewModel)
        let contentView = ContentView(viewModel: appViewModel)
        
        XCTAssertNotNil(contentView)
    }
    
    func testInventoryViewInitialization() {
        let inventoryViewModel = InventoryViewModel()
        let inventoryView = InventoryView(viewModel: inventoryViewModel)
        
        XCTAssertNotNil(inventoryView)
    }
    
    func testItemRowViewInitialization() {
        let item = Item(name: "Test Item", color: .red, status: .inStock(quantity: 5))
        let itemRowViewModel = ItemRowViewModel(item: item)
        let itemRowView = ItemRowView(viewModel: itemRowViewModel)
        
        XCTAssertNotNil(itemRowView)
    }
    
    func testItemViewInitialization() {
        let item = Item(name: "Test Item", color: .red, status: .inStock(quantity: 5))
        let itemViewModel = ItemViewModel(item: item)
        let itemView = ItemView(viewModel: itemViewModel)
        
        XCTAssertNotNil(itemView)
    }
    
    func testColorPickerViewInitialization() {
        let item = Item(name: "Test Item", color: .red, status: .inStock(quantity: 5))
        let itemViewModel = ItemViewModel(item: item)
        let colorPickerView = ColorPickerView(viewModel: itemViewModel)
        
        XCTAssertNotNil(colorPickerView)
    }
}
