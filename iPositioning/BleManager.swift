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
    @Published var iBeaconRssi1: NSNumber = 0
    @Published var iBeaconDist1: Decimal = 0
    @Published var iBeaconRssi2: NSNumber = 0
    @Published var iBeaconDist2: Decimal = 0
    @Published var iBeaconRssi3: NSNumber = 0
    @Published var iBeaconDist3: Decimal = 0

    let beacon1 = "myBeacon1"
    let beacon2 = "myBeacon2"
    let beacon3 = "myBeacon3"
    
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
        if peripheral.name == beacon1 {
            print("\nName   : \(peripheral.name ?? "(No name)")")
            print("RSSI   : \(RSSI)")
            iBeaconRssi1 = RSSI
            iBeaconDist1 = getDistance(rssi: RSSI, txPower: 0)
        } else if peripheral.name == beacon2 {
            print("\nName   : \(peripheral.name ?? "(No name)")")
            print("RSSI   : \(RSSI)")
            iBeaconRssi2 = RSSI
            iBeaconDist2 = getDistance(rssi: RSSI, txPower: 0)
        } else if peripheral.name == beacon3 || peripheral.name == "J_iBcn"{
            print("\nName   : \(peripheral.name ?? "(No name)")")
            print("RSSI   : \(RSSI)")
            iBeaconRssi3 = RSSI
            iBeaconDist3 = getDistance(rssi: RSSI, txPower: 0)
//            for ad in advertisementData {
//                print("AD Data: \(ad)")
//            }
        }
        
//        if peripheral.name == "pBeacon_n" || peripheral.name == "J_iBcn" {
//            print("\nName   : \(peripheral.name ?? "(No name)")")
//            print("RSSI   : \(RSSI)")
//            iBeaconRssi1 = RSSI
//            iBeaconDist1 = getDistance(rssi: RSSI, txPower: 0)
//            for ad in advertisementData {
//                print("AD Data: \(ad)")
//            }
//        }
    }

    func getDistance(rssi: NSNumber, txPower: Int)-> Decimal{
        let distance = pow(10, ((txPower-Int(truncating: rssi)) / 10*2))
        return distance
    }
}
