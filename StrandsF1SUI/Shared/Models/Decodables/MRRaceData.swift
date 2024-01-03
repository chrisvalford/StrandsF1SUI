//
//  AverageSpeed.swift
//  StrandsF1
//
//  Created by Christopher Alford on 1/8/23.
//

import Foundation

struct MRRaceData : Decodable {
	let xmlns : String?
	let series : String?
	let url : URL?
	let limit : String?
	let offset : String?
	let total : String?
	let raceTable : RaceTable?

	enum CodingKeys: String, CodingKey {

		case xmlns = "xmlns"
		case series = "series"
		case url = "url"
		case limit = "limit"
		case offset = "offset"
		case total = "total"
		case raceTable = "RaceTable"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		xmlns = try values.decodeIfPresent(String.self, forKey: .xmlns)
		series = try values.decodeIfPresent(String.self, forKey: .series)
		url = try values.decodeIfPresent(URL.self, forKey: .url)
		limit = try values.decodeIfPresent(String.self, forKey: .limit)
		offset = try values.decodeIfPresent(String.self, forKey: .offset)
		total = try values.decodeIfPresent(String.self, forKey: .total)
		raceTable = try values.decodeIfPresent(RaceTable.self, forKey: .raceTable)
	}
}
