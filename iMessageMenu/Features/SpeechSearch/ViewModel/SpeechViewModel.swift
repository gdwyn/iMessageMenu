//
//  ViewModel.swift
//  iMessageMenu
//
//  Created by Godwin IE on 14/04/2025.
//

import Foundation
import SwiftUI
import AVKit

@Observable
class SpeechViewModel: ObservableObject {
    private var audioRecorder: AVAudioRecorder!
        private var timer: Timer?
        
        var amplitude: Float = 0.0

        init() {
            let audioSession = AVAudioSession.sharedInstance()
            try? audioSession.setCategory(.playAndRecord, mode: .default)
            try? audioSession.setActive(true)

            let url = URL(fileURLWithPath: "/dev/null")
            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatAppleLossless),
                AVSampleRateKey: 44100.0,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue
            ]

            try? audioRecorder = AVAudioRecorder(url: url, settings: settings)
            audioRecorder.isMeteringEnabled = true
            audioRecorder.record()

            timer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { _ in
                self.audioRecorder.updateMeters()
                self.amplitude = self.audioRecorder.averagePower(forChannel: 0)
            }
        }

        deinit {
            audioRecorder.stop()
            timer?.invalidate()
        }
}
