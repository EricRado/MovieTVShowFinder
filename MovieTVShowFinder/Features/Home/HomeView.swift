//
//  HomeView.swift
//  MovieTVShowFinder
//
//  Created by Eric Rado on 8/27/24.
//

import SwiftUI
import Kingfisher

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 16) {
                HeroCarouselView(movies: viewModel.heroDatasource)
                
                CardCarousel(movies: viewModel.cardCarouselDatasource)
                    .padding(.horizontal, 16)
                
                ForEach(viewModel.carouselViewModels) { carouselViewModel in
                    CategoryCarousel(viewModel: carouselViewModel)
                        .padding(.horizontal,  16)
                }
                
            }
        }
        .background(Colors.backgroundColor)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .task {
            await viewModel.load()
        }
    }
}

struct HeroCarouselView: View {
    let movies: [MovieDTO]
    
    var body: some View {
        VStack(alignment: .leading) {
            TabView {
                ForEach(movies) { movie in
                    ZStack(alignment: .bottom) {
                        KFImage(URL(string: movie.backdropImageUrlString))
                            .placeholder {
                                Rectangle()
                                    .foregroundStyle(.gray)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                            .resizable()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(movie.title)
                                .foregroundStyle(.white)
                                .bold()
                            
                            Text(movie.details)
                                .foregroundStyle(.gray)
                                .font(Font.caption)
                                .lineLimit(3)
                            
                            // TODO: - Remove hard code genre
                            Text("Suspense")
                                .foregroundStyle(.white)
                                .font(Font.footnote)
                                .padding(8)
                                .background(.gray)
                                .clipShape(Capsule())
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 8)
                        .padding(.bottom, 24)
                    }
                }
            }
            .tabViewStyle(.page)
        }
        .frame(height: 350)
        
    }
}

struct CategoryCarousel: View {
    let viewModel: CarouselViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.title)
                .foregroundStyle(.white)
            
            ScrollView(.horizontal) {
                HStack(alignment: .center, spacing: 8) {
                    ForEach(viewModel.movies) { movie in
                        VStack(alignment: .leading, spacing: 4) {
                            KFImage(URL(string: movie.posterImageUrlString))
                                .placeholder {
                                    Rectangle()
                                        .fill(.gray)
                                        .frame(width: 120, height: 150)
                                }
                                .resizable()
                                .frame(width: 120, height: 150)
                                
                            Text(movie.title)
                                .foregroundStyle(.white)
                                .lineLimit(1)
                                .frame(width: 120)
                        }
                    }
                }
            }
        }
    }
}

struct CardCarousel: View {
    let movies: [MovieDTO]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // TODO: - Remove hard code title
            Text("Trending Today")
                .foregroundStyle(.white)
            
            ScrollView(.horizontal) {
                HStack(alignment: .center, spacing: 4) {
                    ForEach(movies) { movie in
                        ZStack(alignment: .topLeading) {
                            KFImage(URL(string: movie.backdropImageUrlString))
                                .placeholder {
                                    Rectangle()
                                        .foregroundStyle(.gray)
                                        .frame(width: 300, height: 175)
                                }
                                .resizable()
                                .frame(width: 300, height: 175)
                            
                            VStack(alignment:.leading) {
                                Text(String(movie.rating) + " | " + movie.releaseDate)
                                    .foregroundStyle(.white)
                                
                                Text(movie.title)
                                    .foregroundStyle(.white)
                                    .frame(maxHeight: .infinity, alignment: .bottom)
                                    .padding(.bottom, 16)
                            }
                            .frame(height: 175)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    let network = Network()
    return HomeView(viewModel: HomeViewModel(networking: network, genreService: GenreService(network: network)))
}
