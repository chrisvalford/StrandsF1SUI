//
//  DriverDetailView.swift
//  StrandsF1SUI
//
//  Created by Christopher Alford on 4/8/23.
//

import SwiftUI

struct DriverDetailView: View {
    @StateObject private var model = DriverDetailModel()
    var driver: Driver
    @State private var raceResults: [RaceResult] = [] {
        didSet {
            print("Detail didSet: \(raceResults.count) results")
        }
    }

    @State private var x = 0
    var resultsChart = ResultsChart()

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Age: \(driver.age)")
                            Text("\(driver.nationality ?? "") \(CountryLookup.flag(forNationality: driver.nationality))")
                        }
                        Text("Team: \(model.constructor?.name ?? "")")
                            .font(.subheadline)
                    }
                    Spacer()
                    DriverNumberView(number: driver.permanentNumber)
                }
            }
            .padding()
            resultsChart
            //ResultsChart(raceResults: raceResults)
            .frame(height: 200)
            .padding(.horizontal)
            List(model.races, id: \.self) { race in
                RaceListCell(race: race)
                    .listRowSeparator(.hidden)
            }
        }
        .task {
            let thing = await model.fetch(id: driver.driverId ?? "") ?? []
            resultsChart.createMarks(raceResults: thing)
        }
        .navigationTitle(driver.fullName)
    }
}

//struct DriverDetailView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        DriverDetailView(driverId: "albon")
//    }
//}
