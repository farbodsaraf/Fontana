//
//  DonationStore.swift
//  Spreadit
//
//  Created by Marko Hlebar on 06/02/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

import UIKit
import StoreKit

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
    
    func buy(donation: Donation, completion:((donation: Donation) -> Void)?) {
        let payment = SKPayment(product: product(donation))
        SKPaymentQueue.defaultQueue().addPayment(payment)
        self.buyCompletionHandler = completion
    }
    
    internal func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        self.products = response.products
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
    
    private func product(donation: Donation) -> SKProduct {
        let productIdentifier = donation.rawValue
        return (self.products?.filter {
            product -> Bool in
            return product.productIdentifier == productIdentifier
        }.first)!
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
    }
}
