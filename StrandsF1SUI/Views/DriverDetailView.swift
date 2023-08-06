//
//  DriverDetailView.swift
//  StrandsF1SUI
//
//  Created by Christopher Alford on 4/8/23.
//

import SwiftUI
import Charts

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
                            Text("\(model.driver.nationality ?? "") \(CountryLookup.flag(forNationality: model.driver.nationality ?? ""))")
                        }
                        Text("Team: \(model.constructor?.name ?? "")")
                            .font(.subheadline)
                    }
                    Spacer()
                    DriverNumberView(number: model.driver.permanentNumber ?? "0")
                }
            }
            .padding()
            Text("Results:")
                .font(.headline)
                .padding(.horizontal)
            Chart {
                ForEach(model.raceResults) { result in
                    LineMark(x: .value("Date", result.raceDate.formattedDate() ?? Date()),
                             y: .value("position", result.position))
                    .annotation(position: .top, alignment: .leading) {
                        Text("\(result.position)")
                            .font(.caption2)
                            .padding(5)
                            .background(result.position < 4 ? Color.yellow : Color.gray.opacity(0.5))
                             .clipShape(Circle())
                    }
                }
            }
            .chartYScale(domain: [20, 1])
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
