//
//  ItemRowView.swift
//  SwiftUI.Navigation
//
//  Created by Dmytro Yarmolchuk on 17.08.2025.
//

import SwiftUI
import CasePaths

struct ItemRowView: View {
    @ObservedObject var viewModel: ItemRowViewModel
    
    var body: some View {
        NavigationLink(
            unwrap: $viewModel.route,
            case: /ItemRowViewModel.Route.edit,
            onNavigate: viewModel.setEditNavigation(isActive:),
            destination: { $itemViewModel in
                ItemView(viewModel: itemViewModel)
                    .navigationBarTitle("Edit")
                    .navigationBarBackButtonHidden(true)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                viewModel.cancelButtonTapped()
                            }
                        }
                        ToolbarItem(placement: .primaryAction) {
                            HStack {
                                if viewModel.isSaving {
                                    ProgressView()
                                }
                                Button("Save") {
                                    viewModel.edit(item: itemViewModel.item)
                                }
                            }
                            .disabled(viewModel.isSaving)
                        }
                    }
            }
        ) {
            HStack {
                VStack(alignment: .leading) {
                    Text(viewModel.item.name)
                    
                    switch viewModel.item.status {
                    case let .inStock(quantity):
                        Text("In stock: \(quantity)")
                        
                    case let .outOfStock(isOnBackOrder):
                        Text("Out of stock" + (isOnBackOrder ? ": on back order" : ""))
                    }
                }
                
                Spacer()
                
                if let color = viewModel.item.color {
                    Rectangle()
                        .frame(width: 30, height: 30)
                        .foregroundColor(color.swiftUIColor)
                        .border(Color.black, width: 1)
                }
                
                Button(action: { viewModel.duplicateButtonTapped() }) {
                    Image(systemName: "square.fill.on.square.fill")
                }
                .padding(.leading)
                
                Button(action: { viewModel.deleteButtonTapped() }) {
                    Image(systemName: "trash.fill")
                }
                .padding(.leading)
            }
            .buttonStyle(.plain)
            .foregroundColor(viewModel.item.status.isInStock ? nil : Color.gray)
            .alert(
                viewModel.item.name,
                isPresented: $viewModel.route.isPresent(/ItemRowViewModel.Route.deleteAlert),
                actions: {
                    Button("Delete", role: .destructive) {
                        viewModel.deleteConfirmationButtonTapped()
                    }
                },
                message: {
                    Text("Are you sure you want to delete this item?")
                }
            )
            .popover(
                item: $viewModel.route.case(/ItemRowViewModel.Route.duplicate)
            ) { itemViewModel in
                NavigationView {
                    ItemView(viewModel: itemViewModel)
                        .navigationBarTitle("Duplicate")
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Cancel") {
                                    viewModel.cancelButtonTapped()
                                }
                            }
                            ToolbarItem(placement: .primaryAction) {
                                Button("Add") {
                                    viewModel.duplicate(item: itemViewModel.item)
                                }
                            }
                        }
                }
                .frame(minWidth: 300, minHeight: 500)
            }
        }
    }
}
