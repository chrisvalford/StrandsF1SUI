//
//  ServiceError.swift
//  StrandsF1SUI
//
//  Created by Christopher Alford on 6/9/23.
//

import Foundation

enum ServiceError: Error {
    case invalidURL
    case invalidResponse
    case noData
    case decoderError
    case cacheEmpty
    case cacheError
}

func decode<T: Decodable>(data: Data) async throws -> T {
    do {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return try decoder.decode(T.self, from: data)
    } catch {
        throw ServiceError.decoderError
    }
}
