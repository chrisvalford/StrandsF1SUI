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
                        Text("Team: \(model.constructor?.name ?? "")")
                            .font(.subheadline)
                    }
                    Spacer()
                    DriverNumberView(number: driver.permanentNumber)
                }
            }
            .padding()
            ResultsChart(raceResults: model.raceResults)
            .frame(height: 200)
            .padding(.horizontal)
            List(model.races, id: \.self) { race in
                RaceListCell(race: race)
                    .listRowSeparator(.hidden)
            }
        }
        .onAppear {
            model.fetch(id: driver.driverId ?? "")
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
