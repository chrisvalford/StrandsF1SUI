//
//  Globals.swift
//  StrandsF1
//
//  Created by Christopher Alford on 2/8/23.
//

import Foundation

func ageInYears(from dob: String) -> Int {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"

    guard let dob = formatter.date(from: dob) else {
        return 0
    }

    let userLocale = Locale.autoupdatingCurrent
    var calendar = Calendar(identifier: .gregorian)
    calendar.locale = userLocale

    let passed = calendar.dateComponents([.year],
                                         from: dob,
                                         to: Date())
    return passed.year ?? 0
}

extension String {
    func formattedDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: self)
    }

    func raceDate() -> String {
        guard let date = self.formattedDate() else {
            return ""
        }
        let userLocale = Locale.autoupdatingCurrent
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = userLocale

        let calendarDate = Calendar.current.dateComponents([.day, .year, .month], from: date)
        return " \(calendarDate.day ?? 0) \(calendarDate.month ?? 0)"
    }
}
