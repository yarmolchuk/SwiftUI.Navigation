//
//  SwiftUINavigationTests.swift
//  SwiftUI.NavigationTests
//
//  Created by Yarmolchuk on 18.08.2025.
//

import XCTest
import CasePaths
@testable import SwiftUI_Navigation

final class SwiftUINavigationTests: XCTestCase {
    func testAddItem() throws {
        let viewModel = InventoryViewModel()
        viewModel.addButtonTapped()
        
        let itemToAdd = try XCTUnwrap(viewModel.itemToAdd)
        viewModel.add(item: itemToAdd)
        
        XCTAssertNil(viewModel.itemToAdd)
        XCTAssertEqual(viewModel.inventory.count, 1)
        XCTAssertEqual(viewModel.inventory[0].item, itemToAdd)
    }
    
    func testDelete() throws {
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
