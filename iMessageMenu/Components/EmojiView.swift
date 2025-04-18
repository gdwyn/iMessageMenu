//
//  EmojiView.swift
//  iMessageMenu
//
//  Created by Godwin IE on 18/04/2025.
//

import SwiftUI

struct EmojiView: View {
    var chat: Message
    @Binding var hideView: Bool
    var onTap: (String)->()
    var emojis: [String] = ["❤️", "🤟", "👍", "🚀", "🎉"]
    @State var animateEmoji: [Bool] = Array(repeating: false, count: 5)
    @State var animateView = false
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(emojis.indices, id: \.self) { index in
                Text(emojis[index])
                    .font(.system(size: 25))
                    .scaleEffect(animateEmoji[index] ? 1 : 0.01)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            withAnimation(.easeInOut.delay(Double(index) * 0.1)) {
                                animateEmoji[index] = true
                            }
                        }
                    }
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 8)
        .background {
            Capsule()
                .fill(.appBlack)
                .mask {
                    Capsule()
                        .scaleEffect(animateView ? 1 : 0, anchor: .leading)
                }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.2)) {
                animateView = true
            }
        }
        .onChange(of: hideView) {
            if !hideView {
                withAnimation(.easeInOut(duration: 0.2).delay(0.15)) {
                    animateView = false
                }
                
                for index in emojis.indices {
                    withAnimation(.easeInOut) {
                        animateEmoji[index] = false
                    }
                }
            }
        }
    }
}

//#Preview {
//    EmojiView()
//}
