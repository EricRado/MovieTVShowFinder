//
//  HomeViewModel.swift
//  MovieTVShowFinder
//
//  Created by Eric Rado on 8/5/24.
//

import Foundation

struct CarouselViewModel: Identifiable {
    var id: String {
        UUID().uuidString
    }
    
    let title: String
    let movies: [MovieDTO]
}

@MainActor
final class HomeViewModel: ObservableObject {
    private let networking: Networking
    private let genreService: GenreService
    
    @Published var heroDatasource: [MovieDTO] = []
    @Published var cardCarouselDatasource: [MovieDTO] = []
    @Published var carouselViewModels: [CarouselViewModel] = []
    private var movieGenres: [GenreDTO] = []
    
    init(networking: Networking, genreService: GenreService) {
        self.networking = networking
        self.genreService = genreService
    }
    
    func load() async {
        async let movieGenres = getMovieGenres()
        async let popularMovies = getMovies(endpoint: .list(.popular, pageCount: 1))
        async let upcomingMovies = getMovies(endpoint: .list(.upcoming, pageCount: 1))
        async let topRatedMovies = getMovies(endpoint: .list(.topRated, pageCount: 1))
        async let nowPlayingMovies = getMovies(endpoint: .list(.nowPlaying, pageCount: 1))
        async let trendingByDayMovies = getMovies(endpoint: .trending(.day))
        async let trendingByWeekMovies = getMovies(endpoint: .trending(.week))
        
        for movieGenre in await Array(movieGenres.shuffled().prefix(upTo: 3)) {
            let movieId = String(movieGenre.id)
            
            async let movies = getMovies(endpoint: .discover(parameterAndKeyValues: [(.genre, movieId)]))
            self.carouselViewModels.append(CarouselViewModel(title: movieGenre.name, movies: await movies))
        }
        
        self.movieGenres = await movieGenres
        
        await heroDatasource.append(contentsOf: popularMovies)
        await cardCarouselDatasource.append(contentsOf: trendingByDayMovies)
        await carouselViewModels.append(CarouselViewModel(title: "Trending This Week", movies: trendingByWeekMovies))
    }
    
    private func getMovieGenres() async -> [GenreDTO] {
        var genres: [GenreDTO] = []
        
        do {
            genres = try await genreService.getGenreList(mediaType: .movie)
        } catch let error {
            print("Genre service : \(error.localizedDescription)")
        }
        
        return genres
    }
    
    private func getMovies(endpoint: MovieEndpoints) async -> [MovieDTO] {
        var movies: [MovieDTO] = []
        
        do {
            let response = try await networking.execute(endpoint: endpoint, responseModel: MovieResponse.self)
            movies = response.results
        } catch let error {
            print("\(endpoint) \(error.localizedDescription)")
        }
        
        return movies
    }
}
