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
                    .padding(.horizontal)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text(tokenVM.currentToken.name)
                                .font(.system(.title, design: .rounded))
                            Text("$1,792.84")
                                .font(.system(.title3, design: .rounded))
                                .foregroundStyle(.gray)
                        }
                        
                        Spacer()
                        Text("9.21%")
                            .font(.system(.title3, design: .rounded))
                            .foregroundStyle(.green)
                    }
                    .padding(.horizontal)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.textBlack)
                    
                    SparklineView(data: [2, 3, 1, 4, 2, 3, 4, 3, 2, 3, 3, 2.5, 3, 3])
                        .frame(width:360, height: 240)
                        .offset(x: -24)
                        .padding(.top, 38)
                    
                    VStack {
                        RoundedRectangle(cornerRadius: 32, style: .circular)
                            .fill(.appGray.opacity(0.5))
                            .frame(height: 100)
                        
                        RoundedRectangle(cornerRadius: 32, style: .circular)
                            .fill(.appGray.opacity(0.5))
                            .frame(height: 100)
                    }
                    .padding(.horizontal)

                }
            }
            .padding(.top)
            .scrollIndicators(.hidden)
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    TokenDetails(token: Token(name: "Eth", icon: "eth"))
        .environment(TokenViewModel())

}
