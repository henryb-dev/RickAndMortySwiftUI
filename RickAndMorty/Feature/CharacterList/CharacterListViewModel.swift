//
//  CharacterListViewModel.swift
//  RickAndMorty
//
//  Created by Henry Bautista on 2/01/26.
//


import Foundation
import Combine

@MainActor
final class CharacterListViewModel: ObservableObject {
    enum State {
        case idle
        case loading
        case loaded
        case empty
        case error(String)
    }
    @Published var characters: [Character] = []
    @Published var searchText: String = ""
    @Published var filter: StatusFilter = .all
    @Published var state: State = .idle
    private var page = 1
    private var canLoadMore = true
    private var api: APIClientProtocol
    private var searchTask: Task<(), Never>?
    private var cancellables = Set<AnyCancellable>()
    
    init(api: APIClientProtocol) {
        self.api = api
        setupSearchDebounce()
    }
    
    private func setupSearchDebounce() {
        $searchText
            .debounce(for: .milliseconds(180), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] text in
                guard let self else { return }
                self.searchTask?.cancel()
                self.searchTask = Task { @MainActor in
                    await self.reload()
                }
            }
            .store(in: &cancellables)
    }

    func reload() async {
        page = 1
        canLoadMore = true
        characters = []
        await loadPage(reset: true)
    }
    
    func loadMoreIfNeeded(currentId: Int) async {
        guard let last = characters.last, last.id == currentId else { return }
        await loadPage(reset: false)
    }
    
    func loadPage(reset: Bool) async {
        guard canLoadMore else { return }
        if reset { state = .loading }
        var endpoint = "/character/?page=\(page)"
        if let name = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           !name.isEmpty {
            endpoint += "&name=\(name)"
        }
        if let f = filter.queryValue {
            endpoint += "&status=\(f)"
        }
        do {
            let resp: CharacterResponse = try await api.request(endpoint)
            if reset && resp.results.isEmpty {
                state = .empty
                return
            }
            characters.append(contentsOf: resp.results)
            state = .loaded
            page += 1
            canLoadMore = resp.info.next != nil
        } catch {
            state = .error("failed".localized)
        }
    }
}
