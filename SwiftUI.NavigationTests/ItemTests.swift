//
//  ItemTests.swift
//  SwiftUI.NavigationTests
//
//  Created by Dmytro Yarmolchuk on 18.08.2025.
//

import XCTest
@testable import SwiftUI_Navigation

final class ItemTests: XCTestCase {
    func testItemInitialization() {
        let item = Item(name: "Test Item", color: .red, status: .inStock(quantity: 5))
        
        XCTAssertEqual(item.name, "Test Item")
        XCTAssertEqual(item.color, .red)
        XCTAssertEqual(item.status, .inStock(quantity: 5))
    }
    
    func testItemWithoutColor() {
        let item = Item(name: "Test Item", color: nil, status: .outOfStock(isOnBackOrder: true))
        
        XCTAssertEqual(item.name, "Test Item")
        XCTAssertNil(item.color)
        XCTAssertEqual(item.status, .outOfStock(isOnBackOrder: true))
    }
    
    func testItemEquality() {
        let item1 = Item(name: "Test Item", color: .red, status: .inStock(quantity: 5))
        let item2 = Item(name: "Test Item", color: .red, status: .inStock(quantity: 5))
        
        XCTAssertNotEqual(item1, item2)
    }
    
    func testItemDuplicate() {
        let originalItem = Item(name: "Test Item", color: .red, status: .inStock(quantity: 5))
        let duplicatedItem = originalItem.duplicate()
        
        XCTAssertEqual(duplicatedItem.name, originalItem.name)
        XCTAssertEqual(duplicatedItem.color, originalItem.color)
        XCTAssertEqual(duplicatedItem.status, originalItem.status)
        XCTAssertNotEqual(duplicatedItem.id, originalItem.id)
    }
    
    func testStatusInStock() {
        let status = Item.Status.inStock(quantity: 10)
        
        XCTAssertTrue(status.isInStock)
        
        if case .inStock(let quantity) = status {
            XCTAssertEqual(quantity, 10)
        } else {
            XCTFail("Expected inStock status")
        }
    }
    
    func testStatusOutOfStock() {
        let status = Item.Status.outOfStock(isOnBackOrder: true)
        
        XCTAssertFalse(status.isInStock)
        
        if case .outOfStock(let isOnBackOrder) = status {
            XCTAssertTrue(isOnBackOrder)
        } else {
            XCTFail("Expected outOfStock status")
        }
    }
    
    func testStatusEquality() {
        let status1 = Item.Status.inStock(quantity: 5)
        let status2 = Item.Status.inStock(quantity: 5)
        let status3 = Item.Status.inStock(quantity: 10)
        let status4 = Item.Status.outOfStock(isOnBackOrder: true)
        
        XCTAssertEqual(status1, status2)
        XCTAssertNotEqual(status1, status3)
        XCTAssertNotEqual(status1, status4)
    }
}

// MARK: - Item.Color Tests

final class ItemColorTests: XCTestCase {
    func testColorInitialization() {
        let color = Item.Color(name: "Custom", red: 0.5, green: 0.3, blue: 0.8)
        
        XCTAssertEqual(color.name, "Custom")
        XCTAssertEqual(color.red, 0.5)
        XCTAssertEqual(color.green, 0.3)
        XCTAssertEqual(color.blue, 0.8)
    }
    
    func testDefaultColors() {
        XCTAssertEqual(Item.Color.red.name, "Red")
        XCTAssertEqual(Item.Color.red.red, 1.0)
        XCTAssertEqual(Item.Color.red.green, 0.0)
        XCTAssertEqual(Item.Color.red.blue, 0.0)
        
        XCTAssertEqual(Item.Color.green.name, "Green")
        XCTAssertEqual(Item.Color.green.red, 0.0)
        XCTAssertEqual(Item.Color.green.green, 1.0)
        XCTAssertEqual(Item.Color.green.blue, 0.0)
        
        XCTAssertEqual(Item.Color.blue.name, "Blue")
        XCTAssertEqual(Item.Color.blue.red, 0.0)
        XCTAssertEqual(Item.Color.blue.green, 0.0)
        XCTAssertEqual(Item.Color.blue.blue, 1.0)
    }
    
    func testColorEquality() {
        let color1 = Item.Color(name: "Test", red: 0.5, green: 0.3, blue: 0.8)
        let color2 = Item.Color(name: "Test", red: 0.5, green: 0.3, blue: 0.8)
        let color3 = Item.Color(name: "Different", red: 0.5, green: 0.3, blue: 0.8)
        
        XCTAssertEqual(color1, color2)
        XCTAssertNotEqual(color1, color3)
    }
    
    func testColorHashable() {
        let color1 = Item.Color(name: "Test", red: 0.5, green: 0.3, blue: 0.8)
        let color2 = Item.Color(name: "Test", red: 0.5, green: 0.3, blue: 0.8)
        
        XCTAssertEqual(color1.hashValue, color2.hashValue)
    }
    
    func testDefaultColorsArray() {
        let defaults = Item.Color.defaults
        
        XCTAssertEqual(defaults.count, 6)
        XCTAssertTrue(defaults.contains(.red))
        XCTAssertTrue(defaults.contains(.green))
        XCTAssertTrue(defaults.contains(.blue))
        XCTAssertTrue(defaults.contains(.black))
        XCTAssertTrue(defaults.contains(.yellow))
        XCTAssertTrue(defaults.contains(.white))
    }
}
