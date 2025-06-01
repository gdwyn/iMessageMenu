//
//  TokenDetails 2.swift
//  iMessageMenu
//
//  Created by gdwyn on 01/06/2025.
//

import SwiftUI

struct TokenDetails: View {
    var coin: Coin
    @State private var displayPrice: Double
    @State private var displayPercentage: Double
    @State private var isDragging = false
    
    init(coin: Coin) {
        self.coin = coin
        self._displayPrice = State(initialValue: coin.currentPrice)
        self._displayPercentage = State(initialValue: coin.priceChangePercentage)
    }

    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 18) {
                    Capsule()
                        .fill(.appGray)
                        .frame(width: 38, height: 5)
                    
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
                            Text(coin.name)
                                .font(.system(.title, design: .rounded))
                            
                            // Dynamic price display
                            Text(formatPrice(displayPrice))
                                .font(.system(.title3, design: .rounded))
                                .foregroundStyle(isDragging ? .primary : Color.gray)
                                .contentTransition(.numericText(value: displayPrice))
                                .animation(.smooth(duration: 0.1), value: displayPercentage)

                        }
                        
                        Spacer()
                        
                        // Dynamic percentage display
                        Text(formatPercentage(displayPercentage))
                            .font(.system(.title3, design: .rounded))
                            .foregroundStyle(displayPercentage >= 0 ? .green : .red)
                            .contentTransition(.numericText(value: displayPercentage))
                            .animation(.smooth(duration: 0.1), value: displayPercentage)


                    }
                    .padding(.horizontal)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.textBlack)
                    
                    SparklineView(data: coin.sparkLine.price) { price, percentage in
                        // Handle price updates from sparkline
                        if price == 0 && percentage == 0 {
                            // Reset to original values
                            displayPrice = coin.currentPrice
                            displayPercentage = coin.priceChangePercentage
                            isDragging = false
                        } else {
                            // Update with dragged values
                            displayPrice = price
                            displayPercentage = percentage
                            isDragging = true
                        }
                    }
                    .frame(width: 360, height: 200)
                    .offset(x: -24)
                    .padding(.top, 48)
                    
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
    
    private func formatPrice(_ price: Double) -> String {
        if price >= 1 {
            return String(format: "$%.2f", price)
        } else {
            return String(format: "$%.4f", price)
        }
    }
    
    private func formatPercentage(_ percentage: Double) -> String {
        return String(format: "%+.2f%%", percentage)
    }
}

