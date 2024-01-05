//
//  RaceService.swift
//  StrandsF1
//
//  Created by Christopher Alford on 1/8/23.
//

import SwiftUI
import CoreData


@MainActor class RaceService: ObservableObject {

    @Published var seriesTitle: String = ""
    @Published var drivers: [Driver] = []
    @Published var races: [Races] = []
    @Published var raceResults: [RaceResult] = [] {
        didSet {
            createMarks(raceResults: self.raceResults)
        }
    }
    @Published var plotMarks: [PlotMark] = []
    @Published var constructor: Constructor?

    /**
     * fetch and decode race results for specific driver from ergast service
     */
    func getResults(forDriver id: String) async throws {
        self.races.removeAll()
        self.raceResults.removeAll()
        var jsonUrl = URL(string: "")
        var rootData: RaceDataRoot
        do {
            guard let url = URL(string: "https://ergast.com/api/f1/current/drivers/\(id)/results.json") else {
                throw ServiceError.invalidURL
            }
            jsonUrl = url
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw ServiceError.invalidResponse
            }
            try await Cache.update(url: url, data: data)
            rootData = try await decode(data: data)

        } catch {
            guard let data = try Cache.read(url: jsonUrl!) else {
                throw ServiceError.cacheEmpty
            }
            rootData = try await decode(data: data)
        }
        self.races = rootData.mrData?.raceTable?.races ?? []

        var items: [RaceResult] = []
        for race in races {
            for result in race.results! {
                let raceResult = RaceResult(raceDate: race.date,
                                            driverId: (result.driver?.driverId)!,
                                            position: result.position ?? "0",
                                            points: result.points ?? "0")
                // Don't update if already the same
                if self.constructor != result.constructor {
                    self.constructor = result.constructor
                }
                items.append(raceResult)
            }
        }
        self.raceResults = items
    }

    func createMarks(raceResults: [RaceResult]) {
        print("Creating marks")
        var items: [PlotMark] = []
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
            items.append(plotMark)
            //print("Have \(self.plotMarks.count) plotMarks")
        }
        self.plotMarks = items
    }
    
}
