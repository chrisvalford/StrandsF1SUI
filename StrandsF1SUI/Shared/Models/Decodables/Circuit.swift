//
//  AverageSpeed.swift
//  StrandsF1
//
//  Created by Christopher Alford on 1/8/23.
//

import Foundation

struct Circuit : Decodable {
	let circuitId : String?
	let url : String?
	let circuitName : String?
	let location : Location?

	enum CodingKeys: String, CodingKey {
		case circuitId = "circuitId"
		case url = "url"
		case circuitName = "circuitName"
		case location = "Location"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		circuitId = try values.decodeIfPresent(String.self, forKey: .circuitId)
		url = try values.decodeIfPresent(String.self, forKey: .url)
		circuitName = try values.decodeIfPresent(String.self, forKey: .circuitName)
		location = try values.decodeIfPresent(Location.self, forKey: .location)
	}

}
