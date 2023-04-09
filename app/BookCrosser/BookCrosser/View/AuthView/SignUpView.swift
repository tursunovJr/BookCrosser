//
//  SignUpView.swift
//  BookCrosser
//
//  Created by ztursunov on 08.04.2023.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject private var authModel: AuthViewModel
    @State private var emailAddress: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Authorization").bold().font(.system(size: 25.0)).foregroundColor(.white)
                Spacer()
            }
            .frame(height: 50.0)
            .background(Color.blue)
            
            Form {
                Section {
                    TextField("Email", text: $emailAddress)
                        .textContentType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                        .keyboardType(.emailAddress)
                    SecureField("Password", text: $password)
                        .textContentType(.password)
                        .keyboardType(.default)
                }
            }
            .frame(height: 150.0)
            .scrollContentBackground(.hidden)
            
            VStack {
                Button {
                    authModel.signIn(emailAddress: emailAddress, password: password)
                } label: {
                    Text("Sign In").bold().foregroundColor(.white)
                }
                .frame(width: 125.0, height: 40.0)
                .background(
                    RoundedRectangle(
                        cornerRadius: 20,
                        style: .continuous
                    )
                    .fill(.green)
                )
                Spacer().frame(height: 50.0)
                Text("No account? Sign Up")
                    .bold()
                    .frame(alignment: .center)
                    .font(.system(size: 25.0))
                Spacer().frame(height: 25.0)
                Button {
                    authModel.signUp(emailAddress: emailAddress, password: password)
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
            }
            Spacer()
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
