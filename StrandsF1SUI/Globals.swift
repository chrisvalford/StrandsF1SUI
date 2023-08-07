//
//  Globals.swift
//  StrandsF1
//
//  Created by Christopher Alford on 2/8/23.
//

import SwiftUI

func ageInYears(from dob: Date) -> Int {
    let userLocale = Locale.autoupdatingCurrent
    var calendar = Calendar(identifier: .gregorian)
    calendar.locale = userLocale

    let passed = calendar.dateComponents([.year],
                                         from: dob,
                                         to: Date())
    return passed.year ?? 0
}

//TODO: Check against device 12/24 Hr clock & different Locales
var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.locale = Locale(identifier: "en_US")
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    return formatter
}

extension String {

    // Unwrapping
    private func formattedDate() -> Date {
        return dateFormatter.date(from: self) ?? Date(timeIntervalSinceReferenceDate: 0)
    }

    func raceDate() -> String {
        let date = self.formattedDate()
        let userLocale = Locale.autoupdatingCurrent
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = userLocale

        let calendarDate = Calendar.current.dateComponents([.day, .year, .month], from: date)
        return " \(calendarDate.day ?? 0) \(calendarDate.month ?? 0)"
    }
}

extension Color {
    init(position: String?) {
        guard let position = position else {
            self = .white
            return
        }

        switch Int(position) ?? 99 {
        case 0..<4:
            self = .yellow
        default:
            self = .gray.opacity(0.5)
        }
    }
}
