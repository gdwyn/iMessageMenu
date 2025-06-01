////
////  TokenDetails.swift
////  iMessageMenu
////
////  Created by Godwin IE on 23/04/2025.
////
//
//import SwiftUI
//
//struct TokenDetails: View {    
//    var coin: Coin
//
//    var body: some View {
//        VStack {
//            ScrollView {
//                VStack(spacing: 18) {
//                    Capsule()
//                        .fill(.appGray)
//                        .frame(width: 38, height: 5)
//                    
//                    HStack(spacing: 14) {
//                        AsyncImage(url: URL(string: coin.image)) { image in
//                            image
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(width: 40, height: 40)
//                                .clipShape(Circle())
//                        } placeholder: {
//                            ProgressView()
//                                .frame(width: 40, height: 40)
//                        }
//                        
//                        Spacer()
//                        
//                        Button {
//                            
//                        } label: {
//                            Image(systemName: "heart.fill")
//                                .imageScale(.large)
//                                .foregroundStyle(.gray)
//                            
//                        }
//                    }
//                    .padding(.horizontal)
//                    
//                    HStack {
//                        VStack(alignment: .leading) {
//                            Text(coin.name)
//                                .font(.system(.title, design: .rounded))
//                            Text("$\(coin.currentPrice)")
//                                .font(.system(.title3, design: .rounded))
//                                .foregroundStyle(.gray)
//                        }
//                        
//                        Spacer()
//                        Text("\(coin.priceChangePercentage)")
//                            .font(.system(.title3, design: .rounded))
//                            .foregroundStyle(.green)
//                    }
//                    .padding(.horizontal)
//                    .font(.title3)
//                    .fontWeight(.bold)
//                    .foregroundStyle(.textBlack)
//                    
//                    SparklineView(data: coin.sparkLine.price)
//                        .frame(width:360, height: 240)
//                        .offset(x: -24)
//                        .padding(.top, 38)
//                    
//                    VStack {
//                        RoundedRectangle(cornerRadius: 32, style: .circular)
//                            .fill(.appGray.opacity(0.5))
//                            .frame(height: 100)
//                        
//                        RoundedRectangle(cornerRadius: 32, style: .circular)
//                            .fill(.appGray.opacity(0.5))
//                            .frame(height: 100)
//                    }
//                    .padding(.horizontal)
//
//                }
//            }
//            .padding(.top)
//            .scrollIndicators(.hidden)
//        }
//        .navigationBarBackButtonHidden()
//    }
//}
//
//#Preview {
//    TokenDetails(coin: Coin(id: "", symbol: "", name: "Nil", image: "", currentPrice: 0.0, marketCap: 23, marketCapRank: 1, sparkLine: Sparkline(price: []), priceChangePercentage: 2.0))
////        .environment(TokenViewModel())
//
//}
