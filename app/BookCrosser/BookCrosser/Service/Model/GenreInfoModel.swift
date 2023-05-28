//
//  GenreInfoModel.swift
//  BookCrosser
//
//  Created by ztursunov on 28.05.2023.
//

import Foundation

struct GenreInfoModel: Decodable, Hashable {
    let name: String
    let uuid: String
}

extension GenreInfoModel {

    static func mock() -> GenreInfoModel {
        .init(name: "С++ для чайников",
              uuid: String(UUID().hashValue))
    }
}
