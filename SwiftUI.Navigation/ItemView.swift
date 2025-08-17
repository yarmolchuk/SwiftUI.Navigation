//
//  ItemView.swift
//  SwiftUI.Navigation
//
//  Created by Yarmolchuk on 15.08.2025.
//

import SwiftUI
import CasePaths

struct ItemView: View {
    @Binding var item: Item
    
    var body: some View {
        Form {
            TextField("Name", text: $item.name)
            
            Picker(selection: $item.color, label: Text("Color")) {
                Text("None")
                    .tag(Item.Color?.none)
                
                ForEach(Item.Color.defaults, id: \.name) { color in
                    Text(color.name)
                        .tag(Optional(color))
                }
            }
            
            IfCaseLet(self.$item.status, pattern: /Item.Status.inStock) { $quantity in
                Section(header: Text("In stock")) {
                    Stepper("Quantity: \(quantity)", value: $quantity)
                    
                    Button("Mark as sold out") {
                        self.item.status = .outOfStock(isOnBackOrder: false)
                    }
                }
            }
            
            IfCaseLet(self.$item.status, pattern: /Item.Status.outOfStock) { $isOnBackOrder in
                Section(header: Text("Out of stock")) {
                    Toggle("Is on back order?", isOn: $isOnBackOrder)
                    
                    Button("Is back in stock!") {
                        self.item.status = .inStock(quantity: 1)
                    }
                }
            }
        }
    }
}

struct ItemView_Previews: PreviewProvider {
    struct WrapperView: View {
        @State var item = Item(
            name: "", color: nil, status: .inStock(quantity: 1)
        )
        
        var body: some View {
            ItemView(item: $item)
        }
    }
    
    static var previews: some View {
        NavigationView {
            WrapperView()
        }
    }
}
