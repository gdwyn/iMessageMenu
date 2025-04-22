//
//  AudioVisualizer.swift
//  iMessageMenu
//
//  Created by Godwin IE on 21/04/2025.
//

import SwiftUI

struct SpeechView: View {
    @EnvironmentObject var speechVM: SpeechViewModel
    @State private var animate = false

    let barCount = 12

    var body: some View {
        ZStack(alignment: .bottom) {
            Capsule()
                .fill(LinearGradient(
                    gradient: Gradient(colors: [
                        animate ? .gBlue : .gPink,
                        animate ? .gBlue : .gPink,
                        animate ? .gPink : .gBlue
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .blur(radius: 50)
                .frame(height: 500)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, -50)
                .offset(y: 140)
            
            VStack(spacing: 24) {
                Image("speechface")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 82, height: 84)
                    .padding(.vertical, 32)
                
                Text("Yo! What's good fam?")
                    .font(.title)
                    .fontWeight(.medium)
                    .foregroundStyle(.white.opacity(0.5))
                
                HStack(spacing: 8) {
                    ForEach(0..<barCount, id: \.self) { _ in
                        Capsule()
                            .fill(Color.white)
                            .frame(width: 4, height: CGFloat(barScale() * 30))
                            .animation(.easeInOut(duration: 0.2), value: speechVM.amplitude)
                    }
                }
                .padding()
                .frame(height: 40)
                .background(.black.opacity(0.2), in: Capsule())
            }
            .padding()
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
                animate.toggle()
            }
        }
    }

    func barScale() -> CGFloat {
        let normalized = max(0, CGFloat((speechVM.amplitude + 50) / 50)) // Range: 0 to 1+
        return normalized * CGFloat.random(in: 0.3...1.2)
    }
}



//            MeshGradient(
//                   width: 1,
//                   height: 1,
//                   points: [
//                       [0.0, 0.0],
//                       [1.0, 0.0]
//                   ],
//                   colors: [
//                       .indigo,
//                       isAnimating ? .purple : .orange
//                   ],
//                   smoothsColors: true,
//                   colorSpace: .perceptual
//               )
