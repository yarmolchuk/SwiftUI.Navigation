//
//  InventoryViewModelAdditionalTests.swift
//  SwiftUI.NavigationTests
//
//  Created by Dmytro Yarmolchuk on 18.08.2025.
//

import XCTest
import CasePaths

@testable import SwiftUI_Navigation

final class InventoryViewModelAdditionalTests: XCTestCase {
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
    
    func testCancelButtonTapped() {
        let viewModel = InventoryViewModel()
        
        viewModel.addButtonTapped()
        XCTAssertNotNil(viewModel.route)
        
        viewModel.cancelButtonTapped()
        XCTAssertNil(viewModel.route)
    }
    
    func testAddItemWithAnimation() {
        let viewModel = InventoryViewModel()
        let item = Item(name: "New Item", color: .blue, status: .outOfStock(isOnBackOrder: true))
        
        viewModel.add(item: item)
        
        XCTAssertEqual(viewModel.inventory.count, 1)
        XCTAssertEqual(viewModel.inventory[0].item, item)
        XCTAssertNil(viewModel.route)
    }
    
    func testDeleteItemWithAnimation() {
        let item = Item(name: "Test Item", color: .red, status: .inStock(quantity: 5))
        let viewModel = InventoryViewModel(inventory: [.init(item: item)])
        
        XCTAssertEqual(viewModel.inventory.count, 1)
        
        viewModel.delete(item: item)
        
        XCTAssertEqual(viewModel.inventory.count, 0)
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
    
    func testBindItemRowViewModel() {
        let viewModel = InventoryViewModel()
        let item = Item(name: "Test Item", color: .red, status: .inStock(quantity: 5))
        let itemRowViewModel = ItemRowViewModel(item: item)
        
        viewModel.add(item: item)
        
        XCTAssertEqual(viewModel.inventory.count, 1)
        XCTAssertEqual(viewModel.inventory[0].item, item)
    }
    
    func testMultipleItemsBinding() {
        let viewModel = InventoryViewModel()
        let item1 = Item(name: "Item 1", color: .red, status: .inStock(quantity: 1))
        let item2 = Item(name: "Item 2", color: .blue, status: .inStock(quantity: 2))
        
        viewModel.add(item: item1)
        viewModel.add(item: item2)
        
        XCTAssertEqual(viewModel.inventory.count, 2)
        XCTAssertEqual(viewModel.inventory[0].item, item1)
        XCTAssertEqual(viewModel.inventory[1].item, item2)
    }
    
    func testInitializationWithRoute() {
        let item = Item(name: "Test Item", color: .red, status: .inStock(quantity: 5))
        let itemViewModel = ItemViewModel(item: item)
        let route = InventoryViewModel.Route.add(itemViewModel)
        let viewModel = InventoryViewModel(route: route)
        
        XCTAssertEqual(viewModel.route, route)
        XCTAssertTrue(viewModel.inventory.isEmpty)
    }
    
    func testInitializationWithInventoryAndRoute() {
        let item = Item(name: "Test Item", color: .red, status: .inStock(quantity: 5))
        let itemRowViewModel = ItemRowViewModel(item: item)
        let itemViewModel = ItemViewModel(item: item)
        let route = InventoryViewModel.Route.add(itemViewModel)
        
        let viewModel = InventoryViewModel(
            inventory: [itemRowViewModel],
            route: route
        )
        
        XCTAssertEqual(viewModel.inventory.count, 1)
        XCTAssertEqual(viewModel.inventory[0].item, item)
        XCTAssertEqual(viewModel.route, route)
    }
}
