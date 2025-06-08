//
//  TokenViewModel.swift
//  iMessageMenu
//
//  Created by Godwin IE on 23/04/2025.
//


import Foundation
import SwiftUI

@Observable
class TokenViewModel {
    var currentCoin: Coin = Coin(id: "", symbol: "", name: "Nil", image: "", currentPrice: 0.0, marketCap: 23, marketCapRank: 1, sparkLine: Sparkline(price: []), priceChangePercentage: 2.0)
    
//    var tokens = [
//        Token(name: "Ethereum", icon: "eth"),
//        Token(name: "Solana", icon: "eth"),
//        Token(name: "Bonk", icon: "bonk"),
//        Token(name: "BNB", icon: "eth"),
//        Token(name: "Sui", icon: "eth")
//    ]
//    
    var coinService = CoinDataService()
    var coins = [Coin]()
    var topGainers: [Coin] {
        return Array(self.coins.sorted(by: { $0.priceChangePercentage > $1.priceChangePercentage }).prefix(10))
    }
    var errorMsg : String?
    
    var pageLimit = 20
    var page = 0

    func fetchCoins() async throws {
        do {
//            page += 1
            self.coins.append(contentsOf: try await coinService.fetchCoins(pageLimit: pageLimit, page: page))
            
        } catch let coinError as CoinAPIError { // catch custom errors
            self.errorMsg = coinError.customDescription
            
        } catch { // catch generic errors
            self.errorMsg = error.localizedDescription
        }
    }
    
    func LoadCoins() {
        Task(priority: .medium) {
            try await fetchCoins()
        }
    }
    
    func refreshCoins() async {
        coins.removeAll()
        page = 0
        try? await fetchCoins()
    }
}




//struct Token: Identifiable, Hashable {
//    var id = UUID()
//    var name: String
//    var icon: String
//}
