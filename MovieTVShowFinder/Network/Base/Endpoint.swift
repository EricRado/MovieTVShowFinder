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
    var headers: [String: String] { get }
    var body: [String: Any]? { get }
}

extension Endpoint {
    var scheme: String {
        "https"
    }
    
    var host: String {
        "api.themoviedb.org"
    }
    
    var headers: [String: String] {
        // Access Token to use in Bearer header
        let accessToken = ""
        
        return [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json;charset=utf-8"
        ]
    }
}
