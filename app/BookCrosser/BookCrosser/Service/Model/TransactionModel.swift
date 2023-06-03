//
//  TransactionModel.swift
//  BookCrosser
//
//  Created by ztursunov on 03.06.2023.
//

import Foundation

struct TransactionModel: Decodable {
    let sender: String
    let receiver: String
    let bookUUID: String
}

struct ChainModel: Decodable, Hashable {
    let bookID: String
    let timestamp: String?
    let transactions: String?
}
