//
//  TokenView.swift
//  iMessageMenu
//
//  Created by Godwin IE on 23/04/2025.
//

import SwiftUI

struct TokenView: View {
    @EnvironmentObject var tokenVM: TokenViewModel
    @Namespace var tokenAnimation

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                ScrollView {
                    VStack {
                        ForEach(tokenVM.tokens) { token in
                            NavigationLink(value: token) {
                                TokenCard(token: token)
                                    .matchedTransitionSource(id: token.id.uuidString, in: tokenAnimation)
                            }
                        }
                    }
                }
                .padding(.vertical)
                .scrollIndicators(.hidden)
            }
            .padding(.horizontal)
            .navigationBarBackButtonHidden()
            .navigationDestination(for: Token.self) { token in
                TokenDetails(token: token)
                    .navigationTransition(.zoom(sourceID: token.id.uuidString, in: tokenAnimation))
                    .onAppear {
                        tokenVM.currentToken = token
                    }
            }
        }
    }
}

#Preview {
    TokenView()
}
