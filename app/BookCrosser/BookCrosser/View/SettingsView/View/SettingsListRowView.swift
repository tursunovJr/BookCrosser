//
//  SettingsListRowView.swift
//  BookCrosser
//
//  Created by ztursunov on 16.04.2023.
//

import SwiftUI

struct SettingsListRowView: View {
    @State var model: SettingModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(model.name)
                    .font(.title3)
                    .foregroundColor(.black)
            }
            Spacer()
            Image(systemName: "chevron.right")
        }
        .padding(Constants.padding)
    }
}

extension SettingsListRowView {
    struct Constants {
        static let padding: EdgeInsets = EdgeInsets(top: 18,
                                                    leading: 12,
                                                    bottom: 18,
                                                    trailing: 12)
    }
}

struct SettingsListRowView_Previews: PreviewProvider {
    static var previews: some View {
        let settingMock: SettingModel = SettingModel.mock()
        SettingsListRowView(model: settingMock)
    }
}
