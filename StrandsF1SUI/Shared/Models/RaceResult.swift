//
//  RaceResult.swift
//  StrandsF1SUI
//
//  Created by Christopher Alford on 6/9/23.
//

import Foundation

struct RaceResult: Identifiable {
    let raceDate: Date
    let driverId: String
    let position: String
    let points: String

    var id: String {
        return "\(raceDate.description)\(driverId)"
    }
}
