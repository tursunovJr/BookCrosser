//
//  BookDetailView.swift
//  BookCrosser
//
//  Created by ztursunov on 21.05.2023.
//

import SwiftUI

struct BookDetailView: View {
    @EnvironmentObject
    var authService: AuthService
    
    @EnvironmentObject
    var bookService: BookService
    
    @State
    private var selectedButton: Int = 0
    
    @State
    private var isFavorite = false
    
    @Environment(\.presentationMode)
    var presentationMode
    
    @State
    var model: BookInfoModel
    
    struct Review: Identifiable {
        let id = UUID()
        let comment: String
        let author: String
    }
        
    let reviews: [Review] = [
        Review(comment: "Great book!", author: "John Doe"),
        Review(comment: "Highly recommended!", author: "Jane Smith"),
        Review(comment: "Loved it!", author: "Alex Johnson")
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0.0) {
                HStack {
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 3.0)
                .background(Color.blue)
                
                HStack {
                    Spacer()
                    VStack {
                        self.bookInfo
                        self.geoAndAvailableButton
                        self.stars
                        self.buttons
                        HStack { }.frame(height: 10.0)
                    }
                    Spacer()
                }
                .background(Color.blue)
                
                if self.selectedButton == 0 {
                    self.bookDescription
                } else if self.selectedButton == 1 {
                    self.bookReviews
                } else if self.selectedButton == 2 {
                    self.bookHistory
                }
                
                Spacer()
            }
            .onAppear {
                self.authService.listenToAuthState()
            }
        }
        .navigationBarItems(leading: self.backButton, trailing: self.actionsButtons)
        .navigationBarBackButtonHidden(true)
    }
    
    private var backButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "arrow.left")
                .foregroundColor(.white)
        }
    }
    
    private var actionsButtons: some View {
        HStack {
            if self.authService.user != nil {
                Button(action: {
                    if self.isFavorite {
                        self.bookService.delFavBook(email: self.authService.user?.email ?? "",
                                                    book_uuid: self.model.uuid)
                    } else {
                        self.bookService.addFavBook(email: self.authService.user?.email ?? "",
                                                    book_uuid: self.model.uuid)
                    }
                    self.isFavorite.toggle()
                }) {
                    Image(systemName: self.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(self.isFavorite ? .red : .white)
                }
            }
            Button(action: {
                self.shareBook()
            }) {
                Image(systemName: "square.and.arrow.up")
                    .foregroundColor(.white)
            }
        }
    }
    
    private func shareBook() {
        // Create an instance of UIActivityViewController
        let activityViewController = UIActivityViewController(activityItems: ["Shared Book: \(self.model.name)"], applicationActivities: nil)
        
        // Present the UIActivityViewController
        UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
    }
    
    var bookInfo: some View {
        VStack {
            Image("book")
                .resizable()
                .frame(width: 127.0, height: 167.0)
            Text(self.model.name)
                .font(.title3)
                .foregroundColor(.white)
            Text(self.model.author)
                .font(.footnote)
                .foregroundColor(.white)
                .padding(.top, 1.0)
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
    }

    var geoAndAvailableButton: some View {
        HStack {
            HStack {
                Spacer(minLength: 15.0)
                Image(systemName: "location.circle")
                    .resizable()
                    .frame(width: 25.0, height: 25.0)
                    .foregroundColor(.orange)
                Text(self.model.city)
                    .font(.title3)
                    .foregroundColor(.white)
                Spacer(minLength: 15.0)
            }
            .frame(height: 45.0)
            .cornerRadius(5.0)
                
            HStack {
                Spacer(minLength: 15.0)
                Button("Запросить") {
                    print("Запросить")
                }
                .foregroundColor(.white)
                .frame(height: 45.0)
                Spacer(minLength: 15.0)
            }
            .background(Color.orange)
            .frame(height: 45.0)
            .cornerRadius(5.0)
        }
        .background(Color(.init(white: 1.0, alpha: 0.22)))
        .frame(height: 45.0)
        .cornerRadius(5.0)
    }
    
    var stars: some View {
        HStack(spacing: 4) {
            ForEach(0 ..< 5) { index in
                Image(systemName: index < Int(self.model.rating) ? "star.fill" : "star")
                    .foregroundColor(.yellow)
                    .font(.system(size: 15))
            }
            Text(String(self.model.rating))
                .foregroundColor(.white)
                .font(.custom("Custom", size: 15.0))
                .padding(.leading, 10.0)
        }
    }
    
    var buttons: some View {
        HStack(spacing: 16) {
            Button(action: {
                self.selectedButton = 0
            }) {
                Text("О КНИГЕ")
                    .foregroundColor(self.selectedButton == 0 ? .orange : .white)
                    .padding()
                    .font(.custom("Custom", size: 15.0))
                    .background(self.selectedButton == 0 ? Color.white : Color(.init(white: 1.0, alpha: 0.22)))
                    .cornerRadius(5)
            }
                    
            Button(action: {
                self.selectedButton = 1
            }) {
                Text("ОТЗЫВЫ")
                    .foregroundColor(self.selectedButton == 1 ? .orange : .white)
                    .padding()
                    .font(.custom("Custom", size: 15.0))
                    .background(self.selectedButton == 1 ? Color.white : Color(.init(white: 1.0, alpha: 0.22)))
                    .cornerRadius(5)
            }
                    
            Button(action: {
                self.selectedButton = 2
            }) {
                Text("ВЛАДЕЛЬЦЫ")
                    .foregroundColor(self.selectedButton == 2 ? .orange : .white)
                    .padding()
                    .font(.custom("Custom", size: 15.0))
                    .background(self.selectedButton == 2 ? Color.white : Color(.init(white: 1.0, alpha: 0.22)))
                    .cornerRadius(5)
            }
        }
    }
    
    var bookDescription: some View {
        ScrollView {
            Text("Жанр: \(self.model.genre)")
                .font(.title3)
                .bold()
            Text("""
                Классический роман Брэдбери с автобиографической основой, вошедший в золотой фонд мировой литературы. Трогательная история о детстве и взрослении, мечтах и безграничных возможностях, юношеском максимализме, счастье, разрушительности войны, страхе потерять близких, дружбе, единении.
                """)
            .font(.title3)
        }
    }
    
    var bookReviews: some View {
        List(self.reviews) { review in
            VStack(alignment: .leading) {
                Text(review.comment)
                    .font(.headline)
                Text("By \(review.author)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
    
    var bookHistory: some View {
        Text("Book History")
            .bold()
            .font(.title3)
    }
    
}

struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let bookMock = BookInfoModel.mock()
        BookDetailView(model: bookMock)
    }
}
