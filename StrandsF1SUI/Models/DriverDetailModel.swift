//
//  DriverDetailModel.swift
//  StrandsF1SUI
//
//  Created by Christopher Alford on 5/8/23.
//

import Foundation

struct RaceResult: Identifiable {
    let raceDate: Date
    let driverId: String
    let position: String
    let points: String

    var id: String {
        return "\(raceDate.description)\(driverId)"
    }
}

/**
 * Model for the `DriverDetailView`
 *
 * Becides the drivers details, race results are created.
 */
class DriverDetailModel: ObservableObject {

    @Published var races: [Races] = []
    @Published var driver: Driver
    @Published var raceResults: [RaceResult] = []
    @Published var constructor: Constructor?

    init(driver: Driver) {
        self.driver = driver
        Task {
            races = await fetch(forDriverId: driver.driverId ?? "")
            for race in self.races {
                for result in race.results! {
                    let raceResult = RaceResult(raceDate: race.date,
                                                driverId: (result.driver?.driverId)!,
                                                position: result.position ?? "0",
                                                points: result.points ?? "0")
                    constructor = result.constructor
                    raceResults.append(raceResult)
                }
            }
        }
    }

    /**
     * fetch and decode specific driver  and result data from ergast service
     */
    private func fetch(forDriverId id: String) async -> [Races] {
        do {
            guard let url = URL(string: "https://ergast.com/api/f1/current/drivers/\(id)/results.json") else {
                return []
            }
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Invalid Response")
                return []
            }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            let results = try decoder.decode(RaceDataRoot.self, from: data)
            return results.mrData?.raceTable?.races ?? []
        } catch {
            print(error)
            return []
        }
    }
}
