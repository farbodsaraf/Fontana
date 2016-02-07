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
    @IBOutlet weak var hugeDonationButton: UIButton!
    
    override func awakeFromNib() {
        let color = UIColor.fnt_teal()
        smallDonationButton.setTitleColor(color, forState: .Normal)
        mediumDonationButton.setTitleColor(color, forState: .Normal)
        hugeDonationButton.setTitleColor(color, forState: .Normal)
    }

    @IBAction func onSmallDonation(sender: UIButton) {
        donateCellModel().donate(.Coffee)
    }
    
    @IBAction func onMediumDonation(sender: AnyObject) {
        donateCellModel().donate(.Snack)
    }
    
    @IBAction func onHugeDonation(sender: AnyObject) {
        donateCellModel().donate(.Lunch)
    }
    
    internal func donateCellModel() -> DonateCellModel {
        return self.viewModel as! DonateCellModel
    }
}
