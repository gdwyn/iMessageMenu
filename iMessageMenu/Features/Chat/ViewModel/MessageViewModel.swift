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
    var text: String = "" {
        didSet {
            handleInput(text)
        }
    }
    
    var messages = [
        Message(direction: .incoming, kind: .text("Hello")),
        Message(direction: .outgoing, kind: .text("Hey")),
        Message(direction: .incoming, kind: .text("Welcome"))
    ]
    
    var filteredCoins: [String] = []
    var showSuggestions = false
    
    var sentMessage: Message?
    var showMenu = false
    var showSpeech = false
    
    let allCoins = ["$Solana", "$Ethereum", "$Bonk", "$Send", "$Jupiter", "$Retardio", "$Cloud", "$USDC", "$Fwog", "$Medusa", "$Ye"]

    func handleInput(_ text: String) {
        let pattern = #"\$\w*$"#
        
        guard let match = text.range(of: pattern, options: [.regularExpression, .caseInsensitive]) else {
            withAnimation(.smooth) {
                showSuggestions = false
            }
            return
        }
        
        let matchedText = String(text[match])
        let query = matchedText.replacingOccurrences(of: "$", with: "").lowercased()
        
        // 🛑 If the query starts with a digit, don’t show suggestions
        if query.first?.isNumber == true {
            withAnimation(.smooth) {
                showSuggestions = false
            }
            return
        }

        filteredCoins = query.isEmpty
            ? allCoins
            : allCoins.filter { $0.lowercased().contains(query) }

        withAnimation(.smooth) {
            showSuggestions = true
        }
    }

    func insertCoin(_ coin: String) {
        if let range = text.range(of: #"\$\w*$"#, options: .regularExpression) {
            text.replaceSubrange(range, with: coin)
        }
        withAnimation(.smooth) {
            showSuggestions = false
        }
    }

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
