//
//  ContentView.swift
//  foundermeditations
//
//  Created by hellyeah on 1/21/25.
//

import SwiftUI
import SwiftyGif
import AVFoundation

struct ContentView: View {
    @State private var audioPlayer: AVAudioPlayer?

    
    struct AnimatedGifView: UIViewRepresentable {
        @Binding var url: URL

        func makeUIView(context: Context) -> UIImageView {
            let imageView = UIImageView(gifURL: self.url)
            imageView.contentMode = .scaleAspectFit
            return imageView
        }

        func updateUIView(_ uiView: UIImageView, context: Context) {
            uiView.setGifFromURL(self.url)
        }
    }
    

    
    var body: some View {
//        Circle()
//            .fill(.blue)
//            .padding()
        
        //bring this back in after we test audio file playing
//        GIFView(gifName: "spinny.gif")
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello, world!")
//        }
//        .padding()
        
        Button("Play Audio") {
            playAudio()
        }
        .onAppear {
            setupAudioPlayer()
        }
    }
    
    
    private func setupAudioPlayer() {
        guard let soundURL = Bundle.main.url(forResource: "tenbreath", withExtension: "mp3") else {
            print("Audio file not found")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.prepareToPlay()
        } catch {
            print("Error setting up audio player: \(error.localizedDescription)")
        }
    }
    
    private func playAudio() {
        audioPlayer?.play()
    }
}

struct GIFView: UIViewRepresentable {
    let gifName: String
    
    func makeUIView(context: Context) -> UIImageView {
        guard let gif = try? UIImage(gifName: gifName) else {
            return UIImageView()
        }
        let imageView = UIImageView(gifImage: gif, loopCount: 12)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
    
    func updateUIView(_ uiView: UIImageView, context: Context) {}
}


#Preview {
    ContentView()
}
