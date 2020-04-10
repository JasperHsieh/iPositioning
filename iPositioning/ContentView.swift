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
    @State var x: CGFloat = 100.0
    @State var y: CGFloat = 100.0

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Image("Beacon")
                    .resizable()
                    .frame(width: 50.0, height: 50.0)
                Spacer()
                Circle()
                    .fill(Color.green)
                    .frame(width: 20.0, height: 20.0)
                    .position(x: x, y: y)
                HStack{
                    Image("Beacon")
                        .resizable()
                        .frame(width: 50.0, height: 50.0)
                    Spacer()
                    Image("Beacon")
                        .resizable()
                        .frame(width: 50.0, height: 50.0)
                }
            }
            .frame(width: roomWidth, height: roomLength)
            .background(colorScheme == .dark ? Color.white : Color.black)
            .coordinateSpace(name: "Custom")

            Text("Beacon 1 : (\(bleManager.iBeaconRssi1.stringValue), \(NSDecimalNumber(decimal: bleManager.iBeaconDist1).stringValue) m)")
            Text("Beacon 2 : (\(bleManager.iBeaconRssi2.stringValue), \(NSDecimalNumber(decimal: bleManager.iBeaconDist2).stringValue) m)")
            Text("Beacon 3 : (\(bleManager.iBeaconRssi3.stringValue), \(NSDecimalNumber(decimal: bleManager.iBeaconDist3).stringValue) m)")
            Button(action: {
                print("Click Scan")
                self.bleManager.startScan()
                self.x = self.x + 10
                self.y = self.y + 10
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
