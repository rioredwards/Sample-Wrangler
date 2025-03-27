import Foundation
import AVFoundation

class AudioPlayerService: ObservableObject {
    private var audioPlayer: AVAudioPlayer?
    @Published var isPlaying = false
    
    init() {
        setupAudioPlayer()
    }
    
    private func setupAudioPlayer() {
        guard let url = Bundle.main.url(forResource: "background_music", withExtension: "mp3") else {
            print("Could not find background music file")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1 // Infinite loop
            audioPlayer?.volume = 0.5 // Set volume to 50%
            audioPlayer?.prepareToPlay()
        } catch {
            print("Error setting up audio player: \(error.localizedDescription)")
        }
    }
    
    func play() {
        audioPlayer?.play()
        DispatchQueue.main.async {
            self.isPlaying = true
        }
    }
    
    func pause() {
        audioPlayer?.pause()
        DispatchQueue.main.async {
            self.isPlaying = false
        }
    }
    
    func togglePlayback() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }
} 
