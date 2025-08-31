//
//  InventoryViewModelCorrectedTests.swift
//  SwiftUI.NavigationTests
//
//  Created by Dmytro Yarmolchuk on 18.08.2025.
//

import XCTest
import CasePaths

@testable import SwiftUI_Navigation

final class InventoryViewModelCorrectedTests: XCTestCase {
    func testInitializationWithEmptyInventory() {
        let viewModel = InventoryViewModel()
        
        XCTAssertTrue(viewModel.inventory.isEmpty)
        XCTAssertNil(viewModel.route)
    }
    
    func testInitializationWithInventory() {
        let item = Item(name: "Test Item", color: .red, status: .inStock(quantity: 5))
        let itemRowViewModel = ItemRowViewModel(item: item)
        let viewModel = InventoryViewModel(inventory: [itemRowViewModel])
        
        XCTAssertEqual(viewModel.inventory.count, 1)
        XCTAssertEqual(viewModel.inventory[0].item, item)
    }
    
    func testInitializationWithRoute() {
        let item = Item(name: "Test Item", color: .red, status: .inStock(quantity: 5))
        let itemViewModel = ItemViewModel(item: item)
        let route = InventoryViewModel.Route.add(itemViewModel)
        
        let viewModel = InventoryViewModel(route: route)
        
        XCTAssertEqual(viewModel.route, route)
        XCTAssertTrue(viewModel.inventory.isEmpty)
    }
    
    func testAddButtonTapped() {
        let viewModel = InventoryViewModel()
        
        viewModel.addButtonTapped()
        
        if case .add(let itemViewModel) = viewModel.route {
            XCTAssertEqual(itemViewModel.item.name, "")
            XCTAssertNil(itemViewModel.item.color)
            XCTAssertEqual(itemViewModel.item.status, .inStock(quantity: 1))
        } else {
            XCTFail("Expected add route")
        }
    }
    
    func testAddButtonTappedWithAsyncUpdate() async {
        let viewModel = InventoryViewModel()
        viewModel.addButtonTapped()
        
        if case .add(let itemViewModel) = viewModel.route {
            XCTAssertEqual(itemViewModel.item.name, "")

            try? await Task.sleep(nanoseconds: 600 * NSEC_PER_MSEC)
            
            if case .add(let updatedItemViewModel) = viewModel.route {
                XCTAssertEqual(updatedItemViewModel.item.name, "Bluetooth Keyboard")
            } else {
                XCTFail("Expected add route after async update")
            }
        } else {
            XCTFail("Expected add route")
        }
    }
    
    func testCancelButtonTapped() {
        let viewModel = InventoryViewModel()
        
        viewModel.addButtonTapped()
        XCTAssertNotNil(viewModel.route)
        
        viewModel.cancelButtonTapped()
        XCTAssertNil(viewModel.route)
    }
    
    func testAddItem() {
        let viewModel = InventoryViewModel()
        let item = Item(name: "New Item", color: .blue, status: .outOfStock(isOnBackOrder: true))
        
        viewModel.add(item: item)
        
        XCTAssertEqual(viewModel.inventory.count, 1)
        XCTAssertEqual(viewModel.inventory[0].item, item)
        XCTAssertNil(viewModel.route)
    }
    
    func testDeleteItem() {
        let item = Item(name: "Test Item", color: .red, status: .inStock(quantity: 5))
        let viewModel = InventoryViewModel(inventory: [.init(item: item)])
        
        XCTAssertEqual(viewModel.inventory.count, 1)
        
        viewModel.delete(item: item)
        
        XCTAssertEqual(viewModel.inventory.count, 0)
    }
    
    func testDuplicateItemThroughCallback() {
        let viewModel = InventoryViewModel()
        let item = Item(name: "Test Item", color: .red, status: .inStock(quantity: 5))
        
        viewModel.add(item: item)
        XCTAssertEqual(viewModel.inventory.count, 1)
        
        viewModel.inventory[0].duplicateButtonTapped()
        
        if case .row(_, let route) = viewModel.route {
            if case .duplicate(let duplicateViewModel) = route {
                viewModel.inventory[0].duplicate(item: duplicateViewModel.item)
                
                XCTAssertEqual(viewModel.inventory.count, 2)
                XCTAssertEqual(viewModel.inventory[0].item, item)
                XCTAssertEqual(viewModel.inventory[1].item, duplicateViewModel.item)
            } else {
                XCTFail("Expected duplicate route")
            }
        } else {
            XCTFail("Expected row route")
        }
    }
    
    func testRouteBindingToItemRow() {
        let viewModel = InventoryViewModel()
        let item = Item(name: "Test Item", color: .red, status: .inStock(quantity: 5))
        
        viewModel.add(item: item)
        
        let itemViewModel = ItemViewModel(item: item)
        viewModel.route = .row(id: viewModel.inventory[0].id, route: .edit(itemViewModel))
        
        if case .edit(let editViewModel) = viewModel.inventory[0].route {
            XCTAssertEqual(editViewModel.item, item)
        } else {
            XCTFail("Expected edit route in ItemRowViewModel")
        }
    }
    
    func testRouteEquality() {
        let itemViewModel1 = ItemViewModel(item: Item(name: "Item 1", color: .red, status: .inStock(quantity: 1)))
        let itemViewModel2 = ItemViewModel(item: Item(name: "Item 2", color: .blue, status: .inStock(quantity: 2)))
        
        let route1 = InventoryViewModel.Route.add(itemViewModel1)
        let route2 = InventoryViewModel.Route.add(itemViewModel1)
        let route3 = InventoryViewModel.Route.add(itemViewModel2)
        let route4 = InventoryViewModel.Route.row(id: UUID(), route: .deleteAlert)
        
        XCTAssertEqual(route1, route2)
        XCTAssertNotEqual(route1, route3)
        XCTAssertNotEqual(route1, route4)
    }

    func testMultipleItems() {
        let viewModel = InventoryViewModel()
        
        let item1 = Item(name: "Item 1", color: .red, status: .inStock(quantity: 1))
        let item2 = Item(name: "Item 2", color: .blue, status: .inStock(quantity: 2))
        let item3 = Item(name: "Item 3", color: .green, status: .outOfStock(isOnBackOrder: true))
        
        viewModel.add(item: item1)
        viewModel.add(item: item2)
        viewModel.add(item: item3)
        
        XCTAssertEqual(viewModel.inventory.count, 3)
        XCTAssertEqual(viewModel.inventory[0].item, item1)
        XCTAssertEqual(viewModel.inventory[1].item, item2)
        XCTAssertEqual(viewModel.inventory[2].item, item3)
        
        viewModel.delete(item: item2)
        
        XCTAssertEqual(viewModel.inventory.count, 2)
        XCTAssertEqual(viewModel.inventory[0].item, item1)
        XCTAssertEqual(viewModel.inventory[1].item, item3)
    }
}
