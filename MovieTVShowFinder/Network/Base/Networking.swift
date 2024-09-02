//
//  Networking.swift
//  MovieTVShowFinder
//
//  Created by Eric Rado on 8/2/24.
//

import Foundation

struct Network: Networking {}

extension Network {
    static let mediumImageSizeHostPath = "https://image.tmdb.org/t/p/w500"
    static let originalImageSizeHostPath = "https://image.tmdb.org/t/p/original"
}

protocol Networking {
    func execute<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async -> Result<T, RequestError>
}

extension Networking {
    func execute<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async -> Result<T, RequestError> {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        
        guard let url = urlComponents.url else {
            return .failure(.invalidUrl)
        }
        
        var urlQueryItems = Array<URLQueryItem>()
        for (key, value) in endpoint.queryParameters ?? [:] {
            guard let valueString = value as? String else { continue }
            urlQueryItems.append(URLQueryItem(name: key, value: valueString))
        }
        
        let urlWithQueryParams = url.appending(queryItems: urlQueryItems)
        
        var urlRequest = URLRequest(url: urlWithQueryParams)
        
        urlRequest.httpMethod = endpoint.method.rawValue
        urlRequest.allHTTPHeaderFields = endpoint.headers
        
        if let body = endpoint.body {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noResponse)
            }
            
            switch response.statusCode {
            case 200...299:
                guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else {
                    return .failure(.decode)
                }
                
                return .success(decodedResponse)
            case 401:
                return .failure(.unauthorized)
            default:
                return .failure(.unexpectedStatusCode)
            }
        } catch {
            return .failure(.unknown)
        }
    }
}
