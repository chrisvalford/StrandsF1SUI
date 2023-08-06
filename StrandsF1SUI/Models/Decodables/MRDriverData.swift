//
//  MRDriverData.swift
//  StrandsF1SUI
//
//  Created by Christopher Alford on 5/8/23.
//

import Foundation

struct MRDriverData: Decodable {
    let xmlns: String?
    let series: String?
    let url: URL?
    let limit: String?
    let offset: String?
    let total: String?
    let driverTable: DriverTable?

    enum CodingKeys: String, CodingKey {

        case xmlns = "xmlns"
        case series = "series"
        case url = "url"
        case limit = "limit"
        case offset = "offset"
        case total = "total"
        case driverTable = "DriverTable"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        xmlns = try values.decodeIfPresent(String.self, forKey: .xmlns)
        series = try values.decodeIfPresent(String.self, forKey: .series)
        url = try values.decodeIfPresent(URL.self, forKey: .url)
        limit = try values.decodeIfPresent(String.self, forKey: .limit)
        offset = try values.decodeIfPresent(String.self, forKey: .offset)
        total = try values.decodeIfPresent(String.self, forKey: .total)
        driverTable = try values.decodeIfPresent(DriverTable.self, forKey: .driverTable)
    }
}
