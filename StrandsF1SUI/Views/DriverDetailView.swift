//
//  DriverDetailView.swift
//  StrandsF1SUI
//
//  Created by Christopher Alford on 4/8/23.
//

import SwiftUI

struct DriverDetailView: View {

    var model: DriverDetailModel

    init(driver: Driver) {
        model = DriverDetailModel(driver: driver)
    }

    @State private var x = 0

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Age: \(model.driver.age)")
                            Text("\(model.driver.nationality ?? "") \(CountryLookup.flag(forNationality: model.driver.nationality))")
                        }
                        Text("Team: \(model.constructor?.name ?? "")")
                            .font(.subheadline)
                    }
                    Spacer()
                    DriverNumberView(number: model.driver.permanentNumber ?? "0")
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
        .navigationTitle(model.driver.fullName)
    }
}

//struct DriverDetailView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        DriverDetailView(driverId: "albon")
//    }
//}
