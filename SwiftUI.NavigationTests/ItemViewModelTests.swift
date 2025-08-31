//
//  ItemViewModelTests.swift
//  SwiftUI.NavigationTests
//
//  Created by Dmytro Yarmolchuk on 18.08.2025.
//

import XCTest
@testable import SwiftUI_Navigation

final class ItemViewModelTests: XCTestCase {
    func testInitialization() {
        let item = Item(name: "Test Item", color: .red, status: .inStock(quantity: 5))
        let viewModel = ItemViewModel(item: item)
        
        XCTAssertEqual(viewModel.item, item)
        XCTAssertEqual(viewModel.id, item.id)
        XCTAssertFalse(viewModel.nameIsDuplicate)
        XCTAssertTrue(viewModel.newColors.isEmpty)
        XCTAssertNil(viewModel.route)
    }
    
    func testInitializationWithRoute() {
        let item = Item(name: "Test Item", color: .red, status: .inStock(quantity: 5))
        let viewModel = ItemViewModel(item: item, route: .colorPicker)
        
        XCTAssertEqual(viewModel.route, .colorPicker)
    }
    
    func testNameDuplicateDetection() async {
        let item = Item(name: "Keyboard", color: .red, status: .inStock(quantity: 5))
        let viewModel = ItemViewModel(item: item)

        try? await Task.sleep(nanoseconds: 400 * NSEC_PER_MSEC)
        
        XCTAssertTrue(viewModel.nameIsDuplicate)
    }
    
    func testNameNotDuplicate() async {
        let item = Item(name: "Unique Name", color: .red, status: .inStock(quantity: 5))
        let viewModel = ItemViewModel(item: item)
        
        try? await Task.sleep(nanoseconds: 400 * NSEC_PER_MSEC)
        
        XCTAssertFalse(viewModel.nameIsDuplicate)
    }
    
    func testLoadColors() async {
        let item = Item(name: "Test Item", color: .red, status: .inStock(quantity: 5))
        let viewModel = ItemViewModel(item: item)
        
        await viewModel.loadColors()
        
        XCTAssertEqual(viewModel.newColors.count, 1)
        XCTAssertEqual(viewModel.newColors[0].name, "Pink")
    }
    
    func testSetColorPickerNavigation() {
        let item = Item(name: "Test Item", color: .red, status: .inStock(quantity: 5))
        let viewModel = ItemViewModel(item: item)
        
        viewModel.setColorPickerNavigation(isActive: true)
        XCTAssertEqual(viewModel.route, .colorPicker)
        
        viewModel.setColorPickerNavigation(isActive: false)
        XCTAssertNil(viewModel.route)
    }
    
    func testItemUpdate() {
        let item = Item(name: "Test Item", color: .red, status: .inStock(quantity: 5))
        let viewModel = ItemViewModel(item: item)
        
        var updatedItem = item
        updatedItem.name = "Updated Item"
        viewModel.item = updatedItem
        
        XCTAssertEqual(viewModel.item.name, "Updated Item")
    }
}
