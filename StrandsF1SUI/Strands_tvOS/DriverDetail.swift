//
//  DriverDetailView.swift
//  StrandsF1SUI
//
//  Created by Christopher Alford on 4/8/23.
//

import SwiftUI
import Kingfisher

struct DriverDetail: View {
    @EnvironmentObject var model: DataProvider

    @Binding var driver: Driver
    @State private var raceResults: [RaceResult] = []

    @State private var x = 0
    var resultsChart = ResultsChart()
    @State private var driverImage: KFImage?

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                if driverImage != nil {
                    driverImage!
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(12)
                        .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(.teal, lineWidth: 4)
                            )
                        .frame(width: 300, height: 300)
                }
                DriverNumberView(number: driver.permanentNumber)
                Text("Age: \(driver.age)")
                Text("\(driver.nationality ?? "") \(CountryLookup.flag(forNationality: driver.nationality))")
                Text("Team: \(model.constructor?.name ?? "")")
                    .font(.subheadline)
            }
            List(model.races, id: \.self) { race in
                RaceListCell(race: race)
                    .focusable()
            }
            resultsChart
        }

        //ResultsChart(raceResults: raceResults)
        .frame(height: 600)
        .padding(.horizontal)
        .onAppear {
            updateDriver()
        }
        .onChange(of: driver) { newDriver in
                updateDriver()
        }
    }

    private func updateDriver() {
        Task {
            if driver.id != "0000" {
                let results = await model.fetchResults(id: driver.driverId ?? "") ?? []
                resultsChart.createMarks(raceResults: results)
                let url = model.imageURLForDriver(id: driver.id)!
                driverImage = KFImage(url)
            } else {
                driverImage = KFImage(URL(string: "https://marine.digital/f1/drivers/640/lewis_hamilton")!)
            }
        }
    }
}

struct DriverDetail_Previews: PreviewProvider {
    static let driver = Driver(driverId: "bottas",
                               permanentNumber: "77",
                               code: "BOT",
                               url: URL(string: "http://en.wikipedia.org/wiki/Valtteri_Bottas")!,
                               givenName: "Valtteri",
                               familyName: "Bottas",
                               dateOfBirth: dateFormatter.date(from: "1989-08-28")!,
                               nationality: "Finnish")

    static var previews: some View {
        @State var driver = Driver()
        DriverDetail(driver: $driver)
    }
}
