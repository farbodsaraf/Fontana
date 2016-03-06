//
//  DonationStore.swift
//  Spreadit
//
//  Created by Marko Hlebar on 06/02/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

import UIKit
import StoreKit

let DonationStoreDidUpdateProductsNotification = "DonationStoreDidUpdateProductsNotification"
let DonationStoreDidStartPurchaseNotification = "DonationStoreDidStartPurchaseNotification"
let DonationStoreDidFinishPurchaseNotification = "DonationStoreDidFinishPurchaseNotification"

enum DonationError: ErrorType{
    case NoProductsAvailable
    case NotAValidProduct
}

class DonationStore: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {

    static let defaultStore = DonationStore()

    private var productsRequest: SKProductsRequest?
    private var products: [SKProduct]?
    private var buyCompletionHandler: (Donation -> Void)?

    override init() {
        super.init()
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
    }
    
    func loadProducts() {
        self.productsRequest = SKProductsRequest(productIdentifiers: Donation.allValues())
        self.productsRequest?.delegate = self
        self.productsRequest?.start()
    }
    
    func formattedPrice(donation: Donation) throws -> String? {
        if products?.count == 0 {
            throw DonationError.NoProductsAvailable
        }
        
        if let aProduct = product(donation) {
            let numberFormatter = NSNumberFormatter()
            numberFormatter.formatterBehavior = .Behavior10_4
            numberFormatter.numberStyle = .CurrencyStyle
            numberFormatter.locale = aProduct.priceLocale
            if let price = numberFormatter.stringFromNumber(aProduct.price) {
                return donation.description + "\n" + price
            }
            else {
                return nil
            }
        }
        else {
            throw DonationError.NotAValidProduct
        }
    }
    
    func buy(donation: Donation, completion:((donation: Donation) -> Void)?) throws {
        if let aProduct = product(donation) {
            let payment = SKPayment(product: aProduct)
            SKPaymentQueue.defaultQueue().addPayment(payment)
            self.buyCompletionHandler = completion
            
            NSNotificationCenter.defaultCenter().postNotificationName(DonationStoreDidStartPurchaseNotification, object: nil)
        }
        else {
            throw DonationError.NotAValidProduct
        }
    }
    
    internal func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        self.products = response.products
        
        NSNotificationCenter.defaultCenter().postNotificationName(DonationStoreDidUpdateProductsNotification, object: nil)
    }
    
    private func product(donation: Donation) -> SKProduct? {
        let productIdentifier = donation.rawValue
        return (self.products?.filter {
            product -> Bool in
            return product.productIdentifier == productIdentifier
        }.first)
    }
    
    private func handlePurchase(transaction: SKPaymentTransaction) {
        let productIdentifier = transaction.payment.productIdentifier
        if
            let completionHandler = self.buyCompletionHandler,
            let donation = Donation(rawValue: productIdentifier) {
            completionHandler(donation)
        }
        finishPurchase(transaction)
    }
    
    private func finishPurchase(transaction: SKPaymentTransaction) {
        SKPaymentQueue.defaultQueue().finishTransaction(transaction)
        
        NSNotificationCenter.defaultCenter().postNotificationName(DonationStoreDidFinishPurchaseNotification, object: nil)
    }
    
    internal func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .Purchased:
                handlePurchase(transaction)
            case .Failed:
                finishPurchase(transaction)
            case .Restored:
                finishPurchase(transaction)
            default: break
            }
        }
    }
}
