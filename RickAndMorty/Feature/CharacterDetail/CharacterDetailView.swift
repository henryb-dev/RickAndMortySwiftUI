//
//  CharacterDetailView.swift
//  RickAndMorty
//
//  Created by Henry Bautista on 2/01/26.
//


import SwiftUI

struct CharacterDetailView: View {
    @StateObject var viewModel: CharacterDetailViewModel
    @State private var bounce = false
    let id: Int
    var body: some View {
        ScrollView {
            if let c = viewModel.character {
                VStack(spacing: 16) {
                    AsyncImage(url: URL(string: c.image)) { img in
                        img.resizable()
                    } placeholder: {
                        Color.gray.opacity(0.2)
                    }
                    .scaledToFill()
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .scaleEffect(bounce ? 1.0 : 0.3)
                    .opacity(bounce ? 1.0 : 0.0)
                    .animation(.easeOut(duration: 0.8), value: bounce)
                    .onAppear {
                        withAnimation(.easeOut(duration: 0.8)) {
                            bounce = true
                        }
                    }
                    Text(viewModel.character?.name ?? "load".localized)
                         .font(.custom("Schwifty", size: 40))
                         .foregroundColor(Color(red: 0.15, green: 0.9, blue: 0.4))
                         .shadow(color: Color.black.opacity(0.6), radius: 4, x: 0, y: 4)
                         .shadow(color: Color(red: 0.15, green: 0.9, blue: 0.4).opacity(0.8), radius: 8, x: 0, y: 0)
                         .multilineTextAlignment(.leading)
                         .lineLimit(nil)
                         .fixedSize(horizontal: false, vertical: true)
                         .padding(.top, 50)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(" • " + "status".localized + "\(c.status.lowercased().localized)")
                            .foregroundColor(Color(red: 0.3, green: 0.9, blue: 0.6))
                            .padding(.top, 25)
                        Text(" • " + "specie".localized + "\(c.species.lowercased().localized)")
                            .foregroundColor(Color(red: 0.3, green: 0.9, blue: 0.6))
                            .padding(.top, 0)
                        Text(" • " + "gender".localized + "\(c.gender.lowercased().localized)")
                            .foregroundColor(Color(red: 0.3, green: 0.9, blue: 0.6))
                            .padding(.top, 0)
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text("origin".localized + "\(c.origin.name.localized)")
                            .foregroundColor(Color(red: 0.15, green: 0.9, blue: 0.4))
                        Text("location".localized + "\(c.location.name.localized)")
                            .foregroundColor(Color(red: 0.15, green: 0.9, blue: 0.4))
                                  Text("episode".localized + "\(c.episode.count)")
                            .foregroundColor(Color(red: 0.15, green: 0.9, blue: 0.4))
                    }
                    .font(.subheadline)
                    .padding()
                }
            } else if viewModel.isLoading {
                ProgressView()
            } else if let err = viewModel.errorMessage {
                VStack {
                    Text(err)
                    Button("retry".localized) {
                        Task { await viewModel.load(id: id) }
                    }
                }
            }
        }
        .task { await viewModel.load(id: id) }
        .navigationBarTitleDisplayMode(.automatic)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("detail_title".localized)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.green)
                    .accessibilityIdentifier("detailTitle")
            }
        }
        .padding()
        .background {
            ZStack {
                Color.black.ignoresSafeArea()
                LinearGradient(
                    colors: [.black,
                             Color(red: 0.0, green: 0.3, blue: 0.1),
                             .black],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .blur(radius: 0.1)
            }
        }
    }
}
