//
//  API.swift
//  StrandsF1SUI
//
//  Created by Christopher Alford on 7/9/23.
//

import Foundation


class API {

    /**
     * fetch and decode all driver data from ergast service
     */
    func fetchDrivers() async throws -> DriverDataRoot? {
        var jsonUrl = URL(string: "")
        do {
            guard let url = URL(string: "https://ergast.com/api/f1/current/drivers.json") else {
                throw APIError.invalidURL
            }
            jsonUrl = url
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw APIError.invalidResponse
            }
            try await Cache.update(url: url, data: data)
            return try await decode(data: data)

        } catch {
            guard let data = try Cache.read(url: jsonUrl!) else {
                throw APIError.cacheEmpty
            }
            return try await decode(data: data)
        }
    }

    /**
     * fetch and decode specific driver  and result data from ergast service
     */
    func fetchDriverDetail(forDriverId id: String) async throws -> RaceDataRoot? {
        var jsonUrl = URL(string: "")
        do {
            guard let url = URL(string: "https://ergast.com/api/f1/current/drivers/\(id)/results.json") else {
                throw APIError.invalidURL
            }
            jsonUrl = url
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw APIError.invalidResponse
            }
            try await Cache.update(url: url, data: data)
            return try await decode(data: data)

        } catch {
            guard let data = try Cache.read(url: jsonUrl!) else {
                throw APIError.cacheEmpty
            }
            return try await decode(data: data)
        }
    }

    private func decode<T: Decodable>(data: Data) async throws -> T {
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decoderError
        }
    }
}
