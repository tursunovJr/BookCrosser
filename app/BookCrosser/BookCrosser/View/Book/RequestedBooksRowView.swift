//
//  RequestedBooksRowView.swift
//  BookCrosser
//
//  Created by ztursunov on 01.06.2023.
//

import Combine
import SwiftUI

struct RequestedBooksRowView: View {
    var id: UUID
    var name: String
    @State
    var bookModels: [BookInfoModel] = []
    @EnvironmentObject
    private var bookService: BookService
    @State
    var error: APIServiceError?
    @State
    var cancellables = Set<AnyCancellable>()
    
    @State
    private var shouldReloadBooks = false
    
    var body: some View {
        VStack {
            List {
                ForEach(self.bookModels, id: \.uuid) { book in
                    HStack {
                        VStack {
                            HStack {
                                Image(book.image)
                                    .resizable()
                                    .frame(width: 78.0, height: 97.0)
                                VStack(alignment: .leading, spacing: 5.0) {
                                    Text(book.name).font(.caption)
                                    Text(book.author).font(.caption)
                                    HStack {
                                        Image(systemName: "location.circle")
                                            .foregroundColor(.orange)
                                        Text(book.city).font(.caption)
                                    }
                                    HStack(spacing: 4) {
                                        Image(systemName: "person.circle.fill")
                                            .foregroundColor(.blue)
                                        Text("Савелий").font(.caption)
                                    }
                                }
                                Spacer()
                            }
                        }
                        VStack {
                            Button(action: {
                                print("[SERIK]")
                            }) {
                                Text("In progress")
                                    .padding(10.0)
                                    .font(.caption)
                            }
                            .foregroundColor(.green)
                            .background(Color.white)
                            .border(.green)
                            .cornerRadius(5.0)
                            .buttonStyle(PlainButtonStyle())
                            
                            Button(action: {
                                self.bookService.updateBook(state: 0, bookUUID: book.uuid)
                                self.shouldReloadBooks.toggle()
                            }) {
                                Text("Put back")
                                    .padding(10.0)
                                    .font(.caption)
                            }
                            .foregroundColor(.red)
                            .background(Color.white)
                            .border(.red)
                            .cornerRadius(5.0)
                            .buttonStyle(PlainButtonStyle())
                        }
                    }.listRowSeparator(.visible)
                }
            }
        }
        .onAppear {
            self.loadBooks()
        }
        .onChange(of: self.shouldReloadBooks) { _ in
            self.loadBooks()
        }
    }
    
    private func loadBooks() {
        self.bookService.getBooks(state: 1)
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

struct RequestedBooksRowView_Previews: PreviewProvider {
    static var previews: some View {
        RequestedBooksRowView(id: UUID(), name: "Запросы")
    }
}
