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
    var centralManager : CBCentralManager!
    @Published var iBeaconRssi1: NSNumber = 0
    @Published var iBeaconRssi2: NSNumber = 0
    @Published var iBeaconRssi3: NSNumber = 0

    @Published var iBeaconDist1: Double = 0
    @Published var iBeaconDist2: Double = 0
    @Published var iBeaconDist3: Double = 0

    @Published var x: CGFloat = 0
    @Published var y: CGFloat = 0

    let roomWidth: Double = 3.8 // m
    let roomLength: Double = 6.4 // m
    var width: CGFloat = 300  // fixed
    var length: CGFloat = 500

    let beacon1 = "myBeacon1"
    let beacon2 = "myBeacon2"
    let beacon3 = "myBeacon3"
    let target = 3
    let scan = 10

    var timerCount = 0
    var beaconFound = 0

    var distances1: [Double] = []
    var distances2: [Double] = []
    var distances3: [Double] = []

    let offset1 = 1.0
    let offset2 = 1.0
    let offset3 = 1.0

    public override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil, options: nil)
        length = CGFloat(Double(width) * (roomLength / roomWidth))
    }

    func startScan(){
        print("startScan")
        //centralManager.scanForPeripherals(withServices: nil, options: nil)
        beaconFound = 0
        reset()
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { timer in
            print("timerCount \(self.timerCount)")
            self.scanInBackground()
            self.timerCount += 1
            if self.timerCount == self.scan {
                timer.invalidate()
                //usleep(1000000)
                self.updateDistance()
            }
        }
    }

    func reset() {
        timerCount = 0
        iBeaconRssi1 = 0
        iBeaconRssi2 = 0
        iBeaconRssi3 = 0
        iBeaconDist1 = 0
        iBeaconDist2 = 0
        iBeaconDist3 = 0
        distances1 = []
        distances2 = []
        distances3 = []
    }

    func updateDistance() {
        print("updateDistance")
        iBeaconDist1 = calculateMedian(array: distances1) + offset1
        iBeaconDist2 = calculateMedian(array: distances2) + offset2
        iBeaconDist3 = calculateMedian(array: distances3) + offset3
        //print("distances1 \(distances1), median: \(iBeaconDist1)")
        //print("distances2 \(distances2), median: \(iBeaconDist2)")
        //print("distances3 \(distances3), median: \(iBeaconDist3)")
        print("(d1, d2, d3) = (\(iBeaconDist1), \(iBeaconDist2), \(iBeaconDist3))")
        updatePosition()
    }

    func updatePosition() {
        if iBeaconDist1 + iBeaconDist2 < roomLength {
            print("d1 or d2 not valid (d1, d2, l) = (\(iBeaconDist1), \(iBeaconDist2), \(roomLength))")
            return
        }
        if iBeaconDist1 + iBeaconDist3 < roomWidth {
            print("d1 or d3 not valid (d1, d3, l) = (\(iBeaconDist1), \(iBeaconDist3), \(roomWidth))")
            return
        }
        let coords = getCoordinates(width: roomWidth, length: roomLength, d1: iBeaconDist1, d2: iBeaconDist2, d3: iBeaconDist3)
        print("coords \(coords)")
        x = convertToSceenUnit(meter: coords[0])
        y = convertToSceenUnit(meter: coords[1])
        print("(x,y)=(\(x),\(y)")
        if x > width {
            x = width
        }
        if y > length {
            y = length
        }
        if x.isNaN {
            x = 0.0
        }
        if y.isNaN {
            y = 0.0
        }
    }

    func convertToSceenUnit(meter: Double) -> CGFloat{
        let len = meter * (Double(width) / roomWidth)
        return CGFloat(len)
    }

    func scanInBackground() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.centralManager.scanForPeripherals(withServices: nil, options: nil)
            DispatchQueue.main.async {

            }
        }
    }

    func calculateMedian(array: [Double]) -> Double {
        if array.isEmpty {
            print("Empty array")
            return 0
        }
        let sorted = array.sorted()
        if sorted.count % 2 == 0 {
            return Double((sorted[(sorted.count / 2)] + sorted[(sorted.count / 2) - 1])) / 2
        } else {
            return Double(sorted[(sorted.count - 1) / 2])
        }
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("centralManagerDidUpdateState")
        if central.state == .poweredOn {
            print("Bluetooth is On")
            //centralManager.scanForPeripherals(withServices: nil, options: nil)
        } else {
            print("Bluetooth is not active")
        }
    }
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if isOurBeacon(device: peripheral) {
            print("\nName   : \(peripheral.name ?? "(No name)")")
            print("RSSI   : \(RSSI)")
            let dist = getDistance(rssi: RSSI, txPower: -64)
            print("Distance: \(dist)")
            beaconFound += 1

            if peripheral.name == beacon1 {
                iBeaconRssi1 = RSSI
                //iBeaconDist1 = dist
                distances1.append(dist)

            } else if peripheral.name == beacon2 {
                iBeaconRssi2 = RSSI
                //iBeaconDist2 = dist
                distances2.append(dist)
            } else if peripheral.name == beacon3 || peripheral.name == "J_iBcn"{
                iBeaconRssi3 = RSSI
                //iBeaconDist3 = dist
                distances3.append(dist)
            }
//            if beaconFound == target {
//                // Update location
//                print("Found all beacons")
//                var coords = getCoordinates(width: roomWidth, length: roomLength, d2: iBeaconDist2, d3: iBeaconDist3, d1: iBeaconDist1)
//                print("(\(coords[0]), \(coords[1]))")
//
//            }
        }
    }

    func isOurBeacon(device: CBPeripheral) -> Bool {
        if device.name == beacon1 || device.name == beacon2 || device.name == beacon3{
            return true
        }
        return false
    }

    func getDistance(rssi: NSNumber, txPower: Int)-> Double{
        let tmp1 = -64.0 - Double(truncating: rssi)
        let tmp2 = tmp1 / (10*2)
        //print("\(tmp1) \(tmp2)")
        let distance = Double(round(pow(10, tmp2)*100)/100)
       // return Decimal(distance)
        return distance
    }
    
//    func getCoordinates(width: Double, length: Double, d2 a: Double, d3 b: Double, d1 c: Double) -> [Double] {
//        print(width, length, a, b, c)
//
//        let p1 = (length + a + c) / 2.0
//        let s1 = sqrt(p1 * (p1 - a) * (p1 - c) * (p1 - length))
//        let h1 = 2.0 * s1 / length
//        let y = sqrt(c * c -  h1 * h1)
//        print("p1:\(p1) s1:\(s1) h1:\(h1) y:\(y)")
//
//        let p2 = (width + b + c) / 2.0
//        let s2 = sqrt(p2 * (p2 - b) * (p2 - c) * (p2 - width))
//        let h2 = 2.0 * s2 / width
//        let x = sqrt(c * c - h2 * h2)
//        print("p2:\(p2) s2:\(s2) h2:\(h2) x:\(x)")
//        return [x, y]
//    }

    func getCoordinates(width: Double, length: Double, d1: Double, d2: Double, d3: Double) -> [Double]{
        let p1 = (length + d1 + d2) / 2.0
        let s1 = sqrt(p1 * (p1 - d1) * (p1 - d2) * (p1 - length))
        let h1 = (2.0 * s1) / length
        let y = sqrt(d2 * d2 - h1 * h1)

        let p2 = (width + d1 + d3) / 2.0
        let s2 = sqrt(p2 * (p2 - d1) * (p2 - d3) * (p2 - width))
        let h2 = (2.0 * s2) / width
        let x = sqrt(d1 * d1 - h2 * h2)

        return [x, y]
    }
}
