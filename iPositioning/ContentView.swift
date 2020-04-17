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
    @Environment(\.colorScheme) var colorScheme
    var roomWidth: CGFloat = 300.0
    var roomLength: CGFloat = 500.0

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Image("b2")
                    .resizable()
                    .frame(width: 50.0, height: 50.0)
                Spacer()
                Circle()
                    .fill(Color.green)
                    .frame(width: 20.0, height: 20.0)
                    .position(x: bleManager.x, y: bleManager.y)
                HStack{
                    Image("b1")
                        .resizable()
                        .frame(width: 50.0, height: 50.0)
                    Spacer()
                    Image("b3")
                        .resizable()
                        .frame(width: 50.0, height: 50.0)
                }
            }
            .frame(width: roomWidth, height: roomLength)
            .background(colorScheme == .dark ? Color.white : Color.black)
            .coordinateSpace(name: "Custom")

            Text("Beacon 1 : (\(bleManager.iBeaconRssi1.stringValue), \(bleManager.iBeaconDist1) m")
            Text("Beacon 2 : (\(bleManager.iBeaconRssi2.stringValue), \(bleManager.iBeaconDist2) m")
            Text("Beacon 3 : (\(bleManager.iBeaconRssi3.stringValue), \(bleManager.iBeaconDist3) m")
            Button(action: {
                print("Click Scan")
                self.bleManager.startScan()

            }){
                Text("Scan")
            }.padding()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
