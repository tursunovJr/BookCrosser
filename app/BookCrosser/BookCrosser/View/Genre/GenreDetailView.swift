//
//  GenreDetailView.swift
//  BookCrosser
//
//  Created by ztursunov on 28.05.2023.
//

import SwiftUI
import Combine

struct GenreDetailView: View {
    let model: GenreInfoModel
    @State
    var bookModels: [BookInfoModel] = []
    @EnvironmentObject
    private var bookService: BookService
    @State
    var error: APIServiceError?
    @State
    var cancellables = Set<AnyCancellable>()
    
    var body: some View {
        VStack {
            List {
                ForEach(self.bookModels, id: \.uuid) { book in
                    HStack {
                        Image(book.image)
                            .resizable()
                            .frame(width: 78.0, height: 97.0)
                        VStack(alignment: .leading, spacing: 5.0) {
                            Text(book.name)
                            Text(book.author)
                            HStack {
                                Image(systemName: "location.circle")
                                    .foregroundColor(.orange)
                                Text(book.city)
                            }
                            HStack(spacing: 4) {
                                ForEach(0 ..< 5) { index in
                                    Image(systemName: index < Int(book.rating) ? "star.fill" : "star")
                                        .foregroundColor(.yellow)
                                        .font(.system(size: 15))
                                }
                                Text(String(book.rating))
                                    .foregroundColor(.black)
                                    .font(.custom("Custom", size: 15.0))
                                    .padding(.leading, 10.0)
                            }
                        }
                        Spacer()
                    }
                }
            }
        }
        .onAppear {
            self.bookService.gerBooks(genreUUID: self.model.uuid)
                .sink { completion in
                    switch completion {
                    case let .failure(error):
                        self.error = error
                    case .finished:
                        break
                    }
                } receiveValue: { model in
                    self.bookModels = model
                }
                .store(in: &self.cancellables)
        }
    }
}

struct GenreDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let genreMock = GenreInfoModel.mock()
        GenreDetailView(model: genreMock)
    }
}
