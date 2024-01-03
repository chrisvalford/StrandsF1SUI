//
//  Color+Position.swift
//  StrandsF1SUI
//
//  Created by Christopher Alford on 7/8/23.
//

import SwiftUI

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
