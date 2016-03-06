//
//  DonateCell.swift
//  Spreadit
//
//  Created by Marko Hlebar on 04/02/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

import UIKit
import BIND
import TTTAttributedLabel

class DonateCell: BNDTableViewCell {
    
    @IBOutlet weak var smallDonationButton: UIButton!
    @IBOutlet weak var mediumDonationButton: UIButton!
    @IBOutlet weak var hugeDonationButton: UIButton!
    @IBOutlet weak var label: TTTAttributedLabel!
    
    var currentActivityIndicator: UIActivityIndicatorView?
    var currentDonationButton: UIButton?

    override func awakeFromNib() {
        configureDonationButton(smallDonationButton)
        configureDonationButton(mediumDonationButton)
        configureDonationButton(hugeDonationButton)
        subscribeToNotifications()
    }
    
    func subscribeToNotifications() {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        
        notificationCenter.addObserver(self, selector: "updateDonationButtons", name: DonationStoreDidUpdateProductsNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: "enableDonationButtons", name: DonationStoreDidFinishPurchaseNotification, object: nil)
    }
    
    func configureDonationButton(button: UIButton) {
        let tealColor = UIColor.fnt_teal()
        let yellowColor = UIColor.fnt_yellow()
        let grayColor = UIColor.grayColor()

        button.setTitleColor(tealColor, forState: .Normal)
        button.setTitleColor(yellowColor, forState: .Highlighted)
        button.setTitleColor(grayColor, forState: .Disabled)

        let titleLabel = button.titleLabel!
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .Center
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    @IBAction func onDonation(sender: UIButton) {
        disableDonationButtons()
        startSpinner(sender)
        
        if let donation = donationForTag(sender.tag) {
            donateCellModel().donate(donation)
        }
        else {
            assert(false)
        }
    }
    
    func donationForTag(tag: Int) -> Donation? {
        switch tag {
            case 1:return .Coffee
            case 2:return .Snack
            case 3:return .Lunch
            default:return nil
        }
    }
    
    func startSpinner(button: UIButton) {
        currentDonationButton = button
        
        if let activityIndicator = currentActivityIndicator {
            activityIndicator.removeFromSuperview()
        }
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        activityIndicator.center = button.center
        activityIndicator.startAnimating()
    
        self.addSubview(activityIndicator)
        currentActivityIndicator = activityIndicator;

        currentDonationButton!.hidden = true
    }
    
    override func viewDidUpdateViewModel(viewModel: BNDViewModelProtocol!) {
        label.setText(donateCellModel().donateText)
        label.delegate = self.donateCellModel();
        updateDonationButtons()
    }
    
    func updateDonationButtons() {
        updateDonationButton(smallDonationButton, donation: Donation.Coffee)
        updateDonationButton(mediumDonationButton, donation: Donation.Snack)
        updateDonationButton(hugeDonationButton, donation: Donation.Lunch)
    }
    
    func disableDonationButtons() {
        setDonationButtonsEnabled(false)
    }
    
    func enableDonationButtons() {
        setDonationButtonsEnabled(true)
        
        currentActivityIndicator?.stopAnimating()
        currentDonationButton?.hidden = false
        currentDonationButton = nil
    }
    
    private func setDonationButtonsEnabled(enabled: Bool) {
        smallDonationButton.enabled = enabled
        mediumDonationButton.enabled = enabled
        hugeDonationButton.enabled = enabled
    }
    
    private func donateCellModel() -> DonateCellModel {
        return self.viewModel as! DonateCellModel
    }
    
    private func updateDonationButton(button: UIButton, donation:Donation) {
        if let title = donateCellModel().donationButtonText(donation) {
            button.setTitle(title, forState: .Normal)
        }
        else {
            button.hidden = true
        }
    }
}
