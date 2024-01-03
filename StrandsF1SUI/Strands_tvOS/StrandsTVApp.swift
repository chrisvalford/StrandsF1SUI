//
//  StrandsTVApp.swift
//  StrandsTV
//
//  Created by Christopher Alford on 3/1/24.
//

import SwiftUI

@main
struct StrandsTVApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
