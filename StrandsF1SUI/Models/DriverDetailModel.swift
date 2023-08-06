//
//  DriverDetailModel.swift
//  StrandsF1SUI
//
//  Created by Christopher Alford on 5/8/23.
//

import Foundation

struct RaceResult: Identifiable {
    let raceDate: String
    let driverId: String
    let position: Int
    let points: Int

    var id: String {
        return "\(raceDate)\(driverId)"
    }
}

class DriverDetailModel: ObservableObject {

    @Published var races: [Races] = []
    @Published var driver: Driver
    @Published var raceResults: [RaceResult] = []
    @Published var constructor: Constructor?

    init(driver: Driver) {
        self.driver = driver
        Task {
            races = await fetch(forDriverId: driver.driverId ?? "")
            for race in races {
                for result in race.results! {
                    let raceResult = RaceResult(raceDate: race.date!,
                                                driverId: (result.driver?.driverId)!,
                                                position: Int(result.position!) ?? 0,
                                                points: Int(result.points!) ?? 0)
                    constructor = result.constructor
                    raceResults.append(raceResult)
                }
            }
        }
    }

    func fetch(forDriverId id: String) async -> [Races] {
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
            let jsonDecoder = JSONDecoder()
            let results = try jsonDecoder.decode(RaceDataRoot.self, from: data)
            return results.mrData?.raceTable?.races ?? []
//            drivers = results.mrData?.driverTable?.drivers ?? []
//            seriesTitle = "\(results.mrData?.series ?? "") - \(results.mrData?.driverTable?.season ?? "") Season"
        } catch {
            print(error)
            return []
        }
    }
}
