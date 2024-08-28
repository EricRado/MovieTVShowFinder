//
//  MovieEndpoints.swift
//  MovieTVShowFinder
//
//  Created by Eric Rado on 8/3/24.
//

import Foundation

enum MovieEndpoints: Endpoint {
    
    enum TimeWindow: String {
        case day
        case week
    }
    
    enum ListType: String {
        case nowPlaying = "now_playing"
        case popular
        case topRated = "top_rated"
        case upcoming
    }
    
    case list(ListType, pageCount: Int)
    case trending(TimeWindow = .day)
    
    var path: String {
        switch self {
        case .list(let listType, _):
            return "/movie/\(listType.rawValue)"
        case .trending(let timeWindow):
            return "/3/trending/movie/\(timeWindow.rawValue)"
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .list, .trending:
            return .get
        }
    }
    
    var body: [String : Any]? {
        switch self {
        case .list(_, let pageCount):
            return ["page": pageCount]
        case .trending:
            return nil
        }
    }
}
