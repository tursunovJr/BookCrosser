//
//  BookHistoryView.swift
//  BookCrosser
//
//  Created by ztursunov on 04.06.2023.
//

import SwiftUI
import Combine

struct BookHistoryView: View {
    @State
    var chain: [ChainModel]
    
    var body: some View {
        VStack {
            List {
                ForEach(self.chain, id: \.timestamp) { chain in
                    HStack {
                        Text(self.getLastOwner(transactions: chain.transactions))
                            .foregroundColor(.black)
                            .font(.title2)
                        Spacer()
                    }
                }
            }
        }
    }
    
    func getLastOwner(transactions: String?) -> String {
        guard let transactions else { return "" }
        let cleanedString = transactions.replacingOccurrences(of: "['\\(\\)]", with: "", options: .regularExpression)

        // Split string by comma and trim whitespace
        let elements = cleanedString.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }

        return elements[1]
    }
}

struct BookHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        BookHistoryView(chain: [])
    }
}
