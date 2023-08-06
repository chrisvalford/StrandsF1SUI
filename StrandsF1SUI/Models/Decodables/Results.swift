//
//  AverageSpeed.swift
//  StrandsF1
//
//  Created by Christopher Alford on 1/8/23.
//

import Foundation

struct Results : Decodable {
	let number : String?
	let position : String?
	let positionText : String?
	let points : String?
	let driver : Driver?
	let constructor : Constructor?
	let grid : String?
	let laps : String?
	let status : String?
	let time : Time?
	let fastestLap : FastestLap?

	enum CodingKeys: String, CodingKey {

		case number = "number"
		case position = "position"
		case positionText = "positionText"
		case points = "points"
		case driver = "Driver"
		case constructor = "Constructor"
		case grid = "grid"
		case laps = "laps"
		case status = "status"
		case time = "Time"
		case fastestLap = "FastestLap"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		number = try values.decodeIfPresent(String.self, forKey: .number)
		position = try values.decodeIfPresent(String.self, forKey: .position)
		positionText = try values.decodeIfPresent(String.self, forKey: .positionText)
		points = try values.decodeIfPresent(String.self, forKey: .points)
		driver = try values.decodeIfPresent(Driver.self, forKey: .driver)
		constructor = try values.decodeIfPresent(Constructor.self, forKey: .constructor)
		grid = try values.decodeIfPresent(String.self, forKey: .grid)
		laps = try values.decodeIfPresent(String.self, forKey: .laps)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		time = try values.decodeIfPresent(Time.self, forKey: .time)
		fastestLap = try values.decodeIfPresent(FastestLap.self, forKey: .fastestLap)
	}

}
