//
//  AverageSpeed.swift
//  StrandsF1
//
//  Created by Christopher Alford on 1/8/23.
//

import Foundation

struct Location : Decodable {
	let lat : String?
	let long : String?
	let locality : String?
	let country : String?

	enum CodingKeys: String, CodingKey {

		case lat = "lat"
		case long = "long"
		case locality = "locality"
		case country = "country"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		lat = try values.decodeIfPresent(String.self, forKey: .lat)
		long = try values.decodeIfPresent(String.self, forKey: .long)
		locality = try values.decodeIfPresent(String.self, forKey: .locality)
		country = try values.decodeIfPresent(String.self, forKey: .country)
	}

}
