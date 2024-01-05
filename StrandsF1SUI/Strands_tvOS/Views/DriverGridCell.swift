//
//  DriverGridCell.swift
//  StrandsF1SUI
//
//  Created by Christopher Alford on 4/8/23.
//

import SwiftUI

struct DriverGridCell: View {

    var driver: Driver
    
    var body: some View {
//        HStack {
            VStack(alignment: .leading) {
                Text("\(driver.fullName)")
                        .font(.headline)
//                HStack {
                    Text("age: \(driver.age)")
                        .font(.subheadline)
                    Text("\(driver.nationality ?? "") \(CountryLookup.flag(forNationality: driver.nationality))")
                        .font(.subheadline)
                    }
//                }
//            Spacer()
//            DriverNumberView(number: driver.permanentNumber)
//        }
    }
}

struct DriverGridCell_Previews: PreviewProvider {

    static let driver = Driver(driverId: "bottas",
                               permanentNumber: "77",
                               code: "BOT",
                               url: URL(string: "http://en.wikipedia.org/wiki/Valtteri_Bottas")!,
                               givenName: "Valtteri",
                               familyName: "Bottas",
                               dateOfBirth: dateFormatter.date(from: "1989-08-28")!,
                               nationality: "Finnish")
    static var previews: some View {
        DriverGridCell(driver: driver)
    }
}
