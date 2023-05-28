//
//  GenreService.swift
//  BookCrosser
//
//  Created by ztursunov on 28.05.2023.
//

import Combine
import SwiftUI

protocol GenreServiceProtocol {
    func getAllGenres() -> AnyPublisher<[GenreInfoModel], APIServiceError>
}

final class GenreService: APIService, GenreServiceProtocol {
    
    struct GenreResponse: Decodable {
        let genres: [GenreInfoModel]
    }
    
    func getAllGenres() -> AnyPublisher<[GenreInfoModel], APIServiceError> {
        guard let url = self.baseUrl("genre") else {
            return Fail(error: APIServiceError.undefined).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .mapError { error in
                APIServiceError.parseError(error)
            }
            .flatMap { data, response -> AnyPublisher<[GenreInfoModel], APIServiceError> in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    return Fail(error: APIServiceError.responseError).eraseToAnyPublisher()
                }
                
                let decoder = JSONDecoder()
                
                return Just(data)
                    .decode(type: GenreResponse.self, decoder: decoder)
                    .mapError { error in
                        APIServiceError.parseError(error)
                    }
                    .map { $0.genres }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
}
