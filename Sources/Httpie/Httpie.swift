// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public actor Httpie {
    private let baseAddress: String
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    public init(baseAddress: String) {
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
    
    public func postFromJson<TReq: Codable> (endpoint: String, data body: TReq?) async throws -> Void {
        do {
            guard let url = URL(string: "\(baseAddress)\(endpoint)") else { return }
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "post"
            
            let requestBody = try self.encoder.encode(body)
            
            let _ = try await URLSession.shared.upload(for: request, from: requestBody)
        } catch let error {
            print(error)
        }
    }
    
    public func postFromJson<TReq: Codable, TResp: Codable> (endpoint: String, data body: TReq?) async throws -> TResp? {
        do {
            guard let url = URL(string: "\(baseAddress)\(endpoint)") else { return nil }
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "post"
            
            let requestBody = try self.encoder.encode(body)
            
            let (data, _) = try await URLSession.shared.upload(for: request, from: requestBody)
            
            return try self.decoder.decode(TResp.self, from: data)
        } catch {
            return nil
        }
    }
}
