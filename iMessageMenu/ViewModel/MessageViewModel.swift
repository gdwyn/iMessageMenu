//
//  ViewModel.swift
//  iMessageMenu
//
//  Created by Godwin IE on 14/04/2025.
//

import Foundation
import SwiftUI

@Observable
class MessageViewModel: ObservableObject {
    
    var messages = [
        Message(direction: .incoming, kind: .text("")),
        Message(direction: .outgoing, kind: .text("")),
        Message(direction: .incoming, kind: .text(""))
    ]
    
    var text = ""
    var sentMessage: Message?
    var showMenu = false

    func submit() {
        guard !text.isEmpty else { return }
        
        let message = Message(direction: .outgoing, kind: .text(text))
        text = ""
        
        sentMessage = message
        withAnimation(.smooth(duration: 0.2)) {
            messages.append(message)
            sentMessage = nil
        }
    }
}
