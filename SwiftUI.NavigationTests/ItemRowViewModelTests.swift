//
//  ItemRowViewModelTests.swift
//  SwiftUI.NavigationTests
//
//  Created by Dmytro Yarmolchuk on 18.08.2025.
//

import XCTest
@testable import SwiftUI_Navigation

final class ItemRowViewModelTests: XCTestCase {
    func testInitialization() {
        let item = Item(name: "Test Item", color: .red, status: .inStock(quantity: 5))
        let viewModel = ItemRowViewModel(item: item)
        
        XCTAssertEqual(viewModel.item, item)
        XCTAssertEqual(viewModel.id, item.id)
        XCTAssertNil(viewModel.route)
        XCTAssertFalse(viewModel.isSaving)
    }
    
    func testDeleteConfirmationButtonTapped() {
        let item = Item(name: "Test Item", color: .red, status: .inStock(quantity: 5))
        let viewModel = ItemRowViewModel(item: item)
        var deleteCalled = false
        
        viewModel.onDelete = {
            deleteCalled = true
        }
        
        viewModel.deleteButtonTapped()
        viewModel.deleteConfirmationButtonTapped()
        
        XCTAssertTrue(deleteCalled)
        XCTAssertNil(viewModel.route)
    }
    
    func testSetEditNavigation() {
        let item = Item(name: "Test Item", color: .red, status: .inStock(quantity: 5))
        let viewModel = ItemRowViewModel(item: item)
        
        viewModel.setEditNavigation(isActive: true)
        
        if case .edit(let editViewModel) = viewModel.route {
            XCTAssertEqual(editViewModel.item, item)
        } else {
            XCTFail("Expected edit route")
        }
        
        viewModel.setEditNavigation(isActive: false)
        XCTAssertNil(viewModel.route)
    }
    
    func testEditItem() async {
        let item = Item(name: "Test Item", color: .red, status: .inStock(quantity: 5))
        let viewModel = ItemRowViewModel(item: item)        
        let editedItem = Item(name: "Edited Item", color: .blue, status: .outOfStock(isOnBackOrder: true))

        viewModel.edit(item: editedItem)
        
        XCTAssertTrue(viewModel.isSaving)
        
        try? await Task.sleep(nanoseconds: NSEC_PER_SEC + 100 * NSEC_PER_MSEC)
        
        XCTAssertFalse(viewModel.isSaving)
        XCTAssertEqual(viewModel.item, editedItem)
        XCTAssertNil(viewModel.route)
    }
    
    func testCancelButtonTapped() {
        let item = Item(name: "Test Item", color: .red, status: .inStock(quantity: 5))
        let viewModel = ItemRowViewModel(item: item)
        
        viewModel.setEditNavigation(isActive: true)
        XCTAssertNotNil(viewModel.route)
        
        viewModel.cancelButtonTapped()
        XCTAssertNil(viewModel.route)
    }
    
    func testDuplicateButtonTapped() {
        let item = Item(name: "Test Item", color: .red, status: .inStock(quantity: 5))
        let viewModel = ItemRowViewModel(item: item)
        
        viewModel.duplicateButtonTapped()
        
        if case .duplicate(let duplicateViewModel) = viewModel.route {
            XCTAssertEqual(duplicateViewModel.item.name, item.name)
            XCTAssertEqual(duplicateViewModel.item.color, item.color)
            XCTAssertEqual(duplicateViewModel.item.status, item.status)
            XCTAssertNotEqual(duplicateViewModel.item.id, item.id)
        } else {
            XCTFail("Expected duplicate route")
        }
    }
    
    func testDuplicateItem() {
        let item = Item(name: "Test Item", color: .red, status: .inStock(quantity: 5))
        let viewModel = ItemRowViewModel(item: item)
        var duplicateCalled = false
        var duplicatedItem: Item?
        
        viewModel.onDuplicate = { item in
            duplicateCalled = true
            duplicatedItem = item
        }
        
        let newItem = Item(name: "New Item", color: .blue, status: .outOfStock(isOnBackOrder: false))
        viewModel.duplicate(item: newItem)
        
        XCTAssertTrue(duplicateCalled)
        XCTAssertEqual(duplicatedItem, newItem)
        XCTAssertNil(viewModel.route)
    }
    
    func testItemUpdate() {
        let item = Item(name: "Test Item", color: .red, status: .inStock(quantity: 5))
        let viewModel = ItemRowViewModel(item: item)
        
        var updatedItem = item
        updatedItem.name = "Updated Item"
        viewModel.item = updatedItem
        
        XCTAssertEqual(viewModel.item.name, "Updated Item")
    }
}
