//
//  Globals.swift
//  StrandsF1
//
//  Created by Christopher Alford on 2/8/23.
//

import SwiftUI

//TODO: Check against device 12/24 Hr clock & different Locales
var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.locale = Locale(identifier: "en_US")
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    return formatter
}


