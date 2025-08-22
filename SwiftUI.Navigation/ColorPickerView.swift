//
//  ColorPickerView.swift
//  SwiftUI.Navigation
//
//  Created by Dmytro Yarmolchuk on 22.08.2025.
//

import SwiftUI

struct ColorPickerView: View {
    @ObservedObject var viewModel: ItemViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form {
            Button(action: {
                viewModel.item.color = nil
                dismiss()
            }) {
                HStack {
                    Text("None")
                    
                    Spacer()
                    
                    if viewModel.item.color == nil {
                        Image(systemName: "checkmark")
                    }
                }
            }
            
            Section(header: Text("Default colors")) {
                ForEach(Item.Color.defaults, id: \.name) { color in
                    Button(action: {
                        viewModel.item.color = color
                        dismiss()
                    }) {
                        HStack {
                            Text(color.name)
                            
                            Spacer()
                            
                            if viewModel.item.color == color {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            }
            
            if !viewModel.newColors.isEmpty {
                Section(header: Text("New colors")) {
                    ForEach(viewModel.newColors, id: \.name) { color in
                        Button(action: {
                            viewModel.item.color = color
                            dismiss()
                        }) {
                            HStack {
                                Text(color.name)
                                Spacer()
                                if viewModel.item.color == color {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                }
            }
        }
        .task {
            await viewModel.loadColors()
        }
    }
}
