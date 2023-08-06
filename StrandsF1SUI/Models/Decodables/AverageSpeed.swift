//
//  AverageSpeed.swift
//  StrandsF1
//
//  Created by Christopher Alford on 1/8/23.
//

import Foundation

struct AverageSpeed : Decodable {
	let units : String?
	let speed : String?

	enum CodingKeys: String, CodingKey {
		case units = "units"
		case speed = "speed"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		units = try values.decodeIfPresent(String.self, forKey: .units)
		speed = try values.decodeIfPresent(String.self, forKey: .speed)
	}

}
