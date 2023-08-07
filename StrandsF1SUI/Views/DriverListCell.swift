//
//  DriverListCell.swift
//  StrandsF1SUI
//
//  Created by Christopher Alford on 4/8/23.
//

import SwiftUI

struct DriverListCell: View {

    var driver: Driver
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(driver.fullName)")
                        .font(.title)
                HStack {
                        Text("age: \(driver.age)")
                    Text("\(driver.nationality ?? "") \(CountryLookup.flag(forNationality: driver.nationality))")
                    }
                }
            Spacer()
            DriverNumberView(number: driver.permanentNumber ?? "0")
        }
    }
}

struct DriverListCell_Previews: PreviewProvider {

    static let driver = Driver(driverId: "bottas",
                               permanentNumber: "77",
                               code: "BOT",
                               url: URL(string: "http://en.wikipedia.org/wiki/Valtteri_Bottas")!,
                               givenName: "Valtteri",
                               familyName: "Bottas",
                               dateOfBirth: dateFormatter.date(from: "1989-08-28")!,
                               nationality: "Finnish")
    static var previews: some View {
        DriverListCell(driver: driver)
    }
}
