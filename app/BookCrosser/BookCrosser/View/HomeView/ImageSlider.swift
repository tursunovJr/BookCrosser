//
//  ImageSlider.swift
//  BookCrosser
//
//  Created by ztursunov on 21.05.2023.
//

import SwiftUI

struct ImageSlider: View {
    private let images = ["lib1", "lib2", "lib3", "lib4"]
    
    var body: some View {
        TabView {
            ForEach(images, id: \.self) {
                Image($0)
                    .resizable()
                    .scaledToFill()
            }
        }
        .tabViewStyle(PageTabViewStyle())
    }
}

struct ImageSlider_Previews: PreviewProvider {
    static var previews: some View {
        ImageSlider()
            .previewLayout(.fixed(width: 400.0, height: 300.0))
    }
}
