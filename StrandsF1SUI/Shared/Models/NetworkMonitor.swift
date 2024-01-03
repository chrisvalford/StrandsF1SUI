//
//  NetworkMonitor.swift
//  ParisForecast (iOS)
//
//  Created by Christopher Alford on 22/2/22.
//

import Foundation
import Network

class NetworkMonitor: ObservableObject {
    
    @Published private(set) var connected: Bool = false
    
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "NetworkMonitor")
    
    init() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    self.connected = true
                }
            } else {
                DispatchQueue.main.async {
                    self.connected = false
                }
            }
        }
        monitor.start(queue: queue)
    }
}
