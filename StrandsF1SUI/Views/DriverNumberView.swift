//
//  DriverNumberView.swift
//  StrandsF1SUI
//
//  Created by Christopher Alford on 4/8/23.
//

import SwiftUI

struct DriverNumberView: View {

    var number: String

    var body: some View {
        Text(number)
            .font(.title3)
            .fontWeight(.heavy)
            .italic()
            .frame(width: 32, height: 32, alignment: .center)
            .padding()
            .overlay(
                Circle()
                    .stroke(Color.black, lineWidth: 8)
                    .padding(4)
            )
    }
}

struct DriverNumberView_Previews: PreviewProvider {
    static var previews: some View {
        DriverNumberView(number: "11")
    }
}
