//
//  ResultsChart.swift
//  StrandsF1SUI
//
//  Created by Christopher Alford on 7/8/23.
//

import SwiftUI
import Charts

struct ResultsChart: View {

    var plotMarks: [PlotMark] = []

    var body: some View {
        VStack {
            Text("Results:")
                .font(.headline)
                .padding(.horizontal)
            Chart {
                ForEach(plotMarks, id: \.self) { mark in
                    LineMark(x: .value("Date", mark.date), y: .value("Position", mark.position))
                    //LineMark(x: .value("Date", mark.raceDate), y: .value("Average", mark.average))
                    .annotation(position: .top, alignment: .leading) {
                        Text("\(mark.position)")
                            .font(.caption2)
                            .padding(5)
                            .background(Color(position: "\(mark.position)"))
                             .clipShape(Circle())
                    }
                }
            }
        .chartYScale(domain: [20, 1])
        }
    }
}
