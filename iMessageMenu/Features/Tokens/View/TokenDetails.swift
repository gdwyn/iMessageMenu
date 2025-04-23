//
//  TokenDetails.swift
//  iMessageMenu
//
//  Created by Godwin IE on 23/04/2025.
//

import SwiftUI

struct TokenDetails: View {
    @EnvironmentObject var tokenVM: TokenViewModel
    
    var token: Token

    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 18) {
                    Capsule()
                        .fill(.appGray)
                        .frame(width: 38, height: 5)
                    
                    HStack(spacing: 14) {
                        Image(tokenVM.currentToken.icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 48, height: 48)
                            .clipShape(.circle)
                        
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "heart.fill")
                                .imageScale(.large)
                                .foregroundStyle(.gray)
                            
                        }
                    }
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text(tokenVM.currentToken.name)
                            Text("$1,792.84")
                                .foregroundStyle(.gray)
                        }
                        
                        Spacer()
                        Text("9.21%")
                            .foregroundStyle(.green)
                    }
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.textBlack)
                    
                    RoundedRectangle(cornerRadius: 32, style: .circular)
                        .fill(.appGray.opacity(0.5))
                        .frame(height: 250)
                    
                    RoundedRectangle(cornerRadius: 32, style: .circular)
                        .fill(.appGray.opacity(0.5))
                        .frame(height: 100)
                    
                    RoundedRectangle(cornerRadius: 32, style: .circular)
                        .fill(.appGray.opacity(0.5))
                        .frame(height: 100)
                }
            }
            .padding()
            .scrollIndicators(.hidden)
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    TokenDetails(token: Token(name: "Eth", icon: "eth"))
}
