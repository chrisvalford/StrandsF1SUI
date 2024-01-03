//
//  APIError.swift
//  StrandsF1SUI
//
//  Created by Christopher Alford on 6/9/23.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case noData
    case decoderError
    case cacheEmpty
    case cacheError
}
