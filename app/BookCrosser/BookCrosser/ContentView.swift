//
//  ContentView.swift
//  BookCrosser
//
//  Created by ztursunov on 04.03.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            Text("Azfal qora eshak")
        }
        .padding()
        HStack {
            Text("Serik qora eshak")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
