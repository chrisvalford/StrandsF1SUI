//
//  RaceListCell.swift
//  StrandsF1SUI
//
//  Created by Christopher Alford on 5/8/23.
//

import SwiftUI

struct RaceListCell: View {

    var race: Races
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.teal)
            VStack {
                HStack {
                    Text("Round: ")
                    Text(race.round ?? "")
                    Spacer()
                    Text(race.circuit?.circuitName ?? "")
                }
                HStack {
                    Text("\(dateFormatter.string(from: race.date))")
                    Spacer()
                    Text("Finished: ")
                    Text(race.results?[0].position ?? "")
                }
            }
            .padding()
        }
    }
}

//struct RaceListCell_Previews: PreviewProvider {
//    static var previews: some View {
//        RaceListCell()
//    }
//}
