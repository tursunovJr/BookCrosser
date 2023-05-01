//
//  SignUpView.swift
//  BookCrosser
//
//  Created by ztursunov on 17.04.2023.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject
    private var authService: AuthService
    
    @State
    private var name: String = ""
    @State
    private var surname: String = ""
    @State
    private var city: String = ""
    @State
    private var emailAddress: String = ""
    @State
    private var password: String = ""
   
    var body: some View {
        VStack {
            Form {
                Section {
                    TextField("Name", text: self.$name)
                        .textContentType(.name)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                        .keyboardType(.default)
                    TextField("Surname", text: self.$surname)
                        .textContentType(.name)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                        .keyboardType(.default)
                    TextField("City", text: self.$city)
                        .textContentType(.addressCity)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                        .keyboardType(.default)
                    TextField("Email", text: self.$emailAddress)
                        .textContentType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                        .keyboardType(.emailAddress)
                    SecureField("Password", text: self.$password)
                        .textContentType(.password)
                        .keyboardType(.default)
                }
            }
            .frame(height: 350.0)
            .scrollContentBackground(.hidden)
            Button {
                self.authService.signUp(emailAddress: self.emailAddress, password: self.password)
                self.authService.addUserInfo(model: .init(name: self.name,
                                                          surname: self.surname,
                                                          email: self.emailAddress,
                                                          city: self.city))
                
            } label: {
                Text("Sign Up").bold().foregroundColor(.white)
            }
            .frame(width: 125.0, height: 40.0)
            .background(
                RoundedRectangle(
                    cornerRadius: 20,
                    style: .continuous
                )
                .fill(.orange)
            )
            Spacer()
        }
        .navigationBarBackButtonHidden(false)
        .navigationTitle("Registration")
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
