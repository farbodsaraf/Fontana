//
//  DonateCellModel.swift
//  Spreadit
//
//  Created by Marko Hlebar on 04/02/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

import UIKit

class DonateCellModel: TableRowViewModel {

    override func cellHeight() -> CGFloat {
        return 176
    }
    
    override func identifier() -> String! {
        return "DonateCell"
    }
    
    func donate(donation: Donation) {
        DonationStore.defaultStore.buy(donation, completion: {
            (donation: Donation) in
            DonationJar.defaultJar.addDonation(donation)
        })
    }
}
