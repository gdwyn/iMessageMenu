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
        
    public var body: some View {
        ZStack(alignment: .bottom) {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(viewModel.messages) { message in
                            MessageBubble(msg: message, animation: animation)
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
            // convo
            
            if viewModel.showMenu {
                 Color.appBlack.opacity(0.1)
                    .frame(alignment: .bottomLeading)
                    .background(.ultraThinMaterial)
                     .contentShape(Rectangle())
                     .onTapGesture {
                         withAnimation(.bouncy(duration: 0.5)) {
                             viewModel.showMenu.toggle()
                         }
                     }
                     .ignoresSafeArea()
                     .zIndex(1)
             }
            // + bg blur
            
            if viewModel.showMenu {
                MenuView()
                    .transition(.opacity.combined(with: .move(edge: .bottom)).combined(with: .move(edge: .leading)).combined(with: .scale))
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
