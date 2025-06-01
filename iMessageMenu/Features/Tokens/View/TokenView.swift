//
//  TokenView.swift
//  iMessageMenu
//
//  Created by Godwin IE on 23/04/2025.
//

import SwiftUI

struct TokenView: View {
    @Environment(TokenViewModel.self) var tokenVM
    @Namespace var tokenAnimation

    var body: some View {
        NavigationStack {
            VStack {
                if let error = tokenVM.errorMsg {
                    VStack {
                        ProgressView(error)
                    }
                } else {
                    VStack(spacing: 24) {
                        ScrollView {
                            VStack {
                                ForEach(tokenVM.coins) { coin in
                                    NavigationLink(value: coin) {
                                        TokenCard(coin: coin)
                                            .matchedTransitionSource(id: coin.id, in: tokenAnimation)
                                    }
                                }
                            }
                        }
//                        .padding(.vertical)
                        .scrollIndicators(.hidden)
                    }
                    
                }
            }
            .padding(.horizontal)
            .navigationBarBackButtonHidden()
            .navigationDestination(for: Coin.self) { coin in
                TokenDetails(coin: coin)
                    .navigationTransition(.zoom(sourceID: coin.id, in: tokenAnimation))
                    .onAppear {
                        tokenVM.currentCoin = coin
                    }
            }
        }
    }
}

#Preview {
    TokenView()
        .environment(TokenViewModel())
}
