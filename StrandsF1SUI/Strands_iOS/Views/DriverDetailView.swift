//
//  DriverDetailView.swift
//  StrandsF1SUI
//
//  Created by Christopher Alford on 4/8/23.
//

import SwiftUI

struct DriverDetailView: View {
    @StateObject private var raceSevice = RaceService()
    var driver: Driver

    @State private var x = 0

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Age: \(driver.age)")
                            Text("\(driver.nationality ?? "") \(CountryLookup.flag(forNationality: driver.nationality))")
                        }
                        Text("Team: \(raceSevice.constructor?.name ?? "")")
                            .font(.subheadline)
                    }
                    Spacer()
                    DriverNumberView(number: driver.permanentNumber)
                }
            }
            .padding()
            ResultsChart(plotMarks: raceSevice.plotMarks)
            .frame(height: 200)
            .padding(.horizontal)
            List(raceSevice.races, id: \.self) { race in
                RaceListCell(race: race)
                    .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
        }
        .task {
            do {
                try await raceSevice.getResults(forDriver:  driver.driverId ?? "0000")
            } catch {
                print(error)
            }
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
