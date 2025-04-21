//
//  ContentView.swift
//  iMessageMenu
//
//  Created by Godwin IE on 14/04/2025.
//

import SwiftUI

struct ChatView: View {
    @EnvironmentObject var viewModel: MessageViewModel
    @Namespace private var animation
        
    @State var highlightedChat: Message?
    @State var showHighlight = false
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(viewModel.messages) { message in
                           
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
                .onChange(of: viewModel.messages) {
                    withAnimation {
                        proxy.scrollTo(viewModel.messages.last?.id)
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
            
            if viewModel.showMenu {
                Rectangle()
                    .fill(.appBlack.opacity(0.1))
                    .frame(alignment: .bottomLeading)
                    .background(.ultraThinMaterial)
                     .contentShape(Rectangle())
                     .ignoresSafeArea()
                     .zIndex(1)
             }
            // + bg blur
            
            if viewModel.showMenu {
                MenuView(animation: animation)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                    .frame(alignment: .bottomLeading)
                    .zIndex(2)
            }
            // + menu
            
       

        }
    }
}

#Preview {
    ChatView()
}
