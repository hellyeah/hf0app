//
//  ContentView.swift
//  foundermeditations
//
//  Created by hellyeah on 1/21/25.
//

import SwiftUI
import SwiftyGif

struct ContentView: View {

    
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
        GIFView(gifName: "spinny.gif")
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        
        

        
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
