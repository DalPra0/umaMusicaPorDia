//import SwiftUI
//import WebKit
//
//struct YouTubePlayerView: UIViewRepresentable {
//    let videoId: String
//    
//    func makeUIView(context: Context) -> WKWebView {
//        let configuration = WKWebViewConfiguration()
//        configuration.allowsInlineMediaPlayback = true
//        configuration.mediaTypesRequiringUserActionForPlayback = []
//        
//        let webView = WKWebView(frame: .zero, configuration: configuration)
//        webView.backgroundColor = .black
//        webView.isOpaque = false
//        webView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1"
//        return webView
//    }
//    
//    func updateUIView(_ uiView: WKWebView, context: Context) {
//        let html = """
//        <!DOCTYPE html>
//        <html>
//        <head>
//            <meta name="viewport" content="width=device-width, initial-scale=1.0">
//            <style>body { margin: 0; padding: 0; background: black; }</style>
//        </head>
//        <body>
//            <div id="player"></div>
//            <script src="https://www.youtube.com/iframe_api"></script>
//            <script>
//                var player;
//                function onYouTubeIframeAPIReady() {
//                    player = new YT.Player('player', {
//                        height: '100%', width: '100%', videoId: '\(videoId)',
//                        playerVars: { 'playsinline': 1, 'autoplay': 1, 'origin': 'https://www.youtube.com' }
//                    });
//                }
//            </script>
//        </body>
//        </html>
//        """
//        uiView.loadHTMLString(html, baseURL: URL(string: "https://www.youtube.com"))
//    }
//}
//
//struct ContentView: View {
//    @StateObject private var viewModel = MusicViewModel()
//    @State private var showDebug = false
//    
//    var body: some View {
//        ScrollView {
//            VStack(spacing: 20) {
//                Text("Flashback Diário")
//                    .font(.largeTitle).bold()
//                
//                if let word = viewModel.dailyWord {
//                    VStack {
//                        Text("PALAVRA DO DIA")
//                            .font(.caption)
//                            .tracking(2)
//                            .foregroundColor(.secondary)
//                        Text(word.word)
//                            .font(.title2)
//                            .bold()
//                            .foregroundColor(.purple)
//                    }
//                    .padding()
//                    .background(Color.purple.opacity(0.1))
//                    .cornerRadius(15)
//                } else if viewModel.isLoadingWord {
//                    ProgressView("Buscando palavra do dia...")
//                }
//                
//                Text("Hoje: \(viewModel.selectedDayMonth)/\(String(viewModel.selectedYear))")
//                    .font(.title2).foregroundColor(.blue)
//                
//                VStack {
//                    Text(viewModel.trackName).font(.title3).bold().multilineTextAlignment(.center)
//                    Text(viewModel.artistName).font(.subheadline).foregroundColor(.secondary)
//                }
//                
//                if let videoId = viewModel.videoId {
//                    YouTubePlayerView(videoId: videoId)
//                        .frame(height: 250)
//                        .cornerRadius(12)
//                        .shadow(radius: 5)
//                } else {
//                    ProgressView("Sintonizando rádio de \(String(viewModel.selectedYear))...")
//                        .frame(height: 250)
//                }
//                
//                Button(action: { viewModel.loadDailyNostalgia() }) {
//                    Text("Girar Máquina do Tempo")
//                        .bold().frame(maxWidth: .infinity).padding().background(Color.blue).foregroundColor(.white).cornerRadius(10)
//                }
//                
//                Button(showDebug ? "Esconder Debug" : "Mostrar Debug Detalhado") {
//                    showDebug.toggle()
//                }
//                .font(.caption)
//                
//                if showDebug {
//                    VStack(alignment: .leading, spacing: 10) {
//                        Text("--- DEBUG INFO ---").bold()
//                        Text("Data Alvo: \(viewModel.selectedDayMonth)/\(String(viewModel.selectedYear))")
//                        Text("URL API: \(viewModel.appleMusicUrl)").font(.system(size: 8))
//                        
//                        Text("Músicas encontradas no Brasil (\(viewModel.tracksFound.count)):")
//                            .font(.caption).bold()
//                        
//                        ForEach(viewModel.tracksFound.prefix(10)) { track in
//                            Text("• \(track.trackName ?? "") - \(track.artistName ?? "")")
//                                .font(.system(size: 9))
//                                .foregroundColor(.gray)
//                        }
//                        
//                        if viewModel.tracksFound.isEmpty {
//                            Text("Nenhuma música filtrada pela data. Buscando hits gerais de \(String(viewModel.selectedYear))...").font(.caption).foregroundColor(.red)
//                        }
//                    }
//                    .padding().background(Color.gray.opacity(0.1)).cornerRadius(8)
//                }
//            }
//            .padding()
//        }
//        .onAppear { viewModel.loadInitialData() }
//    }
//}
