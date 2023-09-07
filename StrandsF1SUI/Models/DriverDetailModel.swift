//
//  DriverDetailModel.swift
//  StrandsF1SUI
//
//  Created by Christopher Alford on 5/8/23.
//

import Foundation
import CoreData

/**
 * Model for the `DriverDetailView`
 *
 * Becides the drivers details, race results are created.
 */
class DriverDetailModel: ObservableObject {
    @Published var races: [Races] = []
//    @Published var driver: Driver?
    @Published var raceResults: [RaceResult] = []
    @Published var constructor: Constructor?

    private let api = API()
    private var context: NSManagedObjectContext = {
        PersistenceController.shared.container.viewContext
    }()

    init() {}

    func fetch(id: String) {
//        self.driver = driver
        Task {
            do {
                guard let root: RaceDataRoot = try await api.fetchDriverDetail(forDriverId: id),
                      let races = root.mrData?.raceTable?.races
                else {
                    throw APIError.noData
                }
                DispatchQueue.main.async {
                    self.races = races
                    for race in races {
                        for result in race.results! {
                            let raceResult = RaceResult(raceDate: race.date,
                                                        driverId: (result.driver?.driverId)!,
                                                        position: result.position ?? "0",
                                                        points: result.points ?? "0")
                            self.constructor = result.constructor
                            self.raceResults.append(raceResult)
                        }
                    }
                }
            } catch {
                print(error)
            }
        }
    }
}
