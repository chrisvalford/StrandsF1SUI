//
//  AverageSpeed.swift
//  StrandsF1
//
//  Created by Christopher Alford on 1/8/23.
//

import Foundation

struct RaceTable : Decodable {
	let season : String?
	let driverId : String?
	let races : [Races]?

	enum CodingKeys: String, CodingKey {

		case season = "season"
		case driverId = "driverId"
		case races = "Races"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		season = try values.decodeIfPresent(String.self, forKey: .season)
		driverId = try values.decodeIfPresent(String.self, forKey: .driverId)
		races = try values.decodeIfPresent([Races].self, forKey: .races)
	}

}
