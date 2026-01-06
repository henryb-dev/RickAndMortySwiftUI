//
//  APIClientTests.swift
//  RickAndMorty
//
//  Created by Henry Bautista on 2/01/26.
//


import XCTest
import Combine
@testable import RickAndMorty

@MainActor
final class APIClientTests: XCTestCase {
    func testDecodingSuccess() async throws {
        let mock = MockAPI()
        let json = """
        {"results":[{"id":1,"name":"Rick","status":"Alive","species":"Human","gender":"Male","image":"url","origin":{"name":"Earth"},"location":{"name":"Citadel"},"episode":[]}] ,"info":{"next":null}}
        """.data(using: .utf8)!
        mock.result = .success(json)
        let data: CharacterResponse = try await mock.request("/character")
        XCTAssertEqual(data.results.first?.name, "Rick")
    }

    func test_request_statusCodeUnknown() {
        let api = MockAPI()
        let exp = expectation(description: "API request completes with unknown error")
        Task {
            do {
                let _: CharacterResponse = try await api.request("/unknown-endpoint-404")
                XCTFail("Expected unknown error")
            } catch let error as APIError {
                XCTAssertEqual(error, .unknown)
            } catch {
                XCTFail("Unexpected error type: \(error)")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2.0)
    }


}
