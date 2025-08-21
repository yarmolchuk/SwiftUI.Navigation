//
//  File.swift
//  SwiftUI.Navigation
//
//  Created by Yarmolchuk on 17.08.2025.
//

import Foundation

final class ItemRowViewModel: Identifiable, ObservableObject {
    @Published var item: Item
    @Published var route: Route?
    @Published var isSaving = false

    enum Route: Equatable {
      case deleteAlert
      case duplicate(Item)
      case edit(Item)
    }
    var id: Item.ID { self.item.id }

    var onDelete: () -> Void = { }
    var onDuplicate: (Item) -> Void = { _ in }

    init(item: Item, route: Route? = nil) {
        self.item = item
        self.route = route
    }
    
    func deleteButtonTapped() {
        route = .deleteAlert
    }
    
    func deleteConfirmationButtonTapped() {
        onDelete()
        route = nil
    }
    
    func setEditNavigation(isActive: Bool) {
        self.route = isActive ? .edit(self.item) : nil
    }
    
    func edit(item: Item) {
        self.isSaving = true
        
        Task { @MainActor in
            try await Task.sleep(nanoseconds: NSEC_PER_SEC)
            
            self.isSaving = false
            self.item = item
            self.route = nil
        }
    }
    
    func cancelButtonTapped() {
        route = nil
    }
    
    func duplicateButtonTapped() {
        route = .duplicate(item.duplicate())
    }
    
    func duplicate(item: Item) {
       onDuplicate(item)
       route = nil
    }
}

extension Item {
    func duplicate() -> Self {
        .init(name: name, color: color, status: status)
    }
}

import SwiftUI
import CasePaths

extension Binding {
  func isPresent<Enum, Case>(_ casePath: AnyCasePath<Enum, Case> ) -> Binding<Bool> where Value == Enum? {
    .init(
      get: {
        if let wrappedValue = self.wrappedValue,
           casePath.extract(from: wrappedValue) != nil {
          return true
        } else {
          return false
        }
      },
      set: { isPresented in
        if !isPresented {
          self.wrappedValue = nil
        }
      }
    )
  }
}

extension Binding {
    func `case`<Enum, Case>(_ casePath: AnyCasePath<Enum, Case>) -> Binding<Case?> where Value == Enum? {
        Binding<Case?>(
            get: {
                guard
                    let wrappedValue = self.wrappedValue,
                    let `case` = casePath.extract(from: wrappedValue)
                else { return nil }
                return `case`
            },
            set: { `case` in
                if let `case` = `case` {
                    self.wrappedValue = casePath.embed(`case`)
                } else {
                    self.wrappedValue = nil
                }
            }
        )
    }
}
