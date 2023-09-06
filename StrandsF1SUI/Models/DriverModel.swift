//
//  DriverModel.swift
//  StrandsF1
//
//  Created by Christopher Alford on 1/8/23.
//

import SwiftUI
import CoreData

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case noData
    case decoderError
    case cacheEmpty
    case cacheError
}

/**
 * Model for the `DriverList` view
 */
class DriverModel: ObservableObject {

    @Published var drivers: [Driver] = []
    @Published var seriesTitle: String = ""
    @Published var selectedSort = SortByField.none
    @Published var searchText = ""

    fileprivate var context: NSManagedObjectContext = {
        PersistenceController.shared.container.viewContext
    }()

    init() {
        Task {
            do {
                try await fetch()
            } catch {
                print("**** Failed to retrieve Driver data with error \(error)")
            }
        }
    }

    /**
     * fetch and decode all driver data from ergast service
     */
    private func fetch() async throws {
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
            try decode(data: data)
            try updateCache(url: url, data: data)
        } catch {
            guard let data = try readCache(url: jsonUrl!) else {
                throw APIError.cacheEmpty
            }
            try decode(data: data)
        }
    }

    private func decode(data: Data) throws {
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            let results = try decoder.decode(DriverDataRoot.self, from: data)
            DispatchQueue.main.async {
                self.drivers = results.mrData?.driverTable?.drivers ?? []
                self.seriesTitle = "\(results.mrData?.series ?? "") - \(results.mrData?.driverTable?.season ?? "") Season"
            }
        } catch {
            throw APIError.decoderError
        }
    }

    func updateCache(url: URL, data: Data) throws {
        let fetchRequest: NSFetchRequest<CacheItem>
        fetchRequest = CacheItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "url == %@", url as CVarArg)
        do {
            let cacheItems = try context.fetch(fetchRequest)
            if cacheItems.count > 0 {   // Update url, data values if they exist
                let cacheItem = cacheItems.first!
                cacheItem.created = Date()
                cacheItem.data = data
                try context.save()
            } else {                    // Otherwise crate a new entry
                let cacheItem = CacheItem(context: context)
                cacheItem.url = url
                cacheItem.created = Date()
                cacheItem.data = data
                try context.save()
            }
        } catch {
            throw APIError.cacheError
        }
    }

    func readCache(url: URL) throws -> Data? {
        let fetchRequest: NSFetchRequest<CacheItem>
        fetchRequest = CacheItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "url == %@", url as CVarArg)
        do {
            let cacheItems = try context.fetch(fetchRequest)
            if cacheItems.count > 0 {
                guard let first = cacheItems.first else {
                    throw APIError.cacheError
                }
                return first.data
            } else {
                throw APIError.cacheEmpty
            }
        } catch {
            throw APIError.cacheError
        }
    }

    /**
     * Array of `Driver`s sorted by 'selectedSort`
     *
     * If `searchText` has a value the `drivers` array is filtered first.
     */
    var sortedDrivers: [Driver] {
        get {
            var filteredDrivers: [Driver] = []
            if searchText.isEmpty {
                filteredDrivers = drivers
            } else {
                filteredDrivers = drivers.filter { $0.fullName.localizedCaseInsensitiveContains(searchText) }
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
        set {
            drivers = newValue
        }
    }
}

/*
 givenName : String,
 familyName : String,
 */
