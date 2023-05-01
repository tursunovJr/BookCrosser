//
//  ContentView.swift
//  BookCrosser
//
//  Created by ztursunov on 08.04.2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject
    private var authModel: AuthService
    
    var body: some View {
        Group {
            if self.authModel.user != nil {
                MainView()
            } else {
                SignInView()
            }
        }.onAppear {
            self.authModel.listenToAuthState()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
