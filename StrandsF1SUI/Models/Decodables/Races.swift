//
//  AverageSpeed.swift
//  StrandsF1
//
//  Created by Christopher Alford on 1/8/23.
//

import Foundation

struct Races : Decodable {
	let season : String?
	let round : String?
	let url : String?
	let raceName : String?
	let circuit : Circuit?
	let date : String?
	let time : String?
	let results : [Results]?

	enum CodingKeys: String, CodingKey {

		case season = "season"
		case round = "round"
		case url = "url"
		case raceName = "raceName"
		case circuit = "Circuit"
		case date = "date"
		case time = "time"
		case results = "Results"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		season = try values.decodeIfPresent(String.self, forKey: .season)
		round = try values.decodeIfPresent(String.self, forKey: .round)
		url = try values.decodeIfPresent(String.self, forKey: .url)
		raceName = try values.decodeIfPresent(String.self, forKey: .raceName)
		circuit = try values.decodeIfPresent(Circuit.self, forKey: .circuit)
		date = try values.decodeIfPresent(String.self, forKey: .date)
		time = try values.decodeIfPresent(String.self, forKey: .time)
		results = try values.decodeIfPresent([Results].self, forKey: .results)
	}

}

extension Races: Identifiable, Hashable {

    var id: String {
        return "\(season ?? "")\(round ?? "")"
    }

    static func == (lhs: Races, rhs: Races) -> Bool {
        return lhs.season == rhs.season && lhs.round == rhs.round
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(raceName)
    }
}
