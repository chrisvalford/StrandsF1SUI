//
//  CountryLookup.swift
//  StrandsF1SUI
//
//  Created by Christopher Alford on 4/8/23.
//

import Foundation

let countries = ["Thai":"TH","Spanish":"ES","Finnish":"FI","Dutch":"NL","French":"FR","British":"GB","German":"DE","Monegasque":"MC","Danish":"DK","Mexican":"MX","Australian":"AU","American":"US","Canadian":"CA","Japanese":"JP","Chinese":"CN"]

func flag(forNationality: String) -> String {
    let code = countries[forNationality]
    return flag(forCountry: code!)
}

func flag(forCountry code: String) -> String {
    code
        .unicodeScalars
        .map( { 127397 + $0.value } )
        .compactMap(UnicodeScalar.init)
        .map(String.init)
        .joined()
}
