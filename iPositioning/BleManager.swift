//
//  BleManager.swift
//  iPositioning
//
//  Created by Jasper Hsieh on 4/5/20.
//  Copyright © 2020 Jasper Hsieh. All rights reserved.
//

import Foundation
import CoreBluetooth

class BleManager: NSObject, CBCentralManagerDelegate, ObservableObject {
    private var centralManager : CBCentralManager!
    @Published var iBeacon1Rssi: NSNumber = 0
    
    func startScan(){
        print("startScan")
        centralManager = CBCentralManager(delegate: self, queue: nil, options: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("centralManagerDidUpdateState")
        if central.state == .poweredOn {
            print("Bluetooth is On")
            //centralManager = CBCentralManager(delegate: self, queue: nil, options: nil)
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        } else {
            print("Bluetooth is not active")
        }
    }
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if peripheral.name == "pBeacon_n" || peripheral.name == "J_iBcn" {
            print("\nName   : \(peripheral.name ?? "(No name)")")
            print("RSSI   : \(RSSI)")
            iBeacon1Rssi = RSSI
            for ad in advertisementData {
                print("AD Data: \(ad)")
            }
        }
        
    }
}
