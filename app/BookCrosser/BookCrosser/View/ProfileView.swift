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
            HStack {
                Spacer()
                Text("Profile").bold().font(.system(size: 25.0)).foregroundColor(.white).frame(alignment: .center)
                Spacer()
            }
            .frame(height: 50.0)
            .background(Color.blue)
            
            Image(systemName: "figure.arms.open")
                .frame(width: 100.0, height: 100.0, alignment: .center)
                .background(Color.green)
                .cornerRadius(50.0)
                .padding()
            
//            Text("Hello, \(authModel.user?.email ?? "Anonymous guest")")
            Text("Name Surname").font(.title)
            
            SettingsListRowView(model: .init(name: "Personal information")).frame(height: 40.0)
            SettingsListRowView(model: .init(name: "Books")).frame(height: 40.0)
            SettingsListRowView(model: .init(name: "Requests")).frame(height: 40.0)
            SettingsListRowView(model: .init(name: "Reviews")).frame(height: 40.0)
            
            Button {
                authModel.signOut()
            } label: {
                Text("Log Out").bold()
            }
            Spacer()

        }
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
