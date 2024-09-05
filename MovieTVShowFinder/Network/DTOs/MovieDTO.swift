//
//  MovieDTO.swift
//  MovieTVShowFinder
//
//  Created by Eric Rado on 8/5/24.
//

import Foundation

struct MovieResponse: Decodable {
    let page: Int
    let results: [MovieDTO]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct MovieDTO: Decodable, Identifiable {
    let id: Int
    let title: String
    let releaseDate: String
    let details: String
    private let backdropPath: String?
    private let posterPath: String
    let genreIds: [Int]
    let rating: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case releaseDate = "release_date"
        case details = "overview"
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
        case genreIds = "genre_ids"
        case rating = "vote_average"
    }
    
    var backdropImageUrlString: String {
        guard let backdropPath = self.backdropPath else { return "" }
        
        return Network.originalImageSizeHostPath + backdropPath
    }
    
    var posterImageUrlString: String {
        Network.mediumImageSizeHostPath + posterPath
    }
}
