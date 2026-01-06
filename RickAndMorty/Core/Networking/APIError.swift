//
//  APIError.swift
//  RickAndMorty
//
//  Created by Henry Bautista on 2/01/26.
//

import Foundation

enum APIError: Error, Equatable {
    case invalidURL
    case statusCode
    case decoding
    case unknown
}
