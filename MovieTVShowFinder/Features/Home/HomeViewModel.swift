//
//  HomeViewModel.swift
//  MovieTVShowFinder
//
//  Created by Eric Rado on 8/5/24.
//

import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    private let networking: Networking
    
    @Published var heroDatasource: [MovieDTO] = []
    @Published var cardCarouselDatasource: [MovieDTO] = []
    @Published var movies: [MovieDTO] = []
    
    init(networking: Networking) {
        self.networking = networking
    }
    
    func load() async {
        async let popularMovies = getMovies(endpoint: .list(.popular, pageCount: 1))
        async let upcomingMovies = getMovies(endpoint: .list(.upcoming, pageCount: 1))
        async let topRatedMovies = getMovies(endpoint: .list(.topRated, pageCount: 1))
        async let nowPlayingMovies = getMovies(endpoint: .list(.nowPlaying, pageCount: 1))
        async let trendingByDayMovies = getMovies(endpoint: .trending(.day))
        async let trendingByWeekMovies = getMovies(endpoint: .trending(.week))
        
        await heroDatasource.append(contentsOf: popularMovies)
        await cardCarouselDatasource.append(contentsOf: trendingByDayMovies)
        await movies.append(contentsOf: trendingByWeekMovies)
    }
    
    private func getMovies(endpoint: MovieEndpoints) async -> [MovieDTO] {
        let result = await networking.execute(endpoint: endpoint, responseModel: MovieResponse.self)
        
        var movies: [MovieDTO] = []
        
        switch result {
        case .success(let movieResponse):
            movies = movieResponse.results
        case .failure(let failure):
            // TODO: - Add better error handling
            print("\(endpoint) \(failure.customMessage)")
        }
        
        return movies
    }
}
