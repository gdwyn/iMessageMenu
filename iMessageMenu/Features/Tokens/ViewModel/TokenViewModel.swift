//
//  TokenViewModel.swift
//  iMessageMenu
//
//  Created by Godwin IE on 23/04/2025.
//


import Foundation
import SwiftUI

@Observable
class TokenViewModel: ObservableObject {
    var currentToken: Token = Token(name: "Nil token", icon: "bonk")
    
    var tokens = [
        Token(name: "Ethereum", icon: "eth"),
        Token(name: "Solana", icon: "eth"),
        Token(name: "Bonk", icon: "bonk"),
        Token(name: "BNB", icon: "eth"),
        Token(name: "Sui", icon: "eth")
    ]
}




struct Token: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var icon: String
}
