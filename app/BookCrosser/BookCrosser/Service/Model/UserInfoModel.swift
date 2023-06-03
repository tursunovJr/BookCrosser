//
//  UserResponse.swift
//  BookCrosser
//
//  Created by ztursunov on 16.04.2023.
//

import Foundation

struct UserInfoModel: Decodable {
    let name: String
    let surname: String
    let email: String
    let city: String
}
