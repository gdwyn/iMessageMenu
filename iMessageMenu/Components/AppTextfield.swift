//
//  AppTextfield.swift
//  iMessageMenu
//
//  Created by Godwin IE on 14/04/2025.
//

import SwiftUI

struct AppTextfield: View {
    @Environment(MessageViewModel.self) var messageVM
    var proxy: ScrollViewProxy
    var animation: Namespace.ID
    
    @FocusState private var isFocused: Bool
    @State private var animateCoins = false
    
    var body: some View {
        @Bindable var bindableMessageVM = messageVM
        
        ZStack(alignment: .bottom) {
            
            if messageVM.showSuggestions {
                VStack(spacing: 30) {
                    Spacer()
                ScrollView {
                    VStack {
                        ForEach(messageVM.filteredCoins, id: \.self) { app in
                            
                            Button {
                                messageVM.insertCoin(app)
                            } label: {
                                HStack(spacing: 12) {
                                    Image("bonk")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                        .clipShape(Circle())
                                    Text(app.dropFirst())
                                        .foregroundStyle(.textBlack)
                                        .font(.headline)
                                        .fontWeight(.medium)
                                    
                                    Spacer()
                                }
                            }
                            .padding(.vertical, 6)
                            .scrollTransition { content, phase in
                                content
                                    .blur(radius: phase.isIdentity ? 0 : 30)
                                    .opacity(phase.isIdentity ? 1 : 0.5)
                            }
                        }
                    }
                    .animation(.smooth(duration: 0.3), value: messageVM.filteredCoins)
                }
                .scrollIndicators(.hidden)
                .scrollClipDisabled()
                .frame(height: min(CGFloat(messageVM.filteredCoins.count) * 50, 300)) // optional height cap
                .padding(.horizontal)
                .padding(.top, 84)


                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .background(.ultraThinMaterial)
                .ignoresSafeArea()
                .transition(.opacity.combined(with: .move(edge: .bottom)))

                .offset(y: -66)
            }
            
            HStack(alignment: .bottom, spacing: messageVM.showMenu == true ? 80 : 12) {
                Button {
                    isFocused = false
                    
                    withAnimation(.spring(duration: 0.3)) {
                        messageVM.showMenu.toggle()
                    }
                } label: {
                    Image(systemName: "plus")
                        .font(.title3)
                        .foregroundStyle(.gray)
                        .padding()
                        .frame(width: 34, height: 34)
                        .background(.gray.opacity(0.2), in: Circle())
                        .rotationEffect(.degrees(messageVM.showMenu == false ? 0 : -70))
                }
                .matchedGeometryEffect(id: "XBUTTON", in: animation)
                
                HStack(alignment: .bottom) {
                    HStack {
                        TextField("iMessage", text: $bindableMessageVM.text, axis: .vertical)
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .focused($isFocused)
                            .onSubmit {
                                isFocused = true
                                messageVM.submit()
                            }
                            .onChange(of: isFocused) {
                                withAnimation {
                                    proxy.scrollTo(messageVM.messages.last?.id)
                                }
                            }
                        
                        if messageVM.text.isEmpty {
                            
                            Button {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    messageVM.showSpeech.toggle()
                                }
                            } label: {
                                Image(systemName: "mic.circle.fill")
                                    .font(.title)
                                    .foregroundStyle(.gray.opacity(0.6))
                                    .padding(2)
                                
                            }
                            
                        } else {
                            Button {
                                messageVM.submit()
                            } label: {
                                Image(systemName: "arrow.up.circle.fill")
                                    .font(.title)
                                    .foregroundStyle(.blue)
                                    .padding(2)
                                
                            }
                            
                        }
                    }
                    .frame(alignment: .bottom)
                    
                }
                .frame(minHeight: 34)
                .overlay(Color(.separator), in: .rect(cornerRadius: 18).stroke())
                .overlay(alignment: .leading) {
                    if let sentMessage = messageVM.sentMessage {
                        
                        RoundedRectangle(cornerRadius: 20, style: .circular)
                            .fill(.blue)
                            .frame(width: 250, height: 100)
                            .matchedGeometryEffect(id: sentMessage.id, in: animation)
                    }
                }
                
            }
            .padding()
            .background {
                Rectangle()
                    .fill(.appBlack.opacity(0.2))
                    .background(.bar)
                    .ignoresSafeArea()
            }
        }
//        .onAppear {
//            DispatchQueue.main.async {
//                animateCoins = true
//            }
//        }
//        .onDisappear {
//            DispatchQueue.main.async {
//                animateCoins = false
//            }
//        }
    }
}
