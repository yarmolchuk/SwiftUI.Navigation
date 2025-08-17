//
//  File.swift
//  SwiftUI.Navigation
//
//  Created by Yarmolchuk on 17.08.2025.
//

import Foundation

final class ItemRowViewModel: Identifiable, ObservableObject {
    @Published var deleteItemAlertIsPresented: Bool
    @Published var item: Item
    
    var onDelete: () -> Void = {}
    
    var id: Item.ID { self.item.id }
    
    init(
        deleteItemAlertIsPresented: Bool = false,
        item: Item
    ) {
        self.deleteItemAlertIsPresented = deleteItemAlertIsPresented
        self.item = item
    }
    
    func deleteButtonTapped() {
        self.deleteItemAlertIsPresented = true
    }
    
    func deleteConfirmationButtonTapped() {
        self.onDelete()
    }
}
