//
//  HomeView.swift
//  BookCrosser
//
//  Created by ztursunov on 04.03.2023.
//

import Combine
import SwiftUI

struct HomeView: View {
    @EnvironmentObject
    var bookService: BookService
    @State
    var recommendationBooks: [BookInfoModel] = []
    @State
    var newBooks: [BookInfoModel] = []
    @State
    var popularBooks: [BookInfoModel] = []
    @State
    var error: APIServiceError?
    @State
    var cancellables = Set<AnyCancellable>()
    
    var body: some View {
        NavigationView {
            VStack {
                NavBar()
                
                /// Промо-блок.
                List {
                    ImageSlider()
                        .frame(height: 200.0)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                }
                .background(.white)
                .scrollContentBackground(.hidden)
                .listStyle(.plain)
                .frame(height: 250.0)
                .padding(.top, -8.0)
                
                ScrollView {
                    HStack(alignment: .top) {
                        Text("Рекомендации")
                            .font(.title3).foregroundColor(.orange)
                            .padding(.leading, 12.0)
                        Spacer()
                    }
                    .frame(height: 20.0)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 5.0) {
                            ForEach(self.recommendationBooks, id: \.uuid) { model in
                                BookListRowView(model: model)
                            }
                        }
                    }
                    .padding(.top, -10.0)
                    
                    HStack(alignment: .top) {
                        Text("Новинки")
                            .font(.title3).foregroundColor(.orange)
                            .padding(.leading, 12.0)
                        Spacer()
                    }
                    .padding(.top, -10.0)
                    .frame(height: 20.0)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 5.0) {
                            ForEach(self.newBooks, id: \.uuid) { model in
                                BookListRowView(model: model)
                            }
                        }
                    }
                    .padding(.top, -10.0)
                    
                    HStack(alignment: .top) {
                        Text("Популярные книги")
                            .font(.title3).foregroundColor(.orange)
                            .padding(.leading, 12.0)
                        Spacer()
                    }
                    .padding(.top, -10.0)
                    .frame(height: 20.0)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 5.0) {
                            ForEach(self.popularBooks, id: \.uuid) { model in
                                BookListRowView(model: model)
                            }
                        }
                    }
                    .padding(.top, -10.0)
                }
                .padding(.top, -35.0)
            }
            
            .onAppear {
                self.bookService.getAllBooks()
                    .sink { completion in
                        switch completion {
                        case let .failure(error):
                            self.error = error
                        case .finished:
                            break
                        }
                    } receiveValue: { bookInfoModels in
                        self.recommendationBooks = bookInfoModels
                    }
                    .store(in: &self.cancellables)
                self.bookService.getAllBooks()
                    .sink { completion in
                        switch completion {
                        case let .failure(error):
                            self.error = error
                        case .finished:
                            break
                        }
                    } receiveValue: { bookInfoModels in
                        self.newBooks = bookInfoModels
                    }
                    .store(in: &self.cancellables)
                self.bookService.getAllBooks()
                    .sink { completion in
                        switch completion {
                        case let .failure(error):
                            self.error = error
                        case .finished:
                            break
                        }
                    } receiveValue: { bookInfoModels in
                        self.popularBooks = bookInfoModels
                    }
                    .store(in: &self.cancellables)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let bookMock = BookInfoModel.mock()
        HomeView()
    }
}
