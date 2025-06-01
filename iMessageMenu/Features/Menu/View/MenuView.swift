//
//  MenuView.swift
//  iMessageMenu
//
//  Created by Godwin IE on 14/04/2025.
//

import SwiftUI

struct MenuView: View {
    var animation: Namespace.ID
    
    @Environment(MessageViewModel.self) var messageVM

    @State private var scrollRect: CGRect = .zero
    @State private var scrollSpacing: CGFloat = 0.0
    
    @State private var animateItems = false
    
    
    var body: some View {
        ZStack {
            
            Rectangle()
                .fill(.appBlack.opacity(0.1))
                .frame(alignment: .bottomLeading)
                .background(.ultraThinMaterial)
                 .contentShape(Rectangle())
                 .ignoresSafeArea()
            
            GeometryReader {
                let size = $0.size // should be used with elastic scroll but im having issues with the elastic scroll thing
                
                VStack(alignment: .leading, spacing: 20) {
                    Spacer()
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 34) {
                            ForEach(1..<13) { index in
                                let blurRadius = animateItems ? 0.0 : (20.0 - CGFloat(index * 2))
                                let offsetY = animateItems ? 0 : CGFloat((12 - index)) * 30
                                let opacity = animateItems ? 1.0 : 0.0
                                let delay = Double(12 - index) * 0.03
                                
                                Button {
                                    // action
                                } label: {
                                    HStack {
                                        Circle()
                                            .fill(Color.blue)
                                            .frame(width: 34, height: 34)
                                        Text("Option \(index)")
                                            .font(.title3)
                                        Spacer()
                                    }
                                    .padding(.vertical, 4)
                                    .blur(radius: blurRadius)
                                    .offset(y: offsetY)
                                    .opacity(opacity)
                                    .animation(.easeOut(duration: 0.2).delay(delay), value: animateItems)
                                    
                                }
                                //                            .elasticScrol(scrollRect: scrollRect, screenSize: size)
                                .scrollTransition { content, phase in
                                    content
                                        .blur(radius: phase.isIdentity ? 0 : 30)
                                        .opacity(phase.isIdentity ? 1 : 0.5)
                                }
                            }
                        }
                        
                        .frame(maxHeight: .infinity, alignment: .bottom)
                    }
                    .padding(.top, 130)
                    .padding(.horizontal, 34)
                    .coordinateSpace(name: "SCROLLVIEW")
                    .scrollClipDisabled()
                    
                    
                    
                    Button {
                        withAnimation(.spring(duration: 0.3)) {
                            animateItems = false
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            withAnimation(.spring(duration: 0.3)) {
                                messageVM.showMenu = false
                            }
                        }
                        
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title3)
                            .foregroundStyle(.gray)
                            .padding()
                            .frame(width: 34, height: 34)
                            .background(.gray.opacity(0.2), in: Circle())
                            .padding(.horizontal, 34)
                            .padding(.top, 10)
                            .padding(.bottom, 13)
                            .rotationEffect(.degrees(animateItems == false ? -145 : 0))
                        
                    }
                    .matchedGeometryEffect(id: "XBUTTON", in: animation)
                    //x button
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
                
            }
            .onAppear {
                DispatchQueue.main.async {
                    animateItems = true
                }
            }
            .onDisappear {
                DispatchQueue.main.async {
                    animateItems = false
                    messageVM.showMenu = false
                }
            }
        }
        .transition(.opacity.combined(with: .scale(scale: 0, anchor: .bottomLeading)))
        
        
    }
}

//#Preview {
//    MenuView()
//}
