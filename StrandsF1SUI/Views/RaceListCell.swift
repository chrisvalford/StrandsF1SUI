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
        HStack {
            Text("Round: ")
            Text(race.round ?? "")
            Spacer()
        }
        Text(race.circuit?.circuitName ?? "")
        HStack {
            Text(race.date ?? "")
            Spacer()
            Text("Finished: ")
            Text(race.results?[0].position ?? "")
        }
    }
}

//struct RaceListCell_Previews: PreviewProvider {
//    static var previews: some View {
//        RaceListCell()
//    }
//}
