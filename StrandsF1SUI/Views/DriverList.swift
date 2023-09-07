//
//  DriverList.swift
//  StrandsF1SUI
//
//  Created by Christopher Alford on 4/8/23.
//

import SwiftUI

struct DriverList: View {
    @State var seriesTitle: String = ""
    @StateObject private var model = DriverModel()
    @ObservedObject private var networkMonitor = NetworkMonitor()

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
            .navigationTitle(seriesTitle)
            .searchable(text: $model.searchText, prompt: "Filter drivers")
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
        .onAppear {
            model.fetch()
        }
        .popup(isPresented: !networkMonitor.connected, alignment: .top, direction: .top, content: WarningPanel.init)
    }

}

struct DriverList_Previews: PreviewProvider {

    static var previews: some View {
        DriverList()
    }
}
