//
//  BookListRowView.swift
//  BookCrosser
//
//  Created by ztursunov on 09.05.2023.
//

import SwiftUI

struct BookListRowView: View {
    @State
    var model: BookInfoModel
    
    var body: some View {
        NavigationLink(destination: BookDetailView(model: model,
                                                   state: model.state)) {
            VStack {
                Image(self.model.image)
                    .resizable()
                    .frame(width: 76.0, height: 100.0)
                HStack {
                    Spacer()
                    Image(systemName: "star.fill")
                        .resizable()
                        .frame(width: 11.0, height: 11.0)
                        .foregroundColor(.orange)
                        .padding(.leading, 2.0)
                    Text(String(self.model.rating))
                        .font(.custom("Custom", size: 9.0))
                        .foregroundColor(.white)
                        .padding(.leading, -6.0)
                        
                    Image(systemName: "location.fill")
                        .resizable()
                        .frame(width: 11.0, height: 11.0)
                        .foregroundColor(.orange)
                    Text(String(self.model.city))
                        .font(.custom("Custom", size: 9.0))
                        .foregroundColor(.white)
                        .padding(.leading, -6.0)
                    Spacer()
                }
                .background(.blue)
                .frame(width: 114.0, height: 15.0)
                Text(self.model.name)
                    .font(Constants.NameText.font)
                    .foregroundColor(Constants.NameText.color)
                    .bold()
                    .padding(.top, -5.0)
                Text(self.model.author)
                    .font(Constants.DescriptionText.font)
                    .foregroundColor(Constants.NameText.color)
            }
            .frame(width: 114.0, height: 179.0)
            .border(.gray)
            .padding(Constants.Container.padding)
        }
    }
}

// MARK: - BookListRowView.Constants

extension BookListRowView {
    struct Constants {
        struct Container {
            static let padding: EdgeInsets = .init(top: 18,
                                                   leading: 12,
                                                   bottom: 18,
                                                   trailing: 12)
        }

        struct NameText {
            static let font: Font = .callout
            static let color: Color = .black
        }
        
        struct DescriptionText {
            static let font: Font = .footnote
            static let color: Color = .black
        }
    }
}

struct BookListRowView_Previews: PreviewProvider {
    static var previews: some View {
        let bookMock = BookInfoModel.mock()
        BookListRowView(model: bookMock)
    }
}
