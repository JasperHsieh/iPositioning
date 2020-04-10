//
//  BleManager.swift
//  iPositioning
//
//  Created by Jasper Hsieh on 4/5/20.
//  Copyright © 2020 Jasper Hsieh. All rights reserved.
//

import Foundation
import CoreBluetooth
import SwiftUI

class BleManager: NSObject, CBCentralManagerDelegate, ObservableObject {
    private var centralManager : CBCentralManager!
    @Published var iBeaconRssi1: NSNumber = 0
    @Published var iBeaconRssi2: NSNumber = 0
    @Published var iBeaconRssi3: NSNumber = 0

    @Published var iBeaconDist1: Decimal = 0
    @Published var iBeaconDist2: Decimal = 0
    @Published var iBeaconDist3: Decimal = 0

    @Published var x: CGFloat = 100.0
    @Published var y: CGFloat = 100.0

    let beacon1 = "myBeacon1"
    let beacon2 = "myBeacon2"
    let beacon3 = "myBeacon3"
    let target = 1

    var beaconFound = 0

    func startScan(){
        print("startScan")
        centralManager = CBCentralManager(delegate: self, queue: nil, options: nil)
        beaconFound = 0

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
        if isOurBeacon(device: peripheral) {
            print("\nName   : \(peripheral.name ?? "(No name)")")
            print("RSSI   : \(RSSI)")
            beaconFound += 1
            if peripheral.name == beacon1 {
                iBeaconRssi1 = RSSI
                iBeaconDist1 = getDistance(rssi: RSSI, txPower: -64)
            } else if peripheral.name == beacon2 {
                iBeaconRssi2 = RSSI
                iBeaconDist2 = getDistance(rssi: RSSI, txPower: -64)
            } else if peripheral.name == beacon3 || peripheral.name == "J_iBcn"{
                iBeaconRssi3 = RSSI
                iBeaconDist3 = getDistance(rssi: RSSI, txPower: -64)
                print("Distance: \(iBeaconDist3)")
    //            for ad in advertisementData {
    //                print("AD Data: \(ad)")
    //            }
            }
            if beaconFound == target {
                // Update location
                print("Found all beacons")
                self.x = self.x + 10
                self.y = self.y + 10
            }
        }
    }

    func isOurBeacon(device: CBPeripheral) -> Bool {
        if device.name == beacon1 || device.name == beacon2 || device.name == beacon3{
            return true
        }
        return false
    }

    func getDistance(rssi: NSNumber, txPower: Int)-> Decimal{
        let tmp1 = -64.0 - Double(truncating: rssi)
        let tmp2 = tmp1 / (10*2)
        //print("\(tmp1) \(tmp2)")
        let distance = Double(round(pow(10, tmp2)*100)/100)
        return Decimal(distance)
    }
}
