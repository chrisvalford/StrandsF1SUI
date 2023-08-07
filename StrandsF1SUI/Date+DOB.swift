//
//  Date+DOB.swift
//  StrandsF1SUI
//
//  Created by Christopher Alford on 7/8/23.
//

import Foundation

extension Date {
    func ageInYears() -> Int {
        let userLocale = Locale.autoupdatingCurrent
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = userLocale

        let passed = calendar.dateComponents([.year],
                                             from: self,
                                             to: Date())
        return passed.year ?? 0
    }
}
