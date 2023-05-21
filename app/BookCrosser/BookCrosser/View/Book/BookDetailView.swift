//
//  BookDetailView.swift
//  BookCrosser
//
//  Created by ztursunov on 21.05.2023.
//

import SwiftUI

struct BookDetailView: View {
    @State
    var model: BookInfoModel
    
    var body: some View {
        VStack {
            
        }
        .navigationTitle("back")
        .navigationBarBackButtonHidden(true)
        
        HStack {
            Spacer()
            VStack {
                Image("book")
                    .resizable()
                    .frame(width: 127.0, height: 147.0)
                Text(self.model.name)
                    .font(.title3)
                    .foregroundColor(.white)
                Text(self.model.author)
                    .font(.footnote)
                    .foregroundColor(.gray)
                HStack {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 25.0, height: 25.0)
                        .foregroundColor(.white)
                    Text("Савелий")
                        .font(.title3)
                        .foregroundColor(.white)
                }
            }
            Spacer()
        }
        .frame(height: 350.0)
        .background(.blue)
        VStack {
            Text("Жанр: \(self.model.genre)")
                .font(.caption)
                .border(.gray)
            Text(self.model.description)
                .font(.caption)
        }
    }
}

struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let bookMock = BookInfoModel.mock()
        BookDetailView(model: bookMock)
    }
}
