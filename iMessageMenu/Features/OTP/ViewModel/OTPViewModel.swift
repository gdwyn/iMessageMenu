//
//  OTPViewModel.swift
//  iMessageMenu
//
//  Created by gdwyn on 07/06/2025.
//

import Foundation
import SwiftUI

@Observable
class OTPViewModel {
    var otpText = ""
    let correctOTP = "123456"
    var verificationState: VerificationState?
    var isLoading = false

    var shakeOffset: CGFloat = 0
    var bounceOffsets: [CGFloat] = Array(repeating: 0, count: 6)
    
    func verifyOTP() {
        isLoading = true
        
        guard otpText.count == 6 else { return }
        verificationState = .loading

        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [self] in
            if otpText == correctOTP {
                verificationState = .success
                startBounce()
            } else {
                verificationState = .failure
                shake()
                otpText = ""
            }
            
            isLoading = false

        }
        
    }
    
    func shake() {
        withAnimation(.default) {
            shakeOffset = -18
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.bouncy(duration: 0.2)) {
                self.shakeOffset = 18
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.bouncy(duration: 0.2)) {
                self.shakeOffset = 0
            }
        }
    }

    
    func startBounce() {
        for i in 0..<6 {
            let delay = Double(i) * 0.15
            
            // Move up
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.bouncy(duration:  0.5)) {
                    self.bounceOffsets[i] = +10 // first move down by 10
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + delay + 0.2) {
                withAnimation(.smooth(duration:  0.5)) {
                    self.bounceOffsets[i] = -15 // Move up by 20 points
                }
            }
            
            // Move back down
            DispatchQueue.main.asyncAfter(deadline: .now() + delay + 0.4) {
                withAnimation(.smooth(duration:  0.5)) {
                    self.bounceOffsets[i] = 0 // Back to original position
                }
            }
        }
    }


}
