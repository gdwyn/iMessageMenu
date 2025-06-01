//
//  Coin.swift
//  iMessageMenu
//
//  Created by gdwyn on 31/05/2025.
//


struct Coin: Decodable, Identifiable, Hashable {
    let id: String
    let symbol: String
    let name: String
    let image: String
    let currentPrice: Double
    let marketCap: Int
    let marketCapRank: Int
    let sparkLine: Sparkline
    let priceChangePercentage: Double

    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCapRank = "market_cap_rank"
        case marketCap = "market_cap"
        case sparkLine = "sparkline_in_7d"
        case priceChangePercentage = "price_change_percentage_24h"
    }
}

struct Sparkline: Decodable, Hashable {
    let price: [Double]
}
