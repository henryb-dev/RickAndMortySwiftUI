//
//  CharacterListViewModelTests.swift
//  RickAndMorty
//
//  Created by Henry Bautista on 2/01/26.
//


import XCTest
import Combine
@testable import RickAndMorty

@MainActor
final class CharacterListViewModelTests: XCTestCase {
    func testSearchResetsPagination() async throws {
        let mock = MockAPI()
        let json = """
        {"results":[],"info":{"next":null}}
        """.data(using: .utf8)!
        mock.result = .success(json)
        let vm = CharacterListViewModel(api: mock)
        let expectation = XCTestExpectation(description: "Characters updated")
        var cancellables = Set<AnyCancellable>()
        
        vm.$characters
            .sink { chars in
                if chars.count == 0 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        vm.searchText = "Rick"

        await fulfillment(of: [expectation], timeout: 2.0)
        XCTAssertEqual(vm.characters.count, 0)
    }
}
