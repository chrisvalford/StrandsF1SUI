//
//  AverageSpeed.swift
//  StrandsF1
//
//  Created by Christopher Alford on 1/8/23.
//

import Foundation

struct RaceDataRoot: Decodable {
    
	let mRData : MRRaceData?

	enum CodingKeys: String, CodingKey {
		case mRData = "MRData"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		mRData = try values.decodeIfPresent(MRRaceData.self, forKey: .mRData)
	}

}
