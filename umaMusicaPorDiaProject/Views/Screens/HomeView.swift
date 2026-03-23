import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Text("🎵 Uma Música por Dia")
                    .font(.largeTitle)
                    .bold()
                
                Text("Escolha o que deseja testar hoje:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                VStack(spacing: 15) {
                    NavigationLink(destination: ContentView()) {
                        HStack {
                            Image(systemName: "music.note")
                            Text("Flashback Diário")
                        }
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    
                    NavigationLink(destination: CollageCreatorView()) {
                        HStack {
                            Image(systemName: "plus.square.on.square")
                            Text("Criar Colagem")
                        }
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.top, 50)
        }
    }
}
