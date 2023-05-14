//
//  BookListRowView.swift
//  BookCrosser
//
//  Created by ztursunov on 09.05.2023.
//

import SwiftUI

struct BookListRowView: View {
    @State var model: BookInfoModel
    
    var body: some View {
        VStack {
            Image("book")
                .resizable()
                .frame(width: 96.0, height: 120.0)
            HStack {
                
                Label(String(model.rating), systemImage: "star.fill")
                Label(String(model.city), systemImage: "location.fill")
            }
            Text(model.name)
                .font(Constants.NameText.font)
                .foregroundColor(Constants.NameText.color)
            Text(model.author)
                .font(Constants.DescriptionText.font)
                .foregroundColor(Constants.NameText.color)
        }
        .padding(Constants.Container.padding)
    }
}

extension BookListRowView {
    struct Constants {
        struct Container {
            static let padding: EdgeInsets = EdgeInsets(top: 18,
                                                        leading: 12,
                                                        bottom: 18,
                                                        trailing: 12)
        }
        struct NameText {
            static let font: Font = .title2
            static let color: Color = .black
        }
        
        struct DescriptionText {
            static let font: Font = .caption
            static let color: Color = .black
        }
    }
}


struct BookListRowView_Previews: PreviewProvider {
    static var previews: some View {
        let bookMock: BookInfoModel = BookInfoModel.mock()
        BookListRowView(model: bookMock)
    }
}
