//
//  DriverList.swift
//  StrandsF1SUI
//
//  Created by Christopher Alford on 4/8/23.
//

import SwiftUI

struct DriverList: View {

    @StateObject var model = DriverModel()
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            List(model.sortedDrivers, id: \.self) { driver in
                NavigationLink(destination: DriverDetailView(driver: driver)) {
                    DriverListCell(driver: driver)
                        .frame(height: 100)
                        .listRowSeparator(.hidden)
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle(model.seriesTitle)
            .searchable(text: $searchText, prompt: "Filter drivers")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu(content: {
                        Picker("Sort by",
                               selection: $model.selectedSort
                        ) {
                            ForEach(SortByField.allCases) { text in
                                Text("\(text.description)")
                            }
                        }
                    }, label: { Image(systemName: "arrow.up.arrow.down") } )
                }
            }
        }
    }
}

struct DriverList_Previews: PreviewProvider {

    static var previews: some View {
        DriverList()
    }
}
