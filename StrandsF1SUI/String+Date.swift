//
//  String+Date.swift
//  StrandsF1SUI
//
//  Created by Christopher Alford on 7/8/23.
//

import Foundation

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
