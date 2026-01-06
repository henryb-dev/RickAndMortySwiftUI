//
//  MockAPI.swift
//  RickAndMorty
//
//  Created by Henry Bautista on 2/01/26.
//


import Foundation
@testable import RickAndMorty

final class MockAPI: APIClientProtocol {
    var result: Result<Data, Error>?

    func request<T>(_ endpoint: String) async throws -> T where T : Decodable {
        switch result {
        case .success(let data):
            return try JSONDecoder().decode(T.self, from: data)
        case .failure(let error):
            throw error
        case .none:
            throw APIError.unknown
        }
    }
}
