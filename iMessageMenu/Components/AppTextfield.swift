//
//  AppTextfield.swift
//  iMessageMenu
//
//  Created by Godwin IE on 14/04/2025.
//

import SwiftUI

struct AppTextfield: View {
    @EnvironmentObject var messageVM: MessageViewModel
    var proxy: ScrollViewProxy
    var animation: Namespace.ID

    @FocusState private var isFocused: Bool

    var body: some View {
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
                    TextField("iMessage", text: $messageVM.text, axis: .vertical)
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
}
