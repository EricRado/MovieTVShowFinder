//
//  GenreService.swift
//  MovieTVShowFinder
//
//  Created by Eric Rado on 9/4/24.
//

import Foundation

struct GenreService {
    private let network: Networking
    
    init(network: Networking) {
        self.network = network
    }
    
    private func getGenreListFilePath(mediaType: MediaType) -> String {
        "genre_\(mediaType.rawValue)"
    }
    
    private func saveGenreList(_ genres: [GenreDTO], mediaType: MediaType) {
        guard let fileUrl = try? FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true).appending(path: getGenreListFilePath(mediaType: mediaType)).appendingPathExtension("json") else { return }
        
        try? JSONEncoder().encode(genres).write(to: fileUrl)
    }
    
    func getGenreList(mediaType: MediaType) async throws -> [GenreDTO] {
        let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let fileUrl = documentDirectory.appending(path: getGenreListFilePath(mediaType: mediaType)).appendingPathExtension("json")
        
        if FileManager.default.fileExists(atPath: fileUrl.path(percentEncoded: false)) {
            
            let data = try? Data(contentsOf: fileUrl)
            
            guard let unwrappedData = data else { return [] }
            
            let genres = try? JSONDecoder().decode([GenreDTO].self, from: unwrappedData)
            
            return genres ?? []
            
        } else {
            do {
                let response = try await network.execute(endpoint: GenreEndpoints.list(mediaType: mediaType), responseModel: GenreListResponse.self)
                let genres = response.genres
                
                saveGenreList(genres, mediaType: mediaType)
                
                return genres
            } catch let error {
                throw error
            }
        }
    }
}
