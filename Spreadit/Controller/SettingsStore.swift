//
//  Settings.swift
//  Spreadit
//
//  Created by Marko Hlebar on 07/02/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

import UIKit
import KeychainSwift

let settingsDictionaryKey = "com.fontanakey.settings"

enum Settings: String {
    case OptionalMarkup = "com.fontanakey.settings.optionalMarkup"
}

class SettingsStore: NSObject {

    static let sharedSettings = SettingsStore()
    let keychain: KeychainSwift
    
    override init() {
        keychain = KeychainSwift()
    }
    
    func read(setting: Settings) -> Bool {
        return read(setting.rawValue)
    }
    
    func write(value: Bool, setting: Settings) {
        write(value, key: setting.rawValue)
    }
    
    func read(key: String) -> Bool {
        if let value = settingsDictionary[key] {
            return NSString(string: value).boolValue
        } else {
            return false
        }
    }
    
    private func write(value: Bool, key: String){
        settingsDictionary[key] = boolToString(value)
        
        let data = NSKeyedArchiver.archivedDataWithRootObject(settingsDictionary)
        keychain.set(data, forKey: settingsDictionaryKey)
    }
    
    private lazy var settingsDictionary: [String:String] = {
        [unowned self] in
        if let data = self.keychain.getData(settingsDictionaryKey) {
            return NSKeyedUnarchiver.unarchiveObjectWithData(data)!.mutableCopy() as! [String:String]
        }
        else {
            return self.defaultSettings()
        }
    }()
    
    private func defaultSettings() -> [String:String]{
        return [
            Settings.OptionalMarkup.rawValue: "true"
        ]
    }
    
    private func boolToString(value: Bool?) -> String {
        guard let value = value else {
            return "<None>"
        }
        
        return "\(value)"
    }
}
