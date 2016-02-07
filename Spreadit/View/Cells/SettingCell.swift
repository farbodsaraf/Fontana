//
//  SettingCell.swift
//  Spreadit
//
//  Created by Marko Hlebar on 07/02/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

import UIKit
import BIND

class SettingCell: BNDTableViewCell {
    
    var toggleSwitch: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        toggleSwitch = UISwitch()
        toggleSwitch.addTarget(self, action: "onToggle:", forControlEvents:.ValueChanged)
        toggleSwitch.onTintColor = UIColor.fnt_teal()
        self.accessoryView = toggleSwitch
    }
    
    override func viewDidUpdateViewModel(viewModel: BNDViewModelProtocol!) {
        self.textLabel?.text = settingCellModel().title
        toggleSwitch.on = settingCellModel().settingValue
    }
    
    func settingCellModel() -> SettingCellModel {
        return viewModel as! SettingCellModel
    }
    
    func onToggle(sender: UISwitch) {
        settingCellModel().settingValue = sender.on
    }
}
