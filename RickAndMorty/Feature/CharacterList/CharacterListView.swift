//
//  CharacterListView.swift
//  RickAndMorty
//
//  Created by Henry Bautista on 2/01/26.
//

import SwiftUI

struct CharacterListView: View {
    @StateObject var vm = CharacterListViewModel(api: APIClient())
    @FocusState private var isSearchFocused: Bool
    var body: some View {
        NavigationStack {
            VStack {
                Image("logorandm")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 320, height: 90)
                    .padding(.top, 30)
                Text("list_title".localized)
                    .font(.custom("Schwifty", size: 40))
                    .foregroundColor(Color(red: 0.15, green: 0.9, blue: 0.4))
                    .shadow(color: .black.opacity(0.6), radius: 4, x: 0, y: 4)
                    .shadow(color: Color(red: 0.15, green: 0.9, blue: 0.4).opacity(0.8), radius: 8)
                    .padding(.bottom, 8)
                searchBar
                filterPicker
                content
            }
            .id("CharacterListViewRoot")
            .padding(.top, 10)
            .background(
                LinearGradient(
                    colors: [
                        Color.black,
                        Color(red: 0.0, green: 0.3, blue: 0.1),
                        Color.black
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
            .navigationDestination(for: Int.self) { selectedId in
                CharacterDetailView(
                    viewModel: CharacterDetailViewModel(api: APIClient()),
                    id: selectedId
                )
                .onAppear() {
                    isSearchFocused = false
                    vm.searchText = ""
                    UIApplication.shared.sendAction(
                        #selector(UIResponder.resignFirstResponder),
                        to: nil,
                        from: nil,
                        for: nil
                    )
                }
            }
        }
    }
    
    // MARK: - Search Bar
    private var searchBar: some View {
        HStack {
            TextField(
                "",
                text: $vm.searchText,
                prompt: Text("search_placeholder".localized)
                    .foregroundStyle(.white.opacity(0.5))
            )
            .focused($isSearchFocused)
            .accessibilityIdentifier("searchField")
            .padding(.leading, 20)
            .padding(.vertical, 10)
            .foregroundColor(.green)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            Image(systemName: "magnifyingglass")
                .foregroundColor(.white.opacity(0.6))
                .padding(.horizontal, 20)
        }
        .background(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
        )
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
    
    // MARK: - Filter Picker
    private var filterPicker: some View {
        Picker("Status", selection: $vm.filter) {
            ForEach(StatusFilter.allCases, id: \.self) { filter in
                Text(filter.rawValue.lowercased().localized)
                    .tag(filter)
                    .accessibilityIdentifier("status_\(filter.rawValue)")
            }
        }
        .accessibilityIdentifier("statusPicker")
        .pickerStyle(.segmented)
        .padding(.horizontal)
        .onChange(of: vm.filter) {
            Task { await vm.reload() }
        }
        .onAppear {
            UISegmentedControl.appearance().setTitleTextAttributes(
                [.foregroundColor: UIColor.green],
                for: .normal
            )
            UISegmentedControl.appearance().setTitleTextAttributes(
                [.foregroundColor: UIColor.black],
                for: .selected
            )
        }
    }
    
    // MARK: - Content
    @ViewBuilder
    private var content: some View {
        switch vm.state {
        case .idle, .loading:
            ProgressView()
                .frame(maxHeight: .infinity)
            
        case .error(let msg):
            VStack {
                Text(msg)
                Button("retry".localized) {
                    vm.searchText = ""
                    Task { await vm.reload() }
                }
            }
            .frame(maxHeight: .infinity)
            
        case .empty:
            Text("no_result".localized)
                .frame(maxHeight: .infinity)
            
        case .loaded:
            List {
                Section(header: EmptyView()) {
                    ForEach(vm.characters.indices, id: \.self) { index in
                        let char = vm.characters[index]
                        NavigationLink(value: char.id) {
                            CharacterRowView(character: char)
                                .padding()
                                .background(Color.clear)
                                .cornerRadius(12)
                                .padding(.horizontal, 4)
                                .onAppear {
                                    Task { await vm.loadMoreIfNeeded(currentId: char.id) }
                                }
                        }
                        .listRowSeparator(.hidden)
                        .listRowInsets(
                            EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: -20)
                        )
                        .accessibilityIdentifier("characterrow_\(char.id)")
                    }
                }
            }
            .scrollDismissesKeyboard(.immediately)
            .listRowSpacing(16)
            .listSectionSeparator(.hidden)
            .scrollContentBackground(.hidden)
            .contentShape(Rectangle())
        }
    }
}

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
