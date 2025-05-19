import SwiftUI
import AVFoundation

class BackgroundMusicViewModel: ObservableObject {
    @Published var isPlaying: Bool = false
    private var audioPlayer: AVPlayer?
    
    init() {
        if let audioUrl = Bundle.main.url(forResource: "snowy-269988", withExtension: "mp3") {
            audioPlayer = AVPlayer(url: audioUrl)
        }
    }
    
    func play() {
        audioPlayer?.play()
        isPlaying = true
    }
    
    func stop() {
        audioPlayer?.pause()
        audioPlayer?.seek(to: .zero)
        isPlaying = false
    }
} 