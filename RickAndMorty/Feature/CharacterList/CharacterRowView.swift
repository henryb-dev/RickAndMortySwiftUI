//
//  CharacterRowView.swift
//  RickAndMorty
//
//  Created by Henry Bautista on 2/01/26.
//


import SwiftUI

struct CharacterRowView: View {
    let character: Character
    var body: some View {
        HStack(spacing: 14) {
            AsyncImage(url: URL(string: character.image)) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.25))
                        ProgressView()
                            .scaleEffect(1.3)
                    }
                    .frame(width: 80, height: 80)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .transition(.opacity.animation(.easeInOut(duration: 0.25)))
                case .failure:
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.red.opacity(0.2))
                        Image(systemName: "photo.fill")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(.red)
                    }
                    .frame(width: 80, height: 80)
                @unknown default:
                    EmptyView()
                }
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(character.name)
                    .font(.custom("Schwifty", size: 30))
                    .foregroundColor(Color.black)
                    .shadow(color: Color.black.opacity(0.6), radius: 4, x: 0, y: 4)
                    .shadow(color: Color(red: 0.15, green: 0.9, blue: 0.4).opacity(0.8), radius: 8, x: 0, y: 0)
                Text(character.status.lowercased().localized)
                    .font(.subheadline)
                    .foregroundColor(Color.green)
                    .fontDesign(.monospaced)
            }
            Spacer()
        }
        .padding(.vertical, 4)
    }
}
