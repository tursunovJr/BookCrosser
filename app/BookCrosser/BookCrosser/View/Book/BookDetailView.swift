//
//  BookDetailView.swift
//  BookCrosser
//
//  Created by ztursunov on 21.05.2023.
//

import SwiftUI

struct BookDetailView: View {
    @State
    private var selectedButton: Int = 0
    @Environment(\.presentationMode)
    var presentationMode
    @State
    var model: BookInfoModel
    
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
                        HStack{
                        }.frame(height: 10.0)
                    }
                    Spacer()
                }
                .background(Color.blue)
                
                VStack {
                    Text("Жанр: \(self.model.genre)")
                        .font(.caption)
                        .border(.gray)
                    Text(self.model.description)
                        .font(.caption)
                }
                Spacer()
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
            Button(action: {
                // Handle favorite button action
            }) {
                Image(systemName: "heart.fill")
                    .foregroundColor(.white)
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
    
}

struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let bookMock = BookInfoModel.mock()
        BookDetailView(model: bookMock)
    }
}
