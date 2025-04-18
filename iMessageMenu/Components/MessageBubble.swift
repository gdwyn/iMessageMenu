//
//  MessageBubble.swift
//  iMessageMenu
//
//  Created by Godwin IE on 14/04/2025.
//

import SwiftUI

struct MessageBubble: View {
    @EnvironmentObject var viewModel: MessageViewModel
    
    var msg: Message
    var animation: Namespace.ID
    var showLike = false
    @Binding var showHighlight: Bool
    @Binding var highlightedChat: Message?
    
    var shouldShowEmoji: Bool {
        msg.emoji != nil && !showHighlightForThisMessage
    }

    var showHighlightForThisMessage: Bool {
        showHighlight && highlightedChat?.id == msg.id
    }

    
    var body: some View {
        ZStack {
            HStack {
                if msg.direction == .outgoing { Spacer() }
                
                VStack(alignment: msg.direction == .incoming ? .trailing : .leading) {
                    if shouldShowEmoji, let emoji = msg.emoji {
                            AnimatedEmoji(emoji: emoji, color: msg.direction == .incoming ? .gray : .blue)
                                .offset(x: msg.direction == .incoming ? 18 : -18)
                                .padding(.bottom, -25)
                                .id(emoji)
                                .zIndex(1)
                        }
                    
                    RoundedRectangle(cornerRadius: 20, style: .circular)
                        .fill(msg.direction == .incoming ? .appGray : Color.blue)
                        .frame(width: 250, height: 100)
                        .matchedGeometryEffect(id: msg.id, in: animation)
                }
                
                if msg.direction == .incoming { Spacer() }
            }
            .id(msg.id)
            .transition(.move(edge: msg.direction == .incoming ? .leading : .trailing))
            
            if showHighlightForThisMessage {
                EmojiView(chat: msg, hideView: $showHighlight) { emoji in
                    withAnimation(.easeInOut) {
                        showHighlight = false
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        highlightedChat = nil
                    }
                    
                    if let index = viewModel.messages.firstIndex(where: { $0.id == msg.id }) {
                        withAnimation(.easeInOut.delay(0.3)) {
                            viewModel.messages[index].emoji = emoji
                        }
                    }
                }
                .offset(y: -60)
                .transition(.scale.combined(with: .move(edge: .top).combined(with: .opacity)))
            }
        }
    }
}
