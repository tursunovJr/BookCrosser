//
//  ProfileView.swift
//  BookCrosser
//
//  Created by ztursunov on 08.04.2023.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var authModel: AuthViewModel
    
    var body: some View {
        VStack {
            Text("Hello, \(authModel.user?.email ?? "Anonymous guest")")
            Button {
                authModel.signOut()
            } label: {
                Text("Log Out").bold()
            }

        }
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
