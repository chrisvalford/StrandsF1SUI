//
//  ResultsChart.swift
//  StrandsF1SUI
//
//  Created by Christopher Alford on 7/8/23.
//

import SwiftUI
import Charts

struct ResultsChart: View {

    var raceResults: [RaceResult] = []

    init(raceResults: [RaceResult]) {
        self.raceResults = raceResults
    }

    var body: some View {
        VStack {
            Text("Results:")
                .font(.headline)
                .padding(.horizontal)
        Chart {
            ForEach(raceResults) { result in
                LineMark(x: .value("Date", result.raceDate),
                         y: .value("Position", Int(result.position)!))
                .annotation(position: .top, alignment: .leading) {
                    Text("\(result.position)")
                        .font(.caption2)
                        .padding(5)
                        .background(Color(position: result.position))
                         .clipShape(Circle())
                }
            }
        }
        .chartYScale(domain: [20, 1])
        }
    }
}

//struct ResultsChart_Previews: PreviewProvider {
//    static var previews: some View {
//        ResultsChart()
//    }
//}
