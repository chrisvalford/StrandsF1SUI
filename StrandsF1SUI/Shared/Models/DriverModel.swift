//
//  DriverModel.swift
//  StrandsF1
//
//  Created by Christopher Alford on 1/8/23.
//

import SwiftUI
import CoreData

/**
 * Model for the `DriverList` view
 */
class DriverModel: ObservableObject {

    @Published var seriesTitle: String = ""
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
    private let api = API()
    private var context: NSManagedObjectContext = {
        PersistenceController.shared.container.viewContext
    }()


    func fetch() {
        Task {
            do {
                guard let root: DriverDataRoot = try await api.fetchDrivers(),
                      let drivers = root.mrData?.driverTable?.drivers
                else {
                    throw APIError.noData
                }
                DispatchQueue.main.async {
                    self.drivers = drivers
                    self.rawDrivers = drivers
                }
            } catch {
                print(error)
            }
        }
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

}
