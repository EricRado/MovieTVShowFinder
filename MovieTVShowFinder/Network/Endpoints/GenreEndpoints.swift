//
//  GenreEndpoints.swift
//  MovieTVShowFinder
//
//  Created by Eric Rado on 9/4/24.
//

import Foundation

enum MediaType: String {
    case movie
    case tv
}

enum GenreEndpoints: Endpoint {
    case list(mediaType: MediaType)
    
    var path: String {
        switch self {
        case .list(let mediaType):
            return "/3/genre/\(mediaType.rawValue)/list"
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .list:
            return .get
        }
    }
    
    var queryParameters: [String : Any]? {
        return nil
    }
    
    var body: [String : Any]? {
        return nil
    }
}
