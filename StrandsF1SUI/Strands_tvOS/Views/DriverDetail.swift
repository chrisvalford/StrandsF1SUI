//
//  DriverDetailView.swift
//  StrandsF1SUI
//
//  Created by Christopher Alford on 4/8/23.
//

import SwiftUI
import Kingfisher

struct DriverDetail: View {
    
    @EnvironmentObject var driverService: DriverService
    @StateObject var raceService = RaceService()

    @Binding var driver: Driver

    @State private var x = 0
    //var resultsChart = ResultsChart()
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
                Text("Team: \(raceService.constructor?.name ?? "")")
                    .font(.subheadline)
            }
            List(raceService.races, id: \.self) { race in
                RaceListCell(race: race)
                    .focusable()
            }
            ResultsChart(plotMarks: raceService.plotMarks)
        }
        .frame(height: 500)
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
                try await raceService.getResults(forDriver: driver.driverId ?? "")
                //resultsChart.createMarks(raceResults: model.results)
                let url = driverService.imageURLForDriver(id: driver.id)!
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
