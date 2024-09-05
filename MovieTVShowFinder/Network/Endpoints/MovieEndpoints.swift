//
//  MovieEndpoints.swift
//  MovieTVShowFinder
//
//  Created by Eric Rado on 8/3/24.
//

import Foundation

enum MovieEndpoints: Endpoint {
    
    enum DiscoverQueryParameterKeys: String {
        case genre = "with_genres"
    }
    
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
    case discover(parameterAndKeyValues: [(DiscoverQueryParameterKeys, Any)])
    
    var path: String {
        switch self {
        case .discover:
            return "/3/discover/movie"
        case .list(let listType, _):
            return "/3/movie/\(listType.rawValue)"
        case .trending(let timeWindow):
            return "/3/trending/movie/\(timeWindow.rawValue)"
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .discover, .list, .trending:
            return .get
        }
    }
    
    var queryParameters: [String : Any]? {
        switch self {
        case .discover(let parameterAndKeyValues):
            var parameters: [String: Any] = [:]
            
            for parameterAndKeyValue in parameterAndKeyValues {
                let (key, value) = parameterAndKeyValue
                parameters[key.rawValue] = value
            }
            
            return parameters
        case .list(_, let pageCount):
            return ["page": pageCount]
        case .trending:
            return nil
        }
    }
    
    var body: [String : Any]? {
        switch self {
        case .discover, .list, .trending:
            return nil
        }
    }
}
