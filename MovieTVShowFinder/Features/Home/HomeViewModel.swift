//
//  HomeViewModel.swift
//  MovieTVShowFinder
//
//  Created by Eric Rado on 8/5/24.
//

import Foundation

final class HomeViewModel: ObservableObject {
    private let networking: Networking
    
    // TODO: - Replace data source to enable more media support
    @Published var movies: [MovieDTO] = []
    
    init(networking: Networking) {
        self.networking = networking
    }
    
    @MainActor func getTrendingMovies() async {
        let result = await networking.execute(endpoint: MovieEndpoints.trending(.week), responseModel: MovieResponse.self)
        
        switch result {
        case .success(let movieResponse):
            movies = movieResponse.results
        case .failure(let failure):
            // TODO: - Add better error handling
            print(failure.localizedDescription)
        }
    }
}
