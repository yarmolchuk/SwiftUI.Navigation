//
//  ItemRowView.swift
//  SwiftUI.Navigation
//
//  Created by Yarmolchuk on 17.08.2025.
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
            destination: { $item in
                ItemView(item: $item)
                    .navigationBarTitle("Edit")
                    .navigationBarBackButtonHidden(true)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                self.viewModel.cancelButtonTapped()
                            }
                        }
                        ToolbarItem(placement: .primaryAction) {
                            HStack {
                                if self.viewModel.isSaving {
                                    ProgressView()
                                }
                                Button("Save") {
                                    self.viewModel.edit(item: $item.wrappedValue)
                                }
                            }
                            .disabled(self.viewModel.isSaving)
                        }
                    }
            }
        ) {
            HStack {
                VStack(alignment: .leading) {
                    Text(self.viewModel.item.name)
                    
                    switch self.viewModel.item.status {
                    case let .inStock(quantity):
                        Text("In stock: \(quantity)")
                    case let .outOfStock(isOnBackOrder):
                        Text("Out of stock" + (isOnBackOrder ? ": on back order" : ""))
                    }
                }
                
                Spacer()
                
                if let color = self.viewModel.item.color {
                    Rectangle()
                        .frame(width: 30, height: 30)
                        .foregroundColor(color.swiftUIColor)
                        .border(Color.black, width: 1)
                }
                
                Button(action: { self.viewModel.duplicateButtonTapped() }) {
                    Image(systemName: "square.fill.on.square.fill")
                }
                .padding(.leading)
                
                Button(action: { self.viewModel.deleteButtonTapped() }) {
                    Image(systemName: "trash.fill")
                }
                .padding(.leading)
            }
            .buttonStyle(.plain)
            .foregroundColor(self.viewModel.item.status.isInStock ? nil : Color.gray)
            .alert(
                self.viewModel.item.name,
                isPresented: self.$viewModel.route.isPresent(/ItemRowViewModel.Route.deleteAlert),
                actions: {
                    Button("Delete", role: .destructive) {
                        self.viewModel.deleteConfirmationButtonTapped()
                    }
                },
                message: {
                    Text("Are you sure you want to delete this item?")
                }
            )
            .popover(
                unwrap: self.$viewModel.route,
                case: /ItemRowViewModel.Route.duplicate
            ) { $item in
                NavigationView {
                    ItemView(item: $item)
                        .navigationBarTitle("Duplicate")
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Cancel") {
                                    self.viewModel.cancelButtonTapped()
                                }
                            }
                            ToolbarItem(placement: .primaryAction) {
                                Button("Add") {
                                    self.viewModel.duplicate(item: item)
                                }
                            }
                        }
                }
                .frame(minWidth: 300, minHeight: 500)
            }
        }
    }
}
