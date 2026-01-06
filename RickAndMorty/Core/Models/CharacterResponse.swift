//
//  CharacterResponse.swift
//  RickAndMorty
//
//  Created by Henry Bautista on 2/01/26.
//

struct CharacterResponse: Decodable {
    let results: [Character]
    let info: Info
}
