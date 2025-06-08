//
//  ContentView.swift
//  iMessageMenu
//
//  Created by Godwin IE on 14/04/2025.
//

import SwiftUI

struct ChatView: View {
    @Environment(MessageViewModel.self) var messageVM
    @Environment(TokenViewModel.self) var tokenVM

    @Namespace private var animation
    
    @State var highlightedChat: Message?
    @State var showHighlight = false
    
    public var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 8) {
                            ForEach(messageVM.messages) { message in
                                
                                MessageBubble(msg: message, animation: animation, isSource: highlightedChat?.id != message.id, showHighlight: $showHighlight, highlightedChat: $highlightedChat)
                                    .anchorPreference(key: BoundsPreference.self, value: .bounds, transform: {
                                        anchor in
                                        return [message.id.uuidString: anchor]
                                    })
                                    .onLongPressGesture {
                                        withAnimation(.easeInOut) {
                                            showHighlight = true
                                            highlightedChat = message
                                        }
                                    }
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .top)
                        
                    }
                    .scrollDismissesKeyboard(.interactively)
                    .safeAreaInset(edge: .bottom, spacing: 0) {
                        AppTextfield(proxy: proxy, animation: animation)
                    }
                    .onChange(of: messageVM.messages) {
                        withAnimation {
                            proxy.scrollTo(messageVM.messages.last?.id)
                        }
                    }
                }
                .overlay(content: {
                    if showHighlight {
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .environment(\.colorScheme, .dark)
                            .foregroundStyle(.appBlack.opacity(0.5))
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation(.spring) {
                                    showHighlight = false
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    highlightedChat = nil
                                }
                                
                            }
                        
                    }
                })
                
                .overlayPreferenceValue(BoundsPreference.self) { values in
                    if let highlightedChat, let preference = values.first(where: { item in
                        item.key == highlightedChat.id.uuidString
                    }) {
                        GeometryReader{ proxy in
                            let rect = proxy[preference.value]
                            MessageBubble(msg: highlightedChat, animation: animation, isSource: true, showHighlight: $showHighlight, highlightedChat: $highlightedChat)
                                .id(highlightedChat.id)
                                .frame(width: rect.width, height: rect.height)
                                .offset(x: rect.minX, y: rect.minY)
                        }
                        .transition(.asymmetric(insertion: .identity, removal: .opacity))
                        
                    }
                }
                // chat
                
                if messageVM.showMenu {
                    MenuView(animation: animation)
                        .frame(alignment: .bottomLeading)
                }
                // + menu
                
                if messageVM.showSpeech {
                    SpeechView()
                }
                // speech
            }
            .task {
                tokenVM.LoadCoins()
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem {
                    NavigationLink("🪙 Eth") {
                        TokenView()
                    }
                }
                
                ToolbarItem {
                    NavigationLink("🗝️ OTP") {
                        OTPView()
                    }
                }
            }
        }
    }
}

#Preview {
    ChatView()
}
