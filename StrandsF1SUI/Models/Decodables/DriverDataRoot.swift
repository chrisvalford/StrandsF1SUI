//
//  DriverDataRoot.swift
//  StrandsF1SUI
//
//  Created by Christopher Alford on 5/8/23.
//

import Foundation

struct DriverDataRoot: Decodable {

    let mrData : MRDriverData?

    enum CodingKeys: String, CodingKey {
        case mrData = "MRData"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        mrData = try values.decodeIfPresent(MRDriverData.self, forKey: .mrData)
    }

}
