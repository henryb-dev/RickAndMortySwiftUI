//
//  RootView.swift
//  RickAndMorty
//
//  Created by Henry Bautista on 2/01/26.
//


import SwiftUI

struct RootView: View {
    @ObservedObject private var vm = CharacterListViewModel(api: APIClient())
    @State private var isReady = false
    var body: some View {
        Group {
            if !isReady {
                ZStack {
                    VStack(spacing: 20) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 60))
                            .foregroundColor(.green)
                        
                        Text("load_title".localized)
                            .font(.title3)
                            .foregroundColor(.green)
                        
                        ProgressView()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .task {
                        await vm.reload()
                        withAnimation { isReady = true }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(red: 0.015686, green: 0.145098, blue: 0.058823))
                .ignoresSafeArea()
            } else {
                CharacterListView()
            }
        }
    }
}
