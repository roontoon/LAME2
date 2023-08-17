//
//  DataManager.swift
//  LAME2
//
//  Created by Roontoon on 7/26/23.
//
//
import Foundation
import Network

class DataManager: ObservableObject {
    var connection: NWConnection?
    let hostUDP = NWEndpoint.Host("192.168.1.1") // example IP address
    let portUDP = NWEndpoint.Port(12345) // example port
    
    func establishConnection() {
        let endpoint = NWEndpoint.hostPort(host: hostUDP, port: portUDP)
        connection = NWConnection(to: endpoint, using: .udp)

        connection?.stateUpdateHandler = { (newState) in
            switch (newState) {
            case .ready:
                print("ready")
                // You're now ready to send and receive data
            case .setup:
                print("setup")
            case .cancelled:
                print("cancelled")
            case .preparing:
                print("Preparing")
            default:
                print("waiting or failed")
            }
        }
        // Start the connection
        connection?.start(queue: .global())
    }
}
