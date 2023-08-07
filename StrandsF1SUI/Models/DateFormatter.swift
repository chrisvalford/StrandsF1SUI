//
//  DateFormatter.swift
//  StrandsF1SUI
//
//  Created by Christopher Alford on 7/8/23.
//

import Foundation

//TODO: Check against device 12/24 Hr clock & different Locales
var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.locale = Locale(identifier: "en_US")
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    return formatter
}
