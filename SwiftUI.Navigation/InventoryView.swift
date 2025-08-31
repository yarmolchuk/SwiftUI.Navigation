//
//  InventoryView.swift
//  SwiftUI.Navigation
//
//  Created by Dmytro Yarmolchuk on 11.08.2025.
//

import SwiftUI
import CasePaths

struct InventoryView: View {
    @ObservedObject var viewModel: InventoryViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.inventory, content: ItemRowView.init(viewModel:))
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Add") {
                    self.viewModel.addButtonTapped()
                }
            }
        }
        .navigationTitle("Inventory")
        .sheet(unwrap: $viewModel.route.case(/InventoryViewModel.Route.add)) { $itemToAdd in
            NavigationView {
                ItemView(viewModel: itemToAdd)
                    .navigationTitle("Add")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                viewModel.cancelButtonTapped()
                            }
                        }
                        ToolbarItem(placement: .primaryAction) {
                            Button("Save") {
                                viewModel.add(item: itemToAdd.item)
                            }
                        }
                    }
            }
        }
    }
}

#Preview {
    NavigationView {
        InventoryView(
            viewModel: .init(
                inventory: [
                    .init(item: Item(name: "Keyboard", color: .blue, status: .inStock(quantity: 100))),
                    .init(item: Item(name: "Charger", color: .yellow, status: .inStock(quantity: 20))),
                    .init(item: Item(name: "Phone", color: .green, status: .outOfStock(isOnBackOrder: true))),
                    .init(item: Item(name: "Headphones", color: .green, status: .outOfStock(isOnBackOrder: false))),
                ],
                route: nil
            )
        )
    }
}
