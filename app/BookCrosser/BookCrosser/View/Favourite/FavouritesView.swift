//
//  FavouritesView.swift
//  BookCrosser
//
//  Created by ztursunov on 08.04.2023.
//

import Combine
import SwiftUI

struct FavouritesView: View {
    @EnvironmentObject
    private var authService: AuthService
    @EnvironmentObject
    private var bookService: BookService
    @State
    private var isSignInViewPresented = false
    @State
    var favBooks: [FavBookInfoModel] = []
    @State
    var error: APIServiceError?
    @State
    var cancellables = Set<AnyCancellable>()
    
    var body: some View {
        VStack {
            if self.authService.user != nil {
                NavigationView {
                    VStack(spacing: 0.0) {
                        NavBar()
                        List {
                            ForEach(self.favBooks, id: \.hashValue) { favBook in
                                FavouriteDetailView(uuid: favBook.book_uuid)
                                    .listRowSeparator(.visible)
                            }
                        }
                        Spacer()
                        
                    }
                }
            } else {
                Text("Чтобы увидеть список избранных книг, сначала авторизуйтесь 🙂")
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 20.0)
                Button("Войти или зарегистрироваться") {
                    self.isSignInViewPresented = true
                }
                .sheet(isPresented: self.$isSignInViewPresented) {
                    SignInView()
                }
                .padding(10.0)
                .background(Color.blue) // Add a background color to the button
                .foregroundColor(.white) // Set the text color of the button
                .cornerRadius(10)
            }
                
        }.onAppear {
            self.authService.listenToAuthState()
            self.bookService.getAllFavBooks(email: self.authService.user?.email ?? "")
                .sink { completion in
                    switch completion {
                    case let .failure(error):
                        self.error = error
                    case .finished:
                        break
                    }
                } receiveValue: { favBooks in
                    self.favBooks = favBooks
                }
                .store(in: &self.cancellables)
                
        }
        
    }
}

struct FavouritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavouritesView()
    }
}
