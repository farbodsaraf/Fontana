//
//  OptionCellModel.swift
//  Spreadit
//
//  Created by Marko Hlebar on 07/02/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

import UIKit

class SettingCellModel: TableRowViewModel {
    
    let settingKey: Settings
    let title: String
    
    var settingValue: Bool {
        set {
            SettingsStore.sharedSettings.write(newValue, setting:settingKey)
        }
        get {
            return SettingsStore.sharedSettings.read(settingKey)
        }
    }
    
    required init(title: String, setting: Settings) {
        self.settingKey = setting
        self.title = title
        super.init(model: title)
    }
    
    override func identifier() -> String! {
        return "SettingCell"
    }
}
