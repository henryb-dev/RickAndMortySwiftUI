//
//  CharacterDetailViewModelTests.swift
//  RickAndMorty
//
//  Created by Henry Bautista on 2/01/26.
//


import XCTest
import Combine
@testable import RickAndMorty

@MainActor
final class CharacterDetailViewModelTests: XCTestCase {
    func test_load_success_setsCharacter_andStopsLoading() async throws {
        // Arrange
        let mock = MockAPI()
        let json = """
        {
            "id": 1,
            "name": "Rick Sanchez",
            "status": "Alive",
            "species": "Human",
            "gender": "Male",
            "image": "url",
            "origin": { "name": "Earth" },
            "location": { "name": "Citadel of Ricks" },
            "episode": []
        }
        """.data(using: .utf8)!
        mock.result = .success(json)
        let vm = CharacterDetailViewModel(api: mock)

        // Act
        await vm.load(id: 1)
        let view = CharacterDetailView(viewModel: vm, id: 1)
        _ = view.body

        // Assert
        XCTAssertNotNil(vm.character)
        XCTAssertEqual(vm.character?.name, "Rick Sanchez")
        XCTAssertFalse(vm.isLoading)
        XCTAssertNil(vm.errorMessage)
        
    }

    func test_load_failure_setsErrorMessage() async {
        // Arrange
        let mock = MockAPI()
        mock.result = .failure(APIError.statusCode)
        let vm = CharacterDetailViewModel(api: mock)

        // Act
        await vm.load(id: 999)

        // Assert
        XCTAssertNil(vm.character)
        XCTAssertNotNil(vm.errorMessage)
        XCTAssertFalse(vm.isLoading)
    }

    func test_isLoading_togglesCorrectly() async {
        // Arrange
        let mock = MockAPI()
        let json = """
        {
            "id": 1,
            "name": "Morty Smith",
            "status": "Alive",
            "species": "Human",
            "gender": "Male",
            "image": "url",
            "origin": { "name": "unknown" },
            "location": { "name": "Citadel" },
            "episode": []
        }
        """.data(using: .utf8)!
        mock.result = .success(json)
        let vm = CharacterDetailViewModel(api: mock)

        // Before load
        XCTAssertFalse(vm.isLoading)

        // Act
        await vm.load(id: 1)

        // After load
        XCTAssertFalse(vm.isLoading)
    }
}
