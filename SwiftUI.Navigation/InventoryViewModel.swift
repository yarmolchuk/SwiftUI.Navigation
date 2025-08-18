//
//  InventoryViewModel.swift
//  SwiftUI.Navigation
//
//  Created by Yarmolchuk on 11.08.2025.
//

import IdentifiedCollections
import SwiftUI

final class InventoryViewModel: ObservableObject {
    @Published var inventory: IdentifiedArrayOf<ItemRowViewModel>
    @Published var itemToAdd: Item?
    
    init(
        inventory: IdentifiedArrayOf<ItemRowViewModel> = [],
        itemToAdd: Item? = nil
    ) {
        self.inventory = []
        self.itemToAdd = itemToAdd
        
        for itemRowViewModel in inventory {
            bind(itemRowViewModel: itemRowViewModel)
        }
    }
    
    func add(item: Item) {
        withAnimation {
            bind(itemRowViewModel: .init(item: item))
            itemToAdd = nil
        }
    }
    
    func delete(item: Item) {
        withAnimation {
            _ = inventory.remove(id: item.id)
        }
    }
    
    func cancelButtonTapped() {
        self.itemToAdd = nil
    }
 
    func addButtonTapped() {
        self.itemToAdd = .init(
            name: "", color: nil, status: .inStock(quantity: 1)
        )
        
        Task { @MainActor in
            try await Task.sleep(nanoseconds: 500 * NSEC_PER_MSEC)
            self.itemToAdd?.name = "Bluetooth Keyboard"
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
          itemToAdd: nil
        )
      )
    }
  }
}
