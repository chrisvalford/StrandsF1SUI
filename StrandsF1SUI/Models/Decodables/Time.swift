//
//  AverageSpeed.swift
//  StrandsF1
//
//  Created by Christopher Alford on 1/8/23.
//

import Foundation

struct Time : Decodable {
	let time : String?

	enum CodingKeys: String, CodingKey {

		case time = "time"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		time = try values.decodeIfPresent(String.self, forKey: .time)
	}

}
