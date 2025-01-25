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
    @State private var isPlaying = false
    
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
            
            //this is just a temporary bandaid to push the gif down from the top
            Spacer()
            Spacer()
            
            GIFView(gifName: "spinny.gif", size: $gifSize)
                .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height * 0.5)
                .background(Color.black)
                .ignoresSafeArea(edges: [.top, .horizontal])
            
            // Scrollable Audio Tiles
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(0..<10) { index in
                        AudioTileView(title: "Audio \(index + 1)", action: {
                            playAudio(fileName: "audio\(index + 1)")
                        })
                    }
                }
                .padding()
            }
            .background(Color.black)
            
            Spacer()
            Spacer()

            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.8), Color.black]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                
                Button(action: {
                    if isPlaying {
                        audioPlayer?.pause()
                    } else {
                        audioPlayer?.play()
                    }
                    isPlaying.toggle()
                }) {
                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 44))
                        .foregroundColor(.white)
                }
                .padding(.bottom, 50) // Adjust this value to move button higher
            }
            .frame(height: UIScreen.main.bounds.height * 0.2) // Increase gradient height
        }
        .background(Color.black)
        .ignoresSafeArea()

        
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
    
    private func playAudio(fileName: String) {
        // Your existing audio setup code
        isPlaying = true
        
        guard let soundURL = Bundle.main.url(forResource: fileName, withExtension: "mp3") else {
            print("Audio file not found")
            return
        }
        
        do {
            audioPlayer?.stop() // Stop any currently playing audio
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Error playing audio: \(error.localizedDescription)")
        }
    }
}

struct GIFView: UIViewRepresentable {
    let gifName: String
    @Binding var size: CGSize
    
    func makeUIView(context: Context) -> UIImageView {
        guard let gif = try? UIImage(gifName: gifName) else {
            return UIImageView()
        }
        let imageView = UIImageView(gifImage: gif, loopCount: 120000)
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
    let action: () -> Void
    @State private var gifSize = CGSize(width: 100, height: 100)
    
    var body: some View {
        Button(action: action) {
            VStack {
                GIFView(gifName: "spinny", size:$gifSize)
                    .frame(width: 100, height: 100)
                    .cornerRadius(8)
                    .shadow(color: .white.opacity(0.2), radius: 5)
                
                Text(title)
                    .foregroundColor(.white)
                    .font(.caption)
            }
        }
        .scaleEffect(0.95)
        .animation(.spring(), value: true)
    }
}


#Preview {
    ContentView()
}
