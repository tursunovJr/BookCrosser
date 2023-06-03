//
//  FavouriteDetailView.swift
//  BookCrosser
//
//  Created by ztursunov on 29.05.2023.
//

import SwiftUI
import Combine

struct FavouriteDetailView: View {
    let uuid: String
    @EnvironmentObject
    private var bookService: BookService
    @State
    var model: BookInfoModel = .mock()
    @State
    var error: APIServiceError?
    @State
    var cancellables = Set<AnyCancellable>()
    
    var body: some View {
        HStack {
            Image(self.model.image)
                .resizable()
                .frame(width: 78.0, height: 97.0)
            VStack(alignment: .leading, spacing: 5.0) {
                Text(self.model.name)
                Text(self.model.author)
                HStack {
                    Image(systemName: "location.circle")
                        .foregroundColor(.orange)
                    Text(self.model.city)
                }
                self.stars
            }
            Spacer()
        }
        .onAppear {
            self.bookService.getBook(uuid: self.uuid)
                .sink { completion in
                    switch completion {
                    case let .failure(error):
                        self.error = error
                    case .finished:
                        break
                    }
                } receiveValue: { model in
                    self.model = model
                }
                .store(in: &self.cancellables)
        }
    }
    
    var stars: some View {
        HStack(spacing: 4) {
            ForEach(0 ..< 5) { index in
                Image(systemName: index < Int(self.model.rating) ? "star.fill" : "star")
                    .foregroundColor(.yellow)
                    .font(.system(size: 15))
            }
            Text(String(self.model.rating))
                .foregroundColor(.black)
                .font(.custom("Custom", size: 15.0))
                .padding(.leading, 10.0)
        }
    }
}

struct FavouriteDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FavouriteDetailView(uuid: "2fa557a-c182-408f-a106-02561e6eac21",
                            model: BookInfoModel.mock())
    }
}
