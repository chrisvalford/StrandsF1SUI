//
//  DriverTable.swift
//  StrandsF1SUI
//
//  Created by Christopher Alford on 5/8/23.
//

import Foundation

struct DriverTable: Decodable {
    let season: String?
    let drivers: [Driver]?

    enum CodingKeys: String, CodingKey {

        case season = "season"
        case drivers = "Drivers"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        season = try values.decodeIfPresent(String.self, forKey: .season)
        drivers = try values.decodeIfPresent([Driver].self, forKey: .drivers)
    }
}
