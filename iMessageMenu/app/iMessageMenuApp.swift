//
//  iMessageMenuApp.swift
//  iMessageMenu
//
//  Created by Godwin IE on 14/04/2025.
//

import SwiftUI

@main
struct iMessageMenuApp: App {
    @State var viewModel = MessageViewModel()

    var body: some Scene {
        WindowGroup {
            ChatView()
                .environmentObject(viewModel)
        }
    }
}
