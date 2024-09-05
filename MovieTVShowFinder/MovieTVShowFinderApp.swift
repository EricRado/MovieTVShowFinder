//
//  MovieTVShowFinderApp.swift
//  MovieTVShowFinder
//
//  Created by Eric Rado on 8/2/24.
//

import SwiftUI

@main
struct MovieTVShowFinderApp: App {
    var body: some Scene {
        WindowGroup {
            let network = Network()
            let genreService = GenreService(network: network)
            HomeView(viewModel: HomeViewModel(networking: network, genreService: genreService))
        }
    }
}
