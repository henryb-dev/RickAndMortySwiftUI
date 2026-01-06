//
//  CharacterDetailViewModel.swift
//  RickAndMorty
//
//  Created by Henry Bautista on 2/01/26.
//

import SwiftUI
import Foundation
import Combine

@MainActor
final class CharacterDetailViewModel: ObservableObject {
    @Published var character: Character?
    @Published var isLoading = false
    @Published var errorMessage: String?
    private let api: APIClientProtocol
    
    init(api: APIClientProtocol) {
        self.api = api
    }
    
    func load(id: Int) async {
        isLoading = true
        errorMessage = nil
        do {
            character = try await api.request("/character/\(id)")
        } catch {
            errorMessage = "error_detail".localized
        }
        isLoading = false
    }
}
