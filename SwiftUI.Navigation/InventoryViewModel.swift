//
//  InventoryViewModel.swift
//  SwiftUI.Navigation
//
//  Created by Dmytro Yarmolchuk on 11.08.2025.
//

import IdentifiedCollections
import CasePaths
import SwiftUI

final class InventoryViewModel: ObservableObject {
    @Published var inventory: IdentifiedArrayOf<ItemRowViewModel>
    @Published var route: Route?

    enum Route: Equatable {
        case add(ItemViewModel)
        case row(id: ItemRowViewModel.ID, route: ItemRowViewModel.Route)
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case let (.add(lhs), .add(rhs)):
                return lhs === rhs
                
            case let (
                .row(id: lhsId, route: lhsRoute),
                .row(id: rhsId, route: rhsRoute)
            ):
                return lhsId == rhsId && lhsRoute == rhsRoute
                
            case (.add, .row), (.row, .add):
                return false
            }
        }
    }
    
    init(
        inventory: IdentifiedArrayOf<ItemRowViewModel> = [],
        route: Route? = nil
    ) {
        self.inventory = []
        self.route = route
        
        for itemRowViewModel in inventory {
            bind(itemRowViewModel: itemRowViewModel)
        }
    }
    
    func add(item: Item) {
        withAnimation {
            bind(itemRowViewModel: .init(item: item))
            route = nil
        }
    }
    
    func delete(item: Item) {
        withAnimation {
            _ = inventory.remove(id: item.id)
        }
    }
    
    func cancelButtonTapped() {
        route = nil
    }
 
    func addButtonTapped() {
        route = .add(
            .init(
                item: .init(name: "", color: nil, status: .inStock(quantity: 1))
            )
        )
        
        Task { @MainActor in
            try await Task.sleep(nanoseconds: 500 * NSEC_PER_MSEC)
            try (/Route.add).modify(&route) {
                $0.item.name = "Bluetooth Keyboard"
            }
        }
    }
    
    private func bind(itemRowViewModel: ItemRowViewModel) {
        itemRowViewModel.onDelete = { [weak self, item = itemRowViewModel.item] in
            withAnimation {
                self?.delete(item: item)
            }
        }
        itemRowViewModel.onDuplicate = { [weak self] item in
            withAnimation {
                self?.add(item: item)
            }
        }
        itemRowViewModel.$route
            .map { [id = itemRowViewModel.id] route in
                route.map { .row(id: id, route: $0) }
            }
            .removeDuplicates()
            .dropFirst()
            .assign(to: &$route)
        
        $route
            .map { [id = itemRowViewModel.id] route in
                guard
                    case let .row(id: routeRowId, route: route) = route,
                    id == routeRowId
                else { return nil }
                return route
            }
            .assign(to: &itemRowViewModel.$route)
        
        self.inventory.append(itemRowViewModel)
    }
}

struct InventoryView_Previews: PreviewProvider {
  static var previews: some View {
    let keyboard = Item(name: "Keyboard", color: .blue, status: .inStock(quantity: 100))
    
    NavigationView {
      InventoryView(
        viewModel: .init(
          inventory: [
            .init(item: keyboard),
            .init(item: Item(name: "Charger", color: .yellow, status: .inStock(quantity: 20))),
            .init(item: Item(name: "Phone", color: .green, status: .outOfStock(isOnBackOrder: true))),
            .init(item: Item(name: "Headphones", color: .green, status: .outOfStock(isOnBackOrder: false))),
          ],
          route: nil
        )
      )
    }
  }
}
