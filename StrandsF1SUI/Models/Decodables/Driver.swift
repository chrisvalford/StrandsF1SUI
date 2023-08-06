//
//  AverageSpeed.swift
//  StrandsF1
//
//  Created by Christopher Alford on 1/8/23.
//

import Foundation

struct Driver : Decodable {
	let driverId : String?
	let permanentNumber : String?
	let code : String?
	let url : URL?
	let givenName : String?
	let familyName : String?
	let dateOfBirth : String?
	let nationality : String?

	enum CodingKeys: String, CodingKey {
		case driverId = "driverId"
		case permanentNumber = "permanentNumber"
		case code = "code"
		case url = "url"
		case givenName = "givenName"
		case familyName = "familyName"
		case dateOfBirth = "dateOfBirth"
		case nationality = "nationality"
	}

    init(driverId : String,
         permanentNumber : String,
         code : String,
         url : URL,
         givenName : String,
         familyName : String,
         dateOfBirth : String,
         nationality : String) {
        self.driverId = driverId
        self.permanentNumber = permanentNumber
        self.code = code
        self.url = url
        self.givenName = givenName
        self.familyName = familyName
        self.dateOfBirth = dateOfBirth
        self.nationality = nationality
    }

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		driverId = try values.decodeIfPresent(String.self, forKey: .driverId)
		permanentNumber = try values.decodeIfPresent(String.self, forKey: .permanentNumber)
		code = try values.decodeIfPresent(String.self, forKey: .code)
		url = try values.decodeIfPresent(URL.self, forKey: .url)
		givenName = try values.decodeIfPresent(String.self, forKey: .givenName)
		familyName = try values.decodeIfPresent(String.self, forKey: .familyName)
		dateOfBirth = try values.decodeIfPresent(String.self, forKey: .dateOfBirth)
		nationality = try values.decodeIfPresent(String.self, forKey: .nationality)
	}
}

extension Driver: Identifiable, Hashable {

    var id: String {
        return driverId ?? ""
    }
    var age: Int {
        return ageInYears(from: dateOfBirth ?? "01/01/1900")
    }

    var fullName: String {
        return "\(givenName ?? "") \(familyName ?? "")"
    }

    static func == (lhs: Driver, rhs: Driver) -> Bool {
        return lhs.driverId == rhs.driverId
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(driverId)
    }
}
