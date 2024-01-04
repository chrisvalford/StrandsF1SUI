//
//  DataProvider.swift
//  StrandsF1
//
//  Created by Christopher Alford on 1/8/23.
//

import SwiftUI
import CoreData

/**
 * Model for the `DriverList` view
 */
@MainActor class DataProvider: ObservableObject {

    @Published var seriesTitle: String = ""
    @Published var drivers: [Driver] = []
    @Published var races: [Races] = []
    @Published var plotMarks: [PlotMark] = []
    @Published var constructor: Constructor?

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


    func fetchDrivers() {
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

    func fetchResults(id: String) async -> [RaceResult]? {
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
            //print("Have \(self.plotMarks.count) plotMarks")
        }
    }

    // Sample data as the driver data doesn't have a driver image
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

    func createImage(_ value: Data) -> Image {
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
