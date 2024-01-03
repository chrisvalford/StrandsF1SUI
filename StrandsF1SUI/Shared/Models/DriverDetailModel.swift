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
@MainActor
class DriverDetailModel: ObservableObject {
    @Published var races: [Races] = []
    @Published var plotMarks: [PlotMark] = []
//    @Published var driver: Driver?
//    @Published var raceResults: [RaceResult] = [] {
//        didSet {
//            print("Model didSet: \(raceResults.count) results")
//        }
//    }
    @Published var constructor: Constructor?

    private let api = API()
    private var context: NSManagedObjectContext = {
        PersistenceController.shared.container.viewContext
    }()

    init() {}

    func fetch(id: String) async -> [RaceResult]? {
        do {
            guard let root: RaceDataRoot = try await api.fetchDriverDetail(forDriverId: id),
                  let races = root.mrData?.raceTable?.races
            else {
                throw APIError.noData
            }
            var items: [RaceResult] = []
            self.races = races
            for race in races {
                for result in race.results! {
                    let raceResult = RaceResult(raceDate: race.date,
                                                driverId: (result.driver?.driverId)!,
                                                position: result.position ?? "0",
                                                points: result.points ?? "0")
                    self.constructor = result.constructor
                    items.append(raceResult)
                }
            }
            return items
        } catch {
            print(error)
            return nil
        }
    }

    func createMarks(raceResults: [RaceResult]) {
        print("Creating marks")
        var i = 0
        for result in raceResults {
            // The sum up to this result
            let sum: Double = {
                var total: Double = 0
                for _ in 0..<i {
                    total += Double(raceResults[i].position) ?? 0
                }
                return total
            }()

            var plotMark = PlotMark(id: UUID() ,date: result.raceDate,
                                    position: Double(result.position) ?? 25)
            i += 1
            plotMark.average = sum / Double(i)
            self.plotMarks.append(plotMark)
            print("Have \(self.plotMarks.count) plotMarks")
        }
    }
}
