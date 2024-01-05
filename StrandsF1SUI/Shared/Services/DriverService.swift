//
//  API.swift
//  StrandsF1SUI
//
//  Created by Christopher Alford on 7/9/23.
//

import SwiftUI

@MainActor class DriverService: ObservableObject {

    @Published var drivers: [Driver] = []
    
    var selectedSort = SortByField.none {
        didSet {
            drivers = sortDrivers()
        }
    }
    
    var searchText: String = "" {
        didSet {
            drivers = sortDrivers()
        }
    }

    private var rawDrivers: [Driver] = []

    /**
     * fetch and decode all driver data from ergast service or cache
     */
    func getAllDrivers() async throws {
        var jsonUrl = URL(string: "")
        do {
            guard let url = URL(string: "https://ergast.com/api/f1/current/drivers.json") else {
                throw ServiceError.invalidURL
            }
            jsonUrl = url
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw ServiceError.invalidResponse
            }
            try await Cache.update(url: url, data: data)
            let results: DriverDataRoot = try await decode(data: data)
            drivers = results.mrData?.driverTable?.drivers ?? []
            rawDrivers = drivers
        } catch {
            guard let data = try Cache.read(url: jsonUrl!) else {
                throw ServiceError.cacheEmpty
            }
            let results: DriverDataRoot = try await decode(data: data)
            drivers = results.mrData?.driverTable?.drivers ?? []
            rawDrivers = drivers
        }
    }

    // Sample data structure as the API doesn't have a driver image.
    struct ImageName: Decodable {
        let id: String
        let file: String
    }

    func imageURLForDriver(id: String) -> URL? {
        guard let url = Bundle.main.url(forResource: "images", withExtension: "json") else { return nil}
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let images = try decoder.decode([ImageName].self, from: data)
            guard let image = images.first(where: { $0.id == id} ) else { return nil }
            return URL(string: "https://marine.digital/f1/drivers/640/\(image.file)")
        } catch {
            print("error:\(error)")
        }
        return nil
    }

    /**
     * Array of `Driver`s sorted by 'selectedSort`
     *
     * If `searchText` has a value the `drivers` array is filtered first.
     */
    func sortDrivers() -> [Driver] {
        var filteredDrivers: [Driver] = []
        if searchText.isEmpty {
            filteredDrivers = rawDrivers
        } else {
            filteredDrivers = rawDrivers.filter { $0.fullName.localizedCaseInsensitiveContains(searchText) }
        }
        switch selectedSort {
        case .none:
            return filteredDrivers
        case .nameFirstLast:
            return filteredDrivers.sorted(by: { $0.givenName ?? "" < $1.givenName ?? "" })
        case .nameLastFirst:
            return filteredDrivers.sorted(by: { $0.familyName ?? "" < $1.familyName ?? "" })
        case .permanentNumber:
            return filteredDrivers.sorted(by: { Int($0.permanentNumber) ?? 0 < Int($1.permanentNumber) ?? 0 })
        case .age:
            return filteredDrivers.sorted(by: { $0.age < $1.age })
        case .nationality:
            return filteredDrivers.sorted(by: { $0.nationality ?? "" < $1.nationality ?? ""})
        }
    }

    private func createImage(_ value: Data) -> Image {
#if canImport(UIKit)
        let artwork: UIImage = UIImage(data: value) ?? UIImage()
        return Image(uiImage: artwork)
#elseif canImport(AppKit)
        let artwork: NSImage = NSImage(data: value) ?? NSImage()
        return Image(nsImage: artwork)
#else
        return Image(systemImage: "photo")
#endif
    }
}
