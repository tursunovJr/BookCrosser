//
//  SwiftUIView.swift
//  BookCrosser
//
//  Created by ztursunov on 08.04.2023.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView{
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
//                .toolbar(.visible, for: .tabBar)
//                .toolbarBackground(Color.green, for: .tabBar)
            GenreView()
                .tabItem {
                    Label("Genres", systemImage: "square.on.square")
                }
            FavouritesView()
                .tabItem {
                    Label("Favourites", systemImage: "suit.heart.fill")
                }
            ProfileView()
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
