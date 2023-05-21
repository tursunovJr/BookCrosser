//
//  HomeView.swift
//  BookCrosser
//
//  Created by ztursunov on 04.03.2023.
//

import SwiftUI
import Combine

struct HomeView: View {
    @EnvironmentObject
    var bookService: BookService
    @State
    var bookInfoModels: [BookInfoModel] = []
    @State
    var isLoading = false
    @State
    var error: APIServiceError?
    @State
    var cancellables = Set<AnyCancellable>()
    
    @State var searchText = ""
    
    var body: some View {
        VStack {
            HStack {
                TextField("Поисе книг, авторов", text: $searchText, onCommit: { } )
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .foregroundColor(.black)
                Button(action: { }) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white)
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal)
            .background(.blue)
            
            ScrollView(showsIndicators: false) {
                ForEach(bookInfoModels, id: \.uuid) { model in
                    BookListRowView(model: model).padding(.vertical)
                }
            }
        }
        
        .onAppear {
            self.isLoading = true
            self.bookService.getAllBooks()
                .sink { completion in
                    self.isLoading = false
                    switch completion {
                    case let .failure(error):
                        print("[Serik oshibka]")
                        self.error = error
                    case .finished:
                        break
                    }
                } receiveValue: { bookInfoModels in
                    print("[SERIK] \(bookInfoModels)")
                    self.bookInfoModels = bookInfoModels
                }
                .store(in: &self.cancellables)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let bookMock: BookInfoModel = BookInfoModel.mock()
        HomeView(bookInfoModels: [bookMock])
    }
}
