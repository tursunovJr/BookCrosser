//
//  UserResponse.swift
//  BookCrosser
//
//  Created by ztursunov on 16.04.2023.
//

import Foundation

struct UserInfoModel: Decodable {
//    let id: Int
    let name: String
    let surname: String
    let email: String
    let city: String
    
    enum CodingKeys: String, CodingKey {
//        case id
        case name
        case surname
        case email
        case city
    }
}
