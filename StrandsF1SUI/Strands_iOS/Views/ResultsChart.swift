//
//  ResultsChart.swift
//  StrandsF1SUI
//
//  Created by Christopher Alford on 7/8/23.
//

import SwiftUI
import Charts

struct ResultsChart: View {

//    @State var raceResults: [RaceResult] = [] {
//        didSet {
//            createMarks(raceResults: raceResults)
//        }
//    }

    @State private var plotMarks: [PlotMark] = []

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

    func createMarks(raceResults: [RaceResult]) {
        print("Creating marks")
        var i = 0
        for result in raceResults {
            // The sum up to this result
            let sum: Double = {
                var total: Double = 0
                for _ in 0..<i {
                    total += Double(raceResults[i].position) ?? 0
                }
                return total
            }()

            var plotMark = PlotMark(id: UUID() ,date: result.raceDate,
                                    position: Double(result.position) ?? 25)
            i += 1
            plotMark.average = sum / Double(i)
            self.plotMarks.append(plotMark)
            //print("Have \(self.plotMarks.count) plotMarks")
        }
    }
}

//struct ResultsChart_Previews: PreviewProvider {
//    static var previews: some View {
//        ResultsChart()
//    }
//}

/*
 Chart {
     ForEach(raceResults) { result in
         LineMark(x: .value("Date", result.raceDate),
                  y: .value("Position", Int(result.position)!))
         LineMark(x: .value("Date", result.raceDate),
                  y: .value("Average", Int(result.position)!))
         .annotation(position: .top, alignment: .leading) {
             Text("\(result.position)")
                 .font(.caption2)
                 .padding(5)
                 .background(Color(position: result.position))
                  .clipShape(Circle())
         }
     }
 }
 */
