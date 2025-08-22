//
//  SwiftUI_NavigationApp.swift
//  SwiftUI.Navigation
//
//  Created by Dmytro Yarmolchuk on 11.08.2025.
//

import SwiftUI

@main
struct SwiftUI_NavigationApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                viewModel: .init(
                    inventoryViewModel: .init(inventory: []),
                    selectedTab: .one
                )
            )
        }
    }
}
