//
//  TokenCard.swift
//  iMessageMenu
//
//  Created by Godwin IE on 23/04/2025.
//

import SwiftUI

struct TokenCard: View {
    var token: Token
    
    var body: some View {
        HStack(spacing: 14) {
            Image(token.icon)
                .resizable()
                .scaledToFit()
                .frame(width: 48, height: 48)
                .clipShape(.circle)
            
            VStack(alignment: .leading) {
                Text(token.name)
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
                Text("$0.00")
                    .font(.headline)
                    .fontWeight(.regular)
                    .foregroundStyle(.textBlack)
                
                Text("9.78%")
                    .font(.headline)
                    .fontWeight(.regular)
                    .foregroundStyle(.green)
            }
        }
        .padding()
        .background(.gray.opacity(0.08), in: RoundedRectangle(cornerRadius: 24))
    }
}

#Preview {
    TokenCard(token: Token(name: "eth", icon: "eth"))
}
