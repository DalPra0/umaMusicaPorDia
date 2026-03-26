import Foundation
import Supabase

/// Cliente Supabase compartilhado entre o app principal e extensões
/// Usa App Groups + Keychain para compartilhar a sessão de autenticação
final class SharedSupabaseClient {
    static let shared = SharedSupabaseClient()
    
    private let appGroupID = "group.com.dalpra.nostalgia"
    
    let client: SupabaseClient
    
    private init() {
        // Configurar armazenamento usando App Groups
        let groupURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: appGroupID
        )!
        
        let supabaseURL = URL(string: "https://nyqetgzzvcitftejsrue.supabase.co")!
        let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im55cWV0Z3p6dmNpdGZ0ZWpzcnVlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM4NjM1ODYsImV4cCI6MjA4OTQzOTU4Nn0.Cug2NDaRwy-Ldv1tdMuNlU8a9Vph1D_9wAT1qB9-vwg"
        
        self.client = SupabaseClient(
            supabaseURL: supabaseURL,
            supabaseKey: supabaseKey,
            options: SupabaseClientOptions(
                auth: .init(
                    storage: AppGroupSessionStorage(groupURL: groupURL),
                    flowType: .pkce
                )
            )
        )
    }
}

/// Armazena sessão no App Group para compartilhar entre app e extensões
final class AppGroupSessionStorage: AuthLocalStorage {
    private let groupURL: URL
    
    init(groupURL: URL) {
        self.groupURL = groupURL
    }
    
    private func fileURL(for key: String) -> URL {
        groupURL.appendingPathComponent(key)
    }
    
    func store(key: String, value: Data) throws {
        let fileURL = fileURL(for: key)
        try value.write(to: fileURL, options: .atomic)
    }
    
    func retrieve(key: String) throws -> Data? {
        let fileURL = fileURL(for: key)
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return nil
        }
        return try Data(contentsOf: fileURL)
    }
    
    func remove(key: String) throws {
        let fileURL = fileURL(for: key)
        if FileManager.default.fileExists(atPath: fileURL.path) {
            try FileManager.default.removeItem(at: fileURL)
        }
    }
}
