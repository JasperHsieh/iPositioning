//
//  ContentView.swift
//  iPositioning
//
//  Created by Jasper Hsieh on 4/5/20.
//  Copyright © 2020 Jasper Hsieh. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var bleManager: BleManager
    var body: some View {
        VStack{
            Text("Beacon 1")
            Text("RSSI: \(bleManager.iBeaconRssi1.stringValue)")
            Text("Distance: \(NSDecimalNumber(decimal: bleManager.iBeaconDist1).stringValue)")
            Text("Beacon 2")
            Text("RSSI: \(bleManager.iBeaconRssi2.stringValue)")
            Text("Distance: \(NSDecimalNumber(decimal: bleManager.iBeaconDist2).stringValue)")
            Text("Beacon 3")
            Text("RSSI: \(bleManager.iBeaconRssi3.stringValue)")
            Text("Distance: \(NSDecimalNumber(decimal: bleManager.iBeaconDist3).stringValue)")
            Button(action: {
                print("Click Scan")
                self.bleManager.startScan()
            }){
                Text("Scan")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
