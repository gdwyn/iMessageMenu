//
//  MenuView.swift
//  iMessageMenu
//
//  Created by Godwin IE on 14/04/2025.
//

import SwiftUI

struct MenuView: View {
    @State private var scrollRect: CGRect = .zero
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            VStack(alignment: .leading, spacing: 0) {
                Spacer()
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: -10) {
                    ForEach(1..<13) { index in
                        Button {
                            
                        } label: {
                            HStack {
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 34, height: 34)
                                Text("Option \(index)")
                                    .font(.title3)
                                
                                Spacer()
                            }
                        }
                        .elasticScrol(scrollRect: scrollRect, screenSize: size)
                        .containerRelativeFrame(.vertical, count: 6, spacing: 0)
                        .scrollTransition { content, phase in
                            content
                              .blur(radius: phase.isIdentity ? 0 : 30)
                            
                        }
                        
                    }
                }
                    .padding(.bottom, 40)

                    .scrollTargetLayout()
                    .padding(.horizontal, 40)
                    .offsetExtractor(coordinateSpace: "SCROLLVIEW") {
                        scrollRect = $0
                    }
                    
                    
                }
                .coordinateSpace(name: "SCROLLVIEW")
                .scrollTargetBehavior(.paging)
                //.defaultScrollAnchor(.bottomLeading)
                .frame(height: UIScreen.main.bounds.height * 0.82)
                .scrollClipDisabled()
                
            }
        }
    }
}

#Preview {
    MenuView()
}
