//
//  SignInView.swift
//  BookCrosser
//
//  Created by ztursunov on 08.04.2023.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject private var authModel: AuthViewModel
    @State private var emailAddress: String = ""
    @State private var password: String = ""
    
    var body: some View {
        NavigationView {
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
                    NavigationLink(destination:  SignUpView().environmentObject(APIService())) {
                        Text("No account? Sign Up").bold()
                    }
                }
                Spacer()
            }
        }
        
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
