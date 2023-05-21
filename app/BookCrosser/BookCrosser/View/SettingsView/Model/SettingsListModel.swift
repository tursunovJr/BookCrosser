//
//  SettingsListModel.swift
//  BookCrosser
//
//  Created by ztursunov on 16.04.2023.
//

import Foundation

struct SettingModel {
    let name: String
}

extension SettingModel {

    static func mock() -> SettingModel {
        .init(name: "Мои книги")
    }
}
