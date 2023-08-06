//
//  AverageSpeed.swift
//  StrandsF1
//
//  Created by Christopher Alford on 1/8/23.
//

import Foundation

struct FastestLap : Decodable {
	let rank : String?
	let lap : String?
	let time : Time?
	let averageSpeed : AverageSpeed?

	enum CodingKeys: String, CodingKey {
		case rank = "rank"
		case lap = "lap"
		case time = "Time"
		case averageSpeed = "AverageSpeed"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		rank = try values.decodeIfPresent(String.self, forKey: .rank)
		lap = try values.decodeIfPresent(String.self, forKey: .lap)
		time = try values.decodeIfPresent(Time.self, forKey: .time)
		averageSpeed = try values.decodeIfPresent(AverageSpeed.self, forKey: .averageSpeed)
	}

}
