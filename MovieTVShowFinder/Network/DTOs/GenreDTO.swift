//
//  GenreDTO.swift
//  MovieTVShowFinder
//
//  Created by Eric Rado on 9/4/24.
//

import Foundation

struct GenreListResponse: Decodable {
    let genres: [GenreDTO]
}

struct GenreDTO: Codable {
    let id: Int
    let name: String
}
