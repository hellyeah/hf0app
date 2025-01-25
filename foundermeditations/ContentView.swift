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
    @State private var gifSize = CGSize(width: 100, height: 100)
    
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
        //GIFView(gifName: "spinny.gif")
        
        VStack (spacing:0) {
            Color.black
            .frame(height: UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0)
            .ignoresSafeArea(edges: .top)
            
            GIFView(gifName: "spinny.gif", size: $gifSize)
                .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height * 0.5)
                .background(Color.black)
                .ignoresSafeArea(edges: [.top, .horizontal])
            
            // Scrollable Audio Tiles
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(0..<10) { index in
                        AudioTileView(title: "Audio \(index + 1)")
                    }
                }
                .padding()
            }
            .background(Color.black)
            
            Spacer()
                .frame(maxHeight: .infinity)
                .background(Color.black)
            
            Image(systemName: "globe")
                .imageScale(.small)
                .foregroundStyle(.tint)
//            Text("Hello, world!")
            Button("Play Audio") {
                playAudio()
            }
            .onAppear {
                setupAudioPlayer()
            }
            .padding(.bottom, 30)
        }
//        .padding()

        
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
    @Binding var size: CGSize
    
    func makeUIView(context: Context) -> UIImageView {
        guard let gif = try? UIImage(gifName: gifName) else {
            return UIImageView()
        }
        let imageView = UIImageView(gifImage: gif, loopCount: 120)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
    
    func updateUIView(_ uiView: UIImageView, context: Context) {
        uiView.frame.size = size
    }
}

// Audio Tile View Component
struct AudioTileView: View {
    let title: String
    
    var body: some View {
        VStack {
            Rectangle()
                .fill(Color.gray)
                .frame(width: 100, height: 100)
                .cornerRadius(8)
            
            Text(title)
                .foregroundColor(.white)
                .font(.caption)
        }
    }
}


#Preview {
    ContentView()
}
