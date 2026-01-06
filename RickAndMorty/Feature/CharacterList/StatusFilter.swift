//
//  StatusFilter.swift
//  RickAndMorty
//
//  Created by Henry Bautista on 2/01/26.
//


import Foundation

enum StatusFilter: String, CaseIterable {
    case all = "All"
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "Unknown"

    var queryValue: String? {
        switch self {
        case .all: return nil
        case .alive, .dead, .unknown: return rawValue
        }
    }
}
