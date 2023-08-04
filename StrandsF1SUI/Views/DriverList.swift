//
//  DriverList.swift
//  StrandsF1SUI
//
//  Created by Christopher Alford on 4/8/23.
//

import SwiftUI

struct DriverList: View {

    let model = DriverModel()
    @State private var searchText = ""
    @State private var isShowingSort = false
    
    var body: some View {
        NavigationStack {
            List(model.drivers, id: \.self) { driver in
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
                Button {
                    isShowingSort.toggle()
                } label: { Image(systemName: "arrow.up.arrow.down") }
            }
        }
    }
}

struct DriverList_Previews: PreviewProvider {
    static var previews: some View {
        DriverList()
    }
}
