//
//  HomeView.swift
//  StrandsF1SUI
//
//  Created by Christopher Alford on 3/1/24.
//

import SwiftUI

struct HomeView: View {

    @StateObject var model = DataProvider()
    @State var selectedDriver: Driver

    let rows = [GridItem(.fixed(400))]

    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(.horizontal) {
                    LazyHGrid(rows: rows, spacing: 40) {
                        ForEach(model.drivers, id: \.self) { driver in
                            Button(action: {
                                selectedDriver = driver

                            }, label: {
                                DriverGridCell(driver: driver)
                                    .frame(height: 100)
                            })
                        }
                        .frame(height: 200)
                    }
                }
                Spacer()
                DriverDetail(driver: $selectedDriver)
                    .frame(height: 600)

            }
        }
        .onAppear {
            selectedDriver = Driver()
            model.fetchDrivers()
        }
        .environmentObject(model)
    }
}

#Preview {
    let driver = Driver(driverId: "bottas",
                               permanentNumber: "77",
                               code: "BOT",
                               url: URL(string: "http://en.wikipedia.org/wiki/Valtteri_Bottas")!,
                               givenName: "Valtteri",
                               familyName: "Bottas",
                               dateOfBirth: dateFormatter.date(from: "1989-08-28")!,
                               nationality: "Finnish")
    return HomeView(selectedDriver: driver)
}

/*
 ScrollView(.horizontal) {
     LazyHGrid(rows: rows, spacing: 40) {
         ForEach(provider.drivers, id: \.self) { driver in
             NavigationLink(destination: DriverDetail(driver: driver)) {
                 DriverGridCell(driver: driver)
                     .frame(height: 100)
             }
         }
         .frame(height: 200)
     }
 }
 */
