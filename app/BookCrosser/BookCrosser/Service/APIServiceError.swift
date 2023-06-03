//
//  APIServiceError.swift
//  BookCrosser
//
//  Created by ztursunov on 16.04.2023.
//

import Foundation

enum APIServiceError: Error {
    case responseError
    case parseError(Error)
    case undefined
    
}
