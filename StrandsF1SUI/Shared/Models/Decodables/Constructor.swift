//
//  AverageSpeed.swift
//  StrandsF1
//
//  Created by Christopher Alford on 1/8/23.
//

import Foundation

struct Constructor : Decodable {
	let constructorId : String?
	let url : String?
	let name : String?
	let nationality : String?

	enum CodingKeys: String, CodingKey {
		case constructorId = "constructorId"
		case url = "url"
		case name = "name"
		case nationality = "nationality"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		constructorId = try values.decodeIfPresent(String.self, forKey: .constructorId)
		url = try values.decodeIfPresent(String.self, forKey: .url)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		nationality = try values.decodeIfPresent(String.self, forKey: .nationality)
	}

}
