//
//  Driver_Decodable.swift
//  StrandsF1
//
//  Created by Christopher Alford on 1/8/23.
//

import Foundation

struct DriverListRoot: Decodable {
    let MRData: MRData
}

struct MRData: Decodable {
    let xmlns: String
    let series: String
    let url: URL
    let limit: String
    let offset: String
    let total: String
    let DriverTable: DriverTable
}

struct DriverTable: Decodable {
    let season: String
    let Drivers: [Driver]
}

struct Driver: Decodable, Identifiable {
    let driverId: String
    let permanentNumber: String
    let code: String
    let url: URL
    let givenName: String
    let familyName: String
    let dateOfBirth: String
    let nationality: String

    var id: String {
        return driverId
    }
    var age: Int {
        return ageInYears(from: dateOfBirth)
    }

    var fullName: String {
        return "\(givenName) \(familyName)"
    }
}

extension Driver: Hashable {
    
}
