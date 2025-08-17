//
//  InventoryView.swift
//  SwiftUI.Navigation
//
//  Created by Yarmolchuk on 11.08.2025.
//

import SwiftUI

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
        .sheet(unwrap: self.$viewModel.itemToAdd) { $itemToAdd in
            NavigationView {
                ItemView(item: $itemToAdd)
                    .navigationTitle("Add")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                self.viewModel.cancelButtonTapped()
                            }
                        }
                        ToolbarItem(placement: .primaryAction) {
                            Button("Save") {
                                self.viewModel.add(item: itemToAdd)
                            }
                        }
                    }
            }
        }
    }
}

#Preview {
    NavigationView {
        let keyboard = Item(
            name: "Keyboard",
            color: .blue,
            status: .inStock(quantity: 100)
        )
        
        InventoryView(viewModel: .init())
    }
}
