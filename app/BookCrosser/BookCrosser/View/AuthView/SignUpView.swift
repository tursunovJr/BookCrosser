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
            Section {
                Button {
                    authModel.signUp(emailAddress: emailAddress, password: password)
                } label: {
                    Text("SignUp").bold()
                }
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
