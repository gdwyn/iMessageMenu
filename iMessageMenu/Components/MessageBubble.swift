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
    var isSource: Bool = true //to prevent duplicate matched geometry animation
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
                
                //message bubble
                VStack(alignment: msg.direction == .incoming ? .trailing : .leading) {
                    if shouldShowEmoji, let emoji = msg.emoji {
                        AnimatedEmoji(emoji: emoji, color: msg.direction == .incoming ? .gray : .blue)
                            .offset(x: msg.direction == .incoming ? 18 : -18)
                            .padding(.bottom, -25)
                            .id(emoji)
                            .zIndex(1)
                    }
                    
                    RoundedRectangle(cornerRadius: 20, style: .circular)
                        .fill(msg.direction == .incoming ? Color(.systemGray6) : Color.blue)
                        .frame(width: 250, height: 100)
                        .matchedGeometryEffect(id: msg.id, in: animation, isSource: isSource)
                }
                
                if msg.direction == .incoming { Spacer() }
            }
            .id(msg.id)
            .transition(.move(edge: msg.direction == .incoming ? .leading : .trailing))
            
            if showHighlightForThisMessage {
                //emoji reactions
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
                .transition(.opacity.combined(with: .move(edge: .top).combined(with: .scale)))
                .frame(maxWidth: .infinity, alignment: .center)

                // message actions
                MessageActions(
                    onReply: {
                        withAnimation(.easeInOut) {
                            showHighlight = false
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            highlightedChat = nil
                        }
                    },
                    onCopy: {
                        if case let .text(text) = msg.kind {
                            UIPasteboard.general.string = text
                        }
                        
                        withAnimation() {
                            showHighlight = false
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            highlightedChat = nil
                        }
                    })
                .offset(y: 114)
                .transition(.opacity.combined(with: .move(edge: .top).combined(with: .scale)))
                .frame(maxWidth: .infinity, alignment: msg.direction == .incoming ? .leading : .trailing)
            }
        }
    }
}
