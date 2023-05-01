//
//  ProfileView.swift
//  BookCrosser
//
//  Created by ztursunov on 08.04.2023.
//

import Combine
import SwiftUI

struct ProfileView: View {
    @EnvironmentObject
    var authService: AuthService
    @State
    var userInfo: UserInfoModel?
    @State
    var isLoading = false
    @State
    var error: APIServiceError?
    @State
    var cancellables = Set<AnyCancellable>()
    
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
            
            if self.isLoading {
                ProgressView()
            } else if let userInfo = userInfo {
                Text("\(userInfo.name) \(userInfo.surname)").font(.title)
            } else if let error = error {
                Text("Error: \(error.localizedDescription)")
            }
            
            SettingsListRowView(model: .init(name: "Personal information")).frame(height: 40.0)
            SettingsListRowView(model: .init(name: "Books")).frame(height: 40.0)
            SettingsListRowView(model: .init(name: "Requests")).frame(height: 40.0)
            SettingsListRowView(model: .init(name: "Reviews")).frame(height: 40.0)
            
            Button {
                self.authService.signOut()
            } label: {
                Text("Log Out").bold()
            }
            Spacer()
            
        }
        .onAppear {
            self.isLoading = true
            self.authService.getUser()
                .sink { completion in
                    self.isLoading = false
                    switch completion {
                    case let .failure(error):
                        self.error = error
                    case .finished:
                        break
                    }
                } receiveValue: { userInfo in
                    self.userInfo = userInfo
                }
                .store(in: &self.cancellables)
        }
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
