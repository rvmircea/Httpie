// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public actor Httpie {
    private let baseAddress: String
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    init(baseAddress: String) {
        self.baseAddress = baseAddress
        self.decoder = JSONDecoder()
        self.encoder = JSONEncoder()
    }
    
    public func getFromJson<T: Codable> (endpoint: String) async throws -> T? {
        do {
            guard let url = URL(string: "\(baseAddress)\(endpoint)") else { return nil }
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            return try self.decoder.decode(T.self, from: data)
        } catch {
            return nil
        }
    }
}
