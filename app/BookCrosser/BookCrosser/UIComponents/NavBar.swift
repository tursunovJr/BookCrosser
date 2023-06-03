//
//  NavBar.swift
//  BookCrosser
//
//  Created by ztursunov on 28.05.2023.
//

import SwiftUI

struct NavBar: View {
    @State
    private var searchText = ""
    
    var body: some View {
        /// Строка поиска.
        HStack {
            TextField("Поиск книг, авторов", text: self.$searchText, onCommit: { })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .foregroundColor(.black)
            Button(action: { }) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.white)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal)
        .background(.blue)
    }
}

struct NavBar_Previews: PreviewProvider {
    static var previews: some View {
        NavBar()
    }
}
