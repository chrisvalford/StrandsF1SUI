//
//  CountryLookup.swift
//  StrandsF1SUI
//
//  Created by Christopher Alford on 4/8/23.
//

import Foundation

struct CountryLookup {
    private static let countries = ["Thai":"TH","Spanish":"ES","Finnish":"FI","Dutch":"NL","French":"FR","British":"GB","German":"DE","Monegasque":"MC","Danish":"DK","Mexican":"MX","Australian":"AU","American":"US","Canadian":"CA","Japanese":"JP","Chinese":"CN","New Zealander":"NZ"]

    /**
     * Create the unicode string for a country flag
     * - Parameter forNationality: the nationality i.e. French
     * - Returns: The unicode string for the nationalities flag, or a blank (🏳️) flag if the nationality cannot be found.
     */
    static func flag(forNationality: String?) -> String {
        guard let forNationality = forNationality,
                let code = CountryLookup.countries[forNationality] else {
            return String(UnicodeScalar(0x1F3F3)!)
        }
        return flag(forCountry: code)
    }

    /**
     * Create the unicode string for a country flag
     * - Parameter forCountry: ISO 2 character country code i.e. GB
     * - Returns: The unicode string for the countries flag.
     */
    static func flag(forCountry code: String) -> String {
        code
            .unicodeScalars
            .map( { 127397 + $0.value } )
            .compactMap(UnicodeScalar.init)
            .map(String.init)
            .joined()
    }
}
