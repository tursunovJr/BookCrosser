//
//  GenreDetailView.swift
//  BookCrosser
//
//  Created by ztursunov on 28.05.2023.
//

import SwiftUI

struct GenreDetailView: View {
    let model: GenreInfoModel
    
    var body: some View {
        VStack {
            Text("Genre: \(self.model.name)")
                .font(.title)
                .padding()
                    
            Text("UUID: \(self.model.uuid)")
                .font(.headline)
                .foregroundColor(.gray)
        }
    }
}

struct GenreDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let genreMock = GenreInfoModel.mock()
        GenreDetailView(model: genreMock)
    }
}
