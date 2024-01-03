//
//  AverageSpeed.swift
//  StrandsF1
//
//  Created by Christopher Alford on 1/8/23.
//

import Foundation

struct RaceDataRoot: Decodable {
    
	let mrData : MRRaceData?

	enum CodingKeys: String, CodingKey {
		case mrData = "MRData"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		mrData = try values.decodeIfPresent(MRRaceData.self, forKey: .mrData)
	}

}
