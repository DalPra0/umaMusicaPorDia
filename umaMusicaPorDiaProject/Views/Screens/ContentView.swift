import SwiftUI
import WebKit

struct YouTubePlayerView: UIViewRepresentable {
    let videoId: String
    
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.backgroundColor = .black
        webView.isOpaque = false
        
        // Esta é a parte mais importante: burlar a detecção de "In-App Browser"
        // Definir um User-Agent de Safari Real no iPhone
        webView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1"
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // IFrame Player API - Implementação idêntica ao YouTube iOS Player Helper oficial
        let html = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
            <style>
                body { margin: 0; padding: 0; background-color: black; overflow: hidden; }
                #player { width: 100vw; height: 100vh; }
            </style>
        </head>
        <body>
            <div id="player"></div>
            <script>
                var tag = document.createElement('script');
                tag.src = "https://www.youtube.com/iframe_api";
                var firstScriptTag = document.getElementsByTagName('script')[0];
                firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

                var player;
                function onYouTubeIframeAPIReady() {
                    player = new YT.Player('player', {
                        height: '100%',
                        width: '100%',
                        videoId: '\(videoId)',
                        playerVars: {
                            'playsinline': 1,
                            'autoplay': 1,
                            'controls': 1,
                            'modestbranding': 1,
                            'rel': 0,
                            'origin': 'https://www.youtube.com'
                        },
                        events: {
                            'onReady': onPlayerReady
                        }
                    });
                }
                function onPlayerReady(event) {
                    event.target.playVideo();
                }
            </script>
        </body>
        </html>
        """
        
        // O baseURL deve ser youtube.com para o origin ser aceito
        uiView.loadHTMLString(html, baseURL: URL(string: "https://www.youtube.com"))
    }
}

struct ContentView: View {
    @StateObject private var viewModel = MusicViewModel()
    @State private var showDebug = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 4) {
                    Text("Flashback Diário")
                        .font(.largeTitle)
                        .bold()
                    Text("A música famosa neste dia em...")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Text(String(viewModel.selectedYear))
                    .font(.system(size: 80, weight: .black, design: .rounded))
                    .foregroundColor(.blue.opacity(0.8))
                
                VStack(spacing: 8) {
                    Text(viewModel.trackName)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .bold()
                    Text(viewModel.artistName)
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                
                if let videoId = viewModel.videoId {
                    VStack(spacing: 16) {
                        YouTubePlayerView(videoId: videoId)
                            .frame(height: 250)
                            .background(Color.black)
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.3), radius: 10)
                        
                        Button(action: {
                            let url = URL(string: "https://www.youtube.com/watch?v=\(videoId)")!
                            UIApplication.shared.open(url)
                        }) {
                            Text("Abrir no YouTube (Link Direto)")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                } else {
                    VStack(spacing: 12) {
                        ProgressView()
                        Text("Sintonizando rádio de \(String(viewModel.selectedYear))...")
                            .font(.caption)
                            .italic()
                    }
                    .frame(height: 250)
                }
                
                Button(action: {
                    viewModel.loadDailyNostalgia()
                }) {
                    HStack {
                        Image(systemName: "clock.arrow.2.circlepath")
                        Text("Sortear Outro Ano")
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                
                Button("Ver Diagnóstico de API") {
                    showDebug.toggle()
                }
                .font(.caption2)
                .padding(.top)
                
                if showDebug {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("API Debug:")
                            .bold()
                        Text(viewModel.lastFMUrl)
                            .font(.system(size: 7, design: .monospaced))
                            .lineLimit(2)
                        Text("Video ID: \(viewModel.videoId ?? "N/A")")
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
            }
            .padding()
        }
        .onAppear {
            viewModel.loadDailyNostalgia()
        }
    }
}
