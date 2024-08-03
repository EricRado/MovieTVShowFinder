//
//  Endpoint.swift
//  MovieTVShowFinder
//
//  Created by Eric Rado on 8/2/24.
//

import Foundation

protocol Endpoint {
    var host: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var headers: [String: String]? { get }
    var body: [String: String]? { get }
}

extension Endpoint {
    var host: String {
        "https://api.themoviedb.org"
    }
}
