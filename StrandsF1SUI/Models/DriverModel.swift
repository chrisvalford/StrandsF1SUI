//
//  DriverModel.swift
//  StrandsF1
//
//  Created by Christopher Alford on 1/8/23.
//

import SwiftUI

/**
 * Model for the `DriverList` view
 */
class DriverModel: ObservableObject {

    @Published var drivers: [Driver] = []
    @Published var seriesTitle: String = ""
    @Published var selectedSort = SortByField.none
    @Published var searchText = ""

    init() {
        Task {
            await fetch()
        }
    }

    /**
     * fetch and decode all driver data from ergast service
     */
    private func fetch() async {
        do {
            guard let url = URL(string: "https://ergast.com/api/f1/current/drivers.json") else {
                return
            }
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Invalid Response")
                return
            }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            let results = try decoder.decode(DriverDataRoot.self, from: data)
            DispatchQueue.main.async {
                self.drivers = results.mrData?.driverTable?.drivers ?? []
                self.seriesTitle = "\(results.mrData?.series ?? "") - \(results.mrData?.driverTable?.season ?? "") Season"
            }
        } catch {
            print(error)
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
