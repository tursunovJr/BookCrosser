//
//  GenreView.swift
//  BookCrosser
//
//  Created by ztursunov on 08.04.2023.
//

import Combine
import SwiftUI

struct GenreView: View {
    @EnvironmentObject
    var genreService: GenreService
    @State
    var genreInfoModels: [GenreInfoModel] = []
    @State
    var error: APIServiceError?
    @State
    var cancellables = Set<AnyCancellable>()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0.0) {
                NavBar()
                List {
                    ForEach(self.genreInfoModels, id: \.uuid) { genre in
                        NavigationLink(destination: GenreDetailView(model: genre)) {
                            HStack {
                                Text(genre.name)
                                Spacer()
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .onAppear {
                self.genreService.getAllGenres()
                    .sink { completion in
                        switch completion {
                        case let .failure(error):
                            self.error = error
                        case .finished:
                            break
                        }
                    } receiveValue: { genreInfoModels in
                        self.genreInfoModels = genreInfoModels
                    }
                    .store(in: &self.cancellables)
            }
        }
    }
}

struct GenreView_Previews: PreviewProvider {
    static var previews: some View {
        GenreView()
    }
}
