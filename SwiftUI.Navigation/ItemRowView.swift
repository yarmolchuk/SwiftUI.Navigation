//
//  ItemRowView.swift
//  SwiftUI.Navigation
//
//  Created by Yarmolchuk on 17.08.2025.
//

import SwiftUI

struct ItemRowView: View {
    @ObservedObject var viewModel: ItemRowViewModel
    
    var body: some View {
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
            
            Button(action: { self.viewModel.deleteButtonTapped() }) {
                Image(systemName: "trash.fill")
            }
            .padding(.leading)
        }
        .buttonStyle(.plain)
        .foregroundColor(self.viewModel.item.status.isInStock ? nil : Color.gray)
        .alert(
            self.viewModel.item.name,
            isPresented: self.$viewModel.deleteItemAlertIsPresented,
            actions: {
                Button("Delete", role: .destructive) {
                    self.viewModel.deleteConfirmationButtonTapped()
                }
            },
            message: {
                Text("Are you sure you want to delete this item?")
            }
        )
    }
}
