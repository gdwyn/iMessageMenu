//
//  iMessageMenuApp.swift
//  iMessageMenu
//
//  Created by Godwin IE on 14/04/2025.
//

import SwiftUI

@main
struct iMessageMenuApp: App {
    @State var messageVM = MessageViewModel()
    @State var speechVM = SpeechViewModel()
    @State var tokenVM = TokenViewModel()

    var body: some Scene {
        WindowGroup {
            ChatView()
                .environment(messageVM)
                .environment(speechVM)
                .environment(tokenVM)
                
        }
    }
}
