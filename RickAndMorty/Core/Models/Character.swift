//
//  Character.swift
//  RickAndMorty
//
//  Created by Henry Bautista on 2/01/26.
//

struct Character: Decodable, Identifiable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let gender: String
    let image: String
    let origin: SimpleLocation
    let location: SimpleLocation
    let episode: [String]
}
