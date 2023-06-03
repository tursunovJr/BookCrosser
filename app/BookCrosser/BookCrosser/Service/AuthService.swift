//
//  AuthViewModel.swift
//  BookCrosser
//
//  Created by ztursunov on 08.04.2023.
//

import Combine
import FirebaseAuth
import SwiftUI

protocol AuthServiceProtocol {
    func listenToAuthState()
    func signUp(emailAddress: String, password: String)
    func signIn(emailAddress: String, password: String)
    func signOut()
    func addUserInfo(model: UserInfoModel)
    func getUser() -> AnyPublisher<UserInfoModel, APIServiceError>
}


final class AuthService: APIService, AuthServiceProtocol {
    
    /// Info about user from `Firebase Auth`.
    var user: User? {
        didSet {
            objectWillChange.send()
        }
    }
    
    /// Listener about auth state.
    func listenToAuthState() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self else {
                return
            }
            self.user = user
        }
    }
    
    /// Sign up method using `Firebase Auth`.
    func signUp(emailAddress: String, password: String) {
        Auth.auth().createUser(withEmail: emailAddress, password: password) { _, error in
            if let error {
                print("an error occured: \(error.localizedDescription)")
                return
            }
        }
        
    }
    
    /// Sign in method using `Firebase Auth`.
    func signIn(emailAddress: String, password: String) {
        Auth.auth().signIn(withEmail: emailAddress, password: password) { _, error in
            if let error {
                print("an error occured: \(error.localizedDescription)")
                return
            }
        }
    }
    
    /// Sign out method using `Firebase Auth`.
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    /// Add user info in sign up process via my API.
    func addUserInfo(model: UserInfoModel) {
        
        guard let url = self.baseUrl("user") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let params = ["name": model.name,
                      "surname": model.surname,
                      "email": model.email,
                      "city": model.city]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        } catch { }
        
        URLSession.shared.dataTask(with: request) { _, _, _ in }.resume()
    }
    
    /// Get user's info via my API.
    func getUser() -> AnyPublisher<UserInfoModel, APIServiceError> {
        
        guard
            let email = self.user?.email,
            var url = self.baseUrl("user/\(email)") else {
            return Fail(error: APIServiceError.undefined).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw APIServiceError.responseError
                }
                return data
            }
            .decode(type: UserInfoModel.self, decoder: JSONDecoder())
            .mapError { APIServiceError.parseError($0) }
            .eraseToAnyPublisher()
    }
}
