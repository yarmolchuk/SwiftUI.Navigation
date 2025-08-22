//
//  ItemViewModel.swift
//  SwiftUI.Navigation
//
//  Created by Yarmolchuk on 22.08.2025.
//

import Foundation

final class ItemViewModel: Identifiable, ObservableObject {
    @Published var item: Item
    @Published var nameIsDuplicate = false
    @Published var newColors: [Item.Color] = []
    @Published var route: Route?
    
    var id: Item.ID { item.id }
    
    enum Route {
        case colorPicker
    }
    
    init(item: Item, route: Route? = nil) {
        self.item = item
        self.route = route
        
        Task { @MainActor in
            for await item in self.$item.values {
                try await Task.sleep(nanoseconds: NSEC_PER_MSEC * 300)
                nameIsDuplicate = item.name == "Keyboard"
            }
        }
    }
    
    @MainActor
    func loadColors() async {
        try? await Task.sleep(nanoseconds: NSEC_PER_SEC)
        newColors = [
            .init(name: "Pink", red: 1, green: 0.7, blue: 0.7)
        ]
    }
    
    func setColorPickerNavigation(isActive: Bool) {
        route = isActive ? .colorPicker : nil
    }
}
