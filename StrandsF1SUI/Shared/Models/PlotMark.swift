//
//  PlotMark.swift
//  StrandsF1SUI
//
//  Created by Christopher Alford on 7/9/23.
//

import Foundation

struct PlotMark: Identifiable, Hashable {
    let id: UUID
    let date: Date
    var position: Double = 0
    var average: Double = 0
}
