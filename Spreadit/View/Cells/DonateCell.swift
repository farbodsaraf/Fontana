//
//  DonateCell.swift
//  Spreadit
//
//  Created by Marko Hlebar on 04/02/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

import UIKit
import BIND

class DonateCell: BNDTableViewCell {
    
    @IBOutlet weak var smallDonationButton: UIButton!
    @IBOutlet weak var mediumDonationButton: UIButton!
    @IBOutlet weak var bigDonationButton: UIButton!
    
    
    @IBAction func onSmallDonation(sender: UIButton) {
        donateCellModel().donate(.Coffee)
    }
    
    @IBAction func onMediumDonation(sender: AnyObject) {
        donateCellModel().donate(.Snack)
    }
    
    @IBAction func onHugeDonation(sender: AnyObject) {
        donateCellModel().donate(.Lunch)
    }
    
    func donateCellModel() -> DonateCellModel {
        return self.viewModel as! DonateCellModel
    }
}
