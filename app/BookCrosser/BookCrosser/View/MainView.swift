//
//  SwiftUIView.swift
//  BookCrosser
//
//  Created by ztursunov on 08.04.2023.
//

import SwiftUI

struct MainView: View {
    @StateObject
    var bookService = BookService()
    @StateObject
    var genreService = GenreService()
    @StateObject
    var authService = AuthService()
    
    var body: some View {
        TabView {
            HomeView()
                .environmentObject(self.bookService)
                .environmentObject(self.authService)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            GenreView()
                .environmentObject(self.genreService)
                .environmentObject(self.bookService)
                .tabItem {
                    Label("Genres", systemImage: "square.on.square")
                }
            FavouritesView()
                .environmentObject(self.authService)
                .environmentObject(self.bookService)
                .tabItem {
                    Label("Favourites", systemImage: "suit.heart.fill")
                }
            ProfileView()
                .environmentObject(self.bookService)
                .environmentObject(self.authService)
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
                
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
