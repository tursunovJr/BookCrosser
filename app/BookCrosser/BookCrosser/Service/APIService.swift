//
//  APIService.swift
//  BookCrosser
//
//  Created by ztursunov on 16.04.2023.
//

import Combine
import Foundation


class APIService: ObservableObject {
    func baseUrl(_ suffixURL: String) -> URL? {
        
        guard let baseURL = URLComponents(string: "http://0.0.0.0:8080/api/v1/\(suffixURL)") else {
            return nil
        }
        
        return baseURL.url
    }
}
