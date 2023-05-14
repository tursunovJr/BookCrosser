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
}

final class BookService: APIService, BookServiceProtocol {
    
    struct BooksResponse: Decodable {
            let books: [BookInfoModel]
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
    
}
