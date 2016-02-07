//
//  DonationJar.swift
//  Spreadit
//
//  Created by Marko Hlebar on 06/02/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

import UIKit
import KeychainSwift

class DonationJar: NSObject {

    static let defaultJar: DonationJar = DonationJar()
    
    private let keychain: KeychainSwift

    override init() {
        self.keychain = KeychainSwift()
    }
    
    func addDonation(donation: Donation) {
        print(hasDonations())
        
        let productidentifier = donation.rawValue
        
        var donationNumber = 0
        if let keychainValue = keychain.get(productidentifier) {
            donationNumber = Int(keychainValue)!
        }

        donationNumber = donationNumber + 1
        keychain.set(String(donationNumber), forKey:productidentifier)
    }
    
    func hasDonations() -> Bool {
        for donation in Donation.allValues() {
            if (keychain.get(donation) != nil) {
                return true
            }
        }
        
        return false
    }
}
