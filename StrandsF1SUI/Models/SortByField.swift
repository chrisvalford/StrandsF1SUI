//
//  SortByField.swift
//  StrandsF1SUI
//
//  Created by Christopher Alford on 5/8/23.
//

import Foundation

enum SortByField: CaseIterable, Identifiable, CustomStringConvertible {
    case none
    case permanentNumber
    case nameFirstLast
    case nameLastFirst
    case age
    case nationality

    var id: Self { self }

    var description: String {
        switch self {
        case .none:
            return "Not sorted"
        case .permanentNumber:
            return "Permanent Number"
        case .nameFirstLast:
            return "Name (first, last)"
        case .nameLastFirst:
            return "Name (last, first)"
        case .age:
            return "Age"
        case .nationality:
            return  "Nationaity"
        }
    }
}
