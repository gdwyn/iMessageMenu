//
//  OTPView.swift
//  iMessageMenu
//
//  Created by gdwyn on 07/06/2025.
//

import SwiftUI
import Shimmer

struct OTPView: View {
    @FocusState private var showingKeyboard: Bool
    @State private var boxPositions: [CGRect] = Array(repeating: .zero, count: 6)
    
    @Environment(OTPViewModel.self) var otpVM



    var body: some View {
        VStack {
            Text("Enter the code")
                .font(.system(.body, design: .rounded))
            
            VStack(alignment: .leading) {
            ZStack(alignment: .leading) {
                HStack(spacing: 0) {
                    ForEach(0..<6, id: \.self) { index in
                        OTPBox(index)
                            .background(
                                GeometryReader { geo in
                                    Color.clear
                                        .preference(
                                            key: BoxFramePreferenceKey.self,
                                            value: [index: geo.frame(in: .named("OTPStack"))]
                                        )
                                }
                            )
                    }
                }
                
                // box indicator
                if let rect = boxPositions[safe: otpVM.otpText.count] {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.accent, lineWidth: 3)
                        .frame(width: 45, height: 52)
                        .offset(x: rect.minX, y: 0)
                        .padding(.leading, 8)
                        .animation(.bouncy(duration: 0.25), value: otpVM.otpText)
                }
            }
            .offset(x: otpVM.shakeOffset)
            .coordinateSpace(name: "OTPStack")
            .onPreferenceChange(BoxFramePreferenceKey.self) { value in
                for (index, rect) in value {
                    boxPositions[index] = rect
                }
            }
            .background(
                TextField("", text: Binding(
                    get: { otpVM.otpText },
                    set: { otpVM.otpText = $0 }
                )
                    .limit(6))
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .frame(width: 1, height: 1)
                .opacity(0)
                .focused($showingKeyboard)
            )
            .contentShape(Rectangle())
            .onTapGesture {
                showingKeyboard = true
            }
            .padding(.bottom, 10)
            .padding(.top, 28)
            
                //error msg
                if otpVM.verificationState == .failure {
                    Text("🚨You code is not correct")
                        .foregroundStyle(.red)
                        .font(.system(.subheadline, design: .rounded))
                        .padding(.leading, 8)
                } else if otpVM.verificationState == .success {
                    Text("🏄‍♂️ Great! Correct code")
                        .foregroundStyle(.green)
                        .font(.system(.subheadline, design: .rounded))
                        .padding(.leading, 8)
                }
            
        }
            
        Spacer()
            
            Button {
                otpVM.verifyOTP()
            } label: {
                Text("Verify")
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                    .font(.system(.headline, design: .rounded))
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 18).fill(.accent))
            }
            .disableWithOpacity(otpVM.otpText.count < 6)
        }
        .padding()
        .padding(.top, 28)
    }

    // MARK: - OTP Box View
    @ViewBuilder
    func OTPBox(_ index: Int) -> some View {
        ZStack {
            if otpVM.otpText.count > index {
                let startIndex = otpVM.otpText.startIndex
                let charIndex = otpVM.otpText.index(startIndex, offsetBy: index)
                let char = String(otpVM.otpText[charIndex])
                
                Text(char)
                    .foregroundStyle(.black)
                    .font(.system(.title3, design: .rounded))
                    .opacity(otpVM.isLoading ? 0.2 : 0.8)
                    .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: otpVM.isLoading)
                
            } else {
                Text("0")
                    .foregroundStyle(.gray.opacity(0.6))
                    .font(.system(.title3, design: .rounded))

            }
        }
        .frame(width: 45, height: 52)
        .background(RoundedRectangle(cornerRadius: 12, style: .circular).fill(.gray.opacity(0.1)))
        .frame(maxWidth: .infinity)
        .offset(y: otpVM.bounceOffsets[index])
    }

}










// H    E    L    P     E      R     S

// MARK: - Preference Key for Box Frames
struct BoxFramePreferenceKey: PreferenceKey {
    static var defaultValue: [Int: CGRect] = [:]
    static func reduce(value: inout [Int: CGRect], nextValue: () -> [Int: CGRect]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

// MARK: - Safe Indexing for Arrays
extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

// MARK: - View Extensions
extension View {
    func disableWithOpacity(_ condition: Bool) -> some View {
        self.disabled(condition).opacity(condition ? 0.6 : 1)
    }
}

extension Binding where Value == String {
    func limit(_ length: Int) -> Binding<String> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = String(newValue.prefix(length))
            }
        )
    }
}



#Preview {
    OTPView()
        .environment(OTPViewModel())
}
