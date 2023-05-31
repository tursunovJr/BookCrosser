//
//  BookResponse.swift
//  BookCrosser
//
//  Created by ztursunov on 14.05.2023.
//

import Foundation

struct BookInfoModel: Decodable, Hashable {
    let author: String
    let city: String
    let description: String
    let genre: String
    let holderID: Int
    let name: String
    let uuid: String
    let image: String
    let rating: Float
    let state: Int
}

struct FavBookInfoModel: Decodable, Hashable {
    let book_uuid: String
}

extension BookInfoModel {

    static func mock() -> BookInfoModel {
        
        .init(author: "Шрёдр",
              city: "Москва",
              description: "Основы С++",
              genre: "Техническая",
              holderID: 1,
              name: "С++ для чайников",
              uuid: String(UUID().hashValue),
              image: "book",
              rating: 4.7,
              state: 0)
    }
}

