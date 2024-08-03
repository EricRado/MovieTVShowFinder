//
//  RequestError.swift
//  MovieTVShowFinder
//
//  Created by Eric Rado on 8/2/24.
//

import Foundation

enum RequestError: Error {
    case decode
    case invalidUrl
    case noResponse
    case unauthorized
    case unexpectedStatusCode
    case unknown
    
    var customMessage: String {
        switch self {
        case .decode:
            return "Decode Error"
        case .unauthorized:
            return "Session Expired"
        default:
            return "Unknown Error"
        }
    }
}
