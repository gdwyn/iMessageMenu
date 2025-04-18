//
//  MessageBubble.swift
//  iMessageMenu
//
//  Created by Godwin IE on 14/04/2025.
//

import SwiftUI

struct MessageBubble: View {
    var msg: Message
    var animation: Namespace.ID
    var showLike = false
    @Binding var showHighlight: Bool

    var body: some View {
        ZStack {
            HStack {
                if msg.direction == .outgoing { Spacer() }
                
                RoundedRectangle(cornerRadius: 20, style: .circular)
                    .fill(msg.direction == .incoming ? .gray.opacity(0.3) : .blue)
                    .frame(width: 250, height: 100)
                    .matchedGeometryEffect(id: msg.id, in: animation)
                
                if msg.direction == .incoming { Spacer() }
            }
            .id(msg.id)
            .transition(.move(edge: msg.direction == .incoming ? .leading : .trailing))
            
            if showLike {
                EmojiView(chat: msg, hideView: $showHighlight) { emoji in
                }
                .offset(y: -62)
            }
        }
    }
}

