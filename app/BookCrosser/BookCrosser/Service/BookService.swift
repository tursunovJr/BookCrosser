//
//  BookService.swift
//  BookCrosser
//
//  Created by ztursunov on 14.05.2023.
//

import Combine
import SwiftUI

protocol BookServiceProtocol {
    func getAllBooks() -> AnyPublisher<[BookInfoModel], APIServiceError>
    func addFavBook(email: String, book_uuid: String)
    func delFavBook(email: String, book_uuid: String)
    func getAllFavBooks(email: String) -> AnyPublisher<[FavBookInfoModel], APIServiceError>
    func getBook(uuid: String) -> AnyPublisher<BookInfoModel, APIServiceError>
    func gerBooks(genreUUID: String) -> AnyPublisher<[BookInfoModel], APIServiceError>
    func updateBook(state: Int, bookUUID: String)
}

final class BookService: APIService, BookServiceProtocol {
    
    struct BooksResponse: Decodable {
        let books: [BookInfoModel]
    }
    
    struct FavBooksResponse: Decodable {
        let favBooks: [FavBookInfoModel]
    }
    
    func getAllBooks() -> AnyPublisher<[BookInfoModel], APIServiceError> {
        guard let url = self.baseUrl("book") else {
            return Fail(error: APIServiceError.undefined).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .mapError { error in
                APIServiceError.parseError(error)
            }
            .flatMap { data, response -> AnyPublisher<[BookInfoModel], APIServiceError> in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    return Fail(error: APIServiceError.responseError).eraseToAnyPublisher()
                }
                
                let decoder = JSONDecoder()
                
                return Just(data)
                    .decode(type: BooksResponse.self, decoder: decoder)
                    .mapError { error in
                        APIServiceError.parseError(error)
                    }
                    .map { $0.books }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func addFavBook(email: String, book_uuid: String) {
        
        guard let url = self.baseUrl("addFav") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let params = ["email": email,
                      "uuid": book_uuid]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        } catch { }
        
        URLSession.shared.dataTask(with: request) { _, _, _ in }.resume()
    }
    
    func delFavBook(email: String, book_uuid: String) {
        guard let url = self.baseUrl("favBook/\(email)/\(book_uuid)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { _, _, _ in }.resume()
    }
    
    func getAllFavBooks(email: String) -> AnyPublisher<[FavBookInfoModel], APIServiceError> {
        guard let url = self.baseUrl("favBook/\(email)") else {
            return Fail(error: APIServiceError.undefined).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .mapError { error in
                APIServiceError.parseError(error)
            }
            .flatMap { data, response -> AnyPublisher<[FavBookInfoModel], APIServiceError> in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    return Fail(error: APIServiceError.responseError).eraseToAnyPublisher()
                }
                
                let decoder = JSONDecoder()
                
                return Just(data)
                    .decode(type: FavBooksResponse.self, decoder: decoder)
                    .mapError { error in
                        APIServiceError.parseError(error)
                    }
                    .map { $0.favBooks }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func getBook(uuid: String) -> AnyPublisher<BookInfoModel, APIServiceError> {
        guard let url = self.baseUrl("book/\(uuid)") else {
            return Fail(error: APIServiceError.undefined).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .mapError { error in
                APIServiceError.parseError(error)
            }
            .flatMap { data, response -> AnyPublisher<BookInfoModel, APIServiceError> in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    return Fail(error: APIServiceError.responseError).eraseToAnyPublisher()
                }
                
                let decoder = JSONDecoder()
                
                return Just(data)
                    .decode(type: BookInfoModel.self, decoder: decoder)
                    .mapError { error in
                        APIServiceError.parseError(error)
                    }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func gerBooks(genreUUID: String) -> AnyPublisher<[BookInfoModel], APIServiceError> {
        guard let url = self.baseUrl("book/genre/\(genreUUID)") else {
            return Fail(error: APIServiceError.undefined).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .mapError { error in
                APIServiceError.parseError(error)
            }
            .flatMap { data, response -> AnyPublisher<[BookInfoModel], APIServiceError> in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    return Fail(error: APIServiceError.responseError).eraseToAnyPublisher()
                }
                
                let decoder = JSONDecoder()
                
                return Just(data)
                    .decode(type: BooksResponse.self, decoder: decoder)
                    .mapError { error in
                        APIServiceError.parseError(error)
                    }
                    .map { $0.books }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func updateBook(state: Int, bookUUID: String) {
        guard let url = self.baseUrl("book/\(bookUUID)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let params = ["state": state]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        } catch { }
        
        URLSession.shared.dataTask(with: request) { _, _, _ in }.resume()
    }
}
