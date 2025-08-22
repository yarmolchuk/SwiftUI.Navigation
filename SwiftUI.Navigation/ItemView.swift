//
//  ItemView.swift
//  SwiftUI.Navigation
//
//  Created by Dmytro Yarmolchuk on 15.08.2025.
//

import SwiftUI
import CasePaths

struct ItemView: View {
    @ObservedObject var viewModel: ItemViewModel
    @State var nameIsDuplicate = false
    
    var body: some View {
        Form {
            TextField("Name", text: $viewModel.item.name)
                .background(
                    viewModel.nameIsDuplicate ? Color.red.opacity(0.1) : Color.clear
                )
            
            NavigationLink(
                unwrap: $viewModel.route,
                case: /ItemViewModel.Route.colorPicker,
                onNavigate: viewModel.setColorPickerNavigation(isActive:),
                destination: { _ in ColorPickerView(viewModel: viewModel) }
            ) {
                HStack {
                    Text("Color")
                    Spacer()
                    
                    if let color = viewModel.item.color {
                        Rectangle()
                            .frame(width: 30, height: 30)
                            .foregroundColor(color.swiftUIColor)
                            .border(Color.black, width: 1)
                    }
                    Text(viewModel.item.color?.name ?? "None")
                        .foregroundColor(.gray)
                }
            }
            
            IfCaseLet(
                $viewModel.item.status,
                pattern: /Item.Status.inStock
            ) { $quantity in
                Section(header: Text("In stock")) {
                    Stepper("Quantity: \(quantity)", value: $quantity)
                    Button("Mark as sold out") {
                        self.viewModel.item.status = .outOfStock(isOnBackOrder: false)
                    }
                }
            }
            
            IfCaseLet(
                $viewModel.item.status,
                pattern: /Item.Status.outOfStock
            ) { $isOnBackOrder in
                Section(header: Text("Out of stock")) {
                    Toggle("Is on back order?", isOn: $isOnBackOrder)
                    Button("Is back in stock!") {
                        self.viewModel.item.status = .inStock(quantity: 1)
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        ItemView(
            viewModel: .init(
                item: Item(
                    name: "Phone",
                    color: .red,
                    status: .inStock(quantity: 1)
                )
            )
        )
    }
}
