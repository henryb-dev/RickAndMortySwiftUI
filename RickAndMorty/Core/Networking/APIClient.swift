//
//  APIClient.swift
//  RickAndMorty
//
//  Created by Henry Bautista on 2/01/26.
//

import Foundation

protocol APIClientProtocol {
    func request<T: Decodable>(_ endpoint: String) async throws -> T
}

final class APIClient: APIClientProtocol {
    private let base = "https://rickandmortyapi.com/api"
    
    func request<T: Decodable>(_ endpoint: String) async throws -> T {
        guard let url = URL(string: base + endpoint) else {
            throw APIError.invalidURL
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let http = response as? HTTPURLResponse,
              200..<300 ~= http.statusCode else {
            throw APIError.statusCode
        }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.decoding
        }
    }
}
