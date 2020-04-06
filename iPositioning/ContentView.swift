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
            Text(bleManager.iBeacon1Rssi.stringValue)
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
