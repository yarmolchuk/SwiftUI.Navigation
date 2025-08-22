//
//  SwiftUINavigationTests.swift
//  SwiftUI.NavigationTests
//
//  Created by Dmytro Yarmolchuk on 18.08.2025.
//

import XCTest
import CasePaths
@testable import SwiftUI_Navigation

final class SwiftUINavigationTests: XCTestCase {
    func testAddItem() throws {
        let viewModel = InventoryViewModel()
        viewModel.addButtonTapped()

        let itemToAdd = try XCTUnwrap(
            (/InventoryViewModel.Route.add).extract(from: XCTUnwrap(viewModel.route))
        )
        
        viewModel.add(item: itemToAdd)
        
        XCTAssertNil(viewModel.route)
        XCTAssertEqual(viewModel.inventory.count, 1)
        XCTAssertEqual(viewModel.inventory[0].item, itemToAdd)
    }
    
    func testDeleteItem() throws {
        let viewModel = InventoryViewModel(
            inventory: [
                .init(
                    item: Item(
                        name: "Keyboard",
                        color: .red,
                        status: .inStock(quantity: 1)
                    )
                )
            ]
        )
        viewModel.inventory[0].deleteButtonTapped()
    
        XCTAssertEqual(viewModel.inventory[0].route, .deleteAlert)
        XCTAssertEqual(
            viewModel.route,
            .row(id: viewModel.inventory[0].id, route: .deleteAlert)
        )
        
        viewModel.inventory[0].deleteConfirmationButtonTapped()
        
        XCTAssertEqual(viewModel.inventory.count, 0)
        XCTAssertEqual(viewModel.route, nil)
    }
    
    func testEditItem() async throws {
        let item = Item(
            name: "Keyboard",
            color: .red,
            status: .inStock(quantity: 1)
        )
        
        let viewModel = InventoryViewModel(inventory: [.init(item: item)])
        
        viewModel.inventory[0].setEditNavigation(isActive: true)
        
        XCTAssertNotNil(
            (/ItemRowViewModel.Route.edit).extract(from: viewModel.inventory[0].route)
        )
        
        var editedItem = item
        editedItem.color = .blue
        viewModel.inventory[0].route = .edit(editedItem)
        viewModel.inventory[0].edit(item: editedItem)
        
        XCTAssertEqual(viewModel.inventory[0].isSaving, true)
        
        try await Task.sleep(nanoseconds: NSEC_PER_SEC + 100 * NSEC_PER_MSEC)
        
        XCTAssertNil(viewModel.inventory[0].route)
        XCTAssertNil(viewModel.route)
        XCTAssertEqual(viewModel.inventory[0].item, editedItem)
        XCTAssertEqual(viewModel.inventory[0].isSaving, false)
    }
    
    func testDuplicateItem() throws {
        let item = Item(
            name: "Keyboard",
            color: .red,
            status: .inStock(quantity: 1)
        )
        let viewModel = InventoryViewModel(
            inventory: [
                .init(item: item)
            ]
        )
        viewModel.inventory[0].duplicateButtonTapped()
        
        XCTAssertNotNil(
          (/ItemRowViewModel.Route.duplicate)
            .extract(from: try XCTUnwrap(viewModel.inventory[0].route))
        )
        
        let dupe = item.duplicate()
        viewModel.inventory[0].duplicate(item: dupe)
        
        XCTAssertEqual(viewModel.inventory.count, 2)
        XCTAssertEqual(viewModel.inventory[0].item, item)
        XCTAssertEqual(viewModel.inventory[1].item, dupe)
        XCTAssertNil(viewModel.inventory[0].route)
    }
}
