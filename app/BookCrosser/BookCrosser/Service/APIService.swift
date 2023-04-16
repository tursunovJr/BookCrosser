//
//  APIService.swift
//  BookCrosser
//
//  Created by ztursunov on 16.04.2023.
//

import Combine
import Foundation

protocol UserInfoAPIServiceDescription {
    func addUserInfo(model: UserInfoModel)
//    func getUser(with email: String) -> AnyPublisher<UserInfoModel, APIServiceError>
}

final class APIService: ObservableObject {
    
    private func baseUrl(_ suffixURL: String) -> URL? {
        
        guard let baseURL = URLComponents(string: "http://0.0.0.0:8080/api/v1/\(suffixURL)") else {
            return nil
        }
        
        return baseURL.url
    }
    
}

// MARK: - UserInfoAPIServiceDescription

extension APIService: UserInfoAPIServiceDescription {
    func addUserInfo(model: UserInfoModel) {
        
        guard let url = self.baseUrl("user") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let params = ["name": model.name,
                      "surname": model.surname,
                      "email": model.email,
                      "city": model.city]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        } catch {
            }
        
        URLSession.shared.dataTask(with: request) { _, _, _ in }.resume()
    }
    
//    func getUser(with email: String) -> AnyPublisher<UserInfoModel, APIServiceError> { }

}
