//
//  API.swift
//  StrandsF1
//
//  Created by Christopher Alford on 1/8/23.
//

import SwiftUI

class DriverModel: ObservableObject {

    @Published var drivers: [Driver] = []
    @Published var seriesTitle: String = ""
    @Published var selectedSort = SortByField.none

    init() {
        read()
//        Task {
//            await fetch()
//        }
    }

    func read() {
        if let fileLocation = Bundle.main.url(forResource: "drivers", withExtension: "json"){
            do {
                let data = try Data(contentsOf: fileLocation)
                let jsonDecoder = JSONDecoder()
                let results = try jsonDecoder.decode(DriverListRoot.self, from: data)
                drivers = results.MRData.DriverTable.Drivers
                seriesTitle = "\(results.MRData.series) - \(results.MRData.DriverTable.season) Season"
            } catch {
                print(error)
            }
        }
    }

    func fetch() async {
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
            let jsonDecoder = JSONDecoder()
            let results = try jsonDecoder.decode(DriverListRoot.self, from: data)
            drivers = results.MRData.DriverTable.Drivers
            seriesTitle = "\(results.MRData.series) - \(results.MRData.DriverTable.season) Season"
        } catch {
            print(error)
        }
    }

    var sortedDrivers: [Driver] {
            get {
                switch selectedSort {
                case .none:
                    return drivers
                case .name:
                    return drivers.sorted(by: { $0.fullName < $1.fullName })
                case .permanentNumber:
                    return drivers.sorted(by: { Int($0.permanentNumber) ?? 0 < Int($1.permanentNumber) ?? 0 })
                case .age:
                    return drivers.sorted(by: { $0.age < $1.age })
                case .nationality:
                    return drivers.sorted(by: { $0.nationality < $1.nationality })
                }
            }
            set {
                drivers = newValue
            }
        }

    func driverList() -> [DriverListItem] {
        var items: [DriverListItem] = []
        for driver in drivers {
            items.append(DriverListItem(id: driver.driverId,
                                        fullname: "\(driver.givenName) \(driver.familyName)",
                                        permanentNumber: driver.permanentNumber))
        }
        return items
    }

    func driver(id: String) -> Driver? {
        return drivers.first(where: { $0.driverId == id })
    }

    func driverDetail(id: String) -> DriverDetailItem? {
        guard let driver = drivers.first(where: { $0.driverId == id }) else {
            return nil
        }
        return DriverDetailItem(id: driver.driverId,
                                fullname: "\(driver.givenName) \(driver.familyName)",
                                permanentNumber: driver.permanentNumber,
                                age: "\(ageInYears(from: driver.dateOfBirth))",
                                nationality: driver.nationality)
    }

    func sortBy(field: SortByField) {
        switch field {
        case .none:
            read()
    //        Task {
    //            await fetch()
    //        }
        case .name:
            drivers.sort(by: { $0.fullName < $1.fullName })
        case .permanentNumber:
            drivers.sort(by: { Int($0.permanentNumber) ?? 0 < Int($1.permanentNumber) ?? 0 })
        case .age:
            drivers.sort(by: { $0.age < $1.age })
        case .nationality:
            drivers.sort(by: { $0.nationality < $1.nationality })
        }
    }
}


struct DriverListItem: Identifiable {
    let id: String
    let fullname: String
    let permanentNumber: String
}

struct DriverDetailItem: Identifiable {
    let id: String
    let fullname: String
    let permanentNumber: String
    let age: String
    let nationality: String
}
