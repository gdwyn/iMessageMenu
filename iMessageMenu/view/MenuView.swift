//
//  MenuView.swift
//  iMessageMenu
//
//  Created by Godwin IE on 14/04/2025.
//

import SwiftUI

struct MenuView: View {
    @EnvironmentObject var viewModel: MessageViewModel

    var body: some View {
        
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(alignment: .leading, spacing: 0) {
                    Spacer()
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
                        .containerRelativeFrame(.vertical, count: 6, spacing: 0)
                        .scrollTransition { content, phase in
                            content
                                .blur(radius: phase.isIdentity ? 0 : 1)
                                .opacity(phase.isIdentity ? 1 : 0)

                        }
                        
                    }
                }
                .scrollTargetLayout()
                
                .padding(.horizontal, 40)
                
            }
            .scrollTargetBehavior(.paging)
            //.defaultScrollAnchor(.bottomLeading)
            .frame(maxHeight: UIScreen.main.bounds.height * 0.7 )
            .scrollClipDisabled()

       }
}

#Preview {
    MenuView()
}
