//
//  DriverNumberView.swift
//  StrandsF1SUI
//
//  Created by Christopher Alford on 4/8/23.
//

import SwiftUI

struct DriverNumberView: View {
    @Environment(\.colorScheme) var colorScheme
    var number: String

    var body: some View {
        Text(number)
            .font(.title3)
            .fontWeight(.bold)
            .italic()
            .frame(width: 33, height: 33, alignment: .center)
            .padding()
            .overlay(
                Circle()
                    .stroke(colorScheme == .dark ? Color.white : Color.black, lineWidth: colorScheme == .dark ? 5 : 7)
                    .padding(6)
            )
    }
}

struct DriverNumberView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id:\.self) {
            DriverNumberView(number: "88")
                .preferredColorScheme($0)
        }
    }
}
