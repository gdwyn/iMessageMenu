//
//  TokenCard.swift
//  iMessageMenu
//
//  Created by Godwin IE on 23/04/2025.
//

import SwiftUI

struct TokenCard: View {
    var coin: Coin
    
    var body: some View {
        HStack(spacing: 14) {
            AsyncImage(url: URL(string: coin.image)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            } placeholder: {
                ProgressView()
                    .frame(width: 40, height: 40)
            }
            
            VStack(alignment: .leading) {
                Text(coin.name)
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundStyle(.textBlack)
                
                Text("0 ETH")
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundStyle(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .leading) {
                Text(String(format: "$%.2f", coin.currentPrice))
                    .font(.headline)
                    .fontWeight(.regular)
                    .foregroundStyle(.textBlack)
                
                Text("\(coin.priceChangePercentage)")
                    .font(.headline)
                    .fontWeight(.regular)
                    .foregroundStyle(.green)
            }
        }
        .padding()
        .background(.appGray, in: RoundedRectangle(cornerRadius: 24))
    }
}

#Preview {
    TokenCard(coin: Coin(id: "", symbol: "", name: "Eth", image: "", currentPrice: 0.0, marketCap: 23, marketCapRank: 1, sparkLine: Sparkline(price: []), priceChangePercentage: 2.0))
}
