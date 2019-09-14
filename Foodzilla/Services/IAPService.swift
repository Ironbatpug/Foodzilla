//
//  IAPService.swift
//  Foodzilla
//
//  Created by Molnár Csaba on 2019. 09. 14..
//  Copyright © 2019. Molnár Csaba. All rights reserved.
//

import Foundation
import StoreKit

protocol IAPServiceDelegate {
    func iapProductsLoaded()
}

class IAPService: NSObject, SKProductsRequestDelegate {
    static let instance = IAPService()
    
     var delegate: IAPServiceDelegate?
    
    var products = [SKProduct]()
    var productIDs = Set<String>()
    var produtRequest = SKProductsRequest()
    
    var nonConsumablePurchaseWasMade = UserDefaults.standard.bool(forKey: "nonConsumablePurchaseWasMade")
    
    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    func loadProducts() {
        productIdToStringSet()
        requestProducts(forIds: productIDs)
    }
    
    func productIdToStringSet(){
        let ids = [IAP_HIDE_ADS_ID, IAP_MEAL_ID]
        for id in productIds {
            productIDs.insert(ids)
        }
    }
    
    func requestProducts(forIds ids: Set<String>) {
        produtRequest.cancel()
        produtRequest = SKProductsRequest(productIdentifiers: productIDs)
        produtRequest.delegate = self
        produtRequest.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
        
        if products.count == 0 {
            requestProducts(forIds: productIDs)
        } else {
            delegate?.iapProductsLoaded()
        }
    }
    
    func attemptPruchaseForItemWith(productIndex: Products) {
        let product = products[productIndex.rawValue]
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

extension IAPService: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
                complete(transaction:  transaction)
                sendNoticationFor(status: .purchased, withIdentifier: transaction.payment.productIdentifier)
                break
            case .restored:
                SKPaymentQueue.default().finishTransaction(transaction)
                break
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                sendNoticationFor(status: .failed, withIdentifier: nil)
            case .deferred:
                break
            case .purchasing:
                break
            }
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        sendNoticationFor(status: .restored, withIdentifier: nil)
        setNonConsumablePurchase(true)
    }
    
    func complete(transaction: SKPaymentTransaction) {
        switch transaction.payment.productIdentifier {
        case IAP_MEAL_ID:
            break
        case IAP_HIDE_ADS_ID:
            setNonConsumablePurchase(true)
            break
        default:
            break
        }
    }
    
    func setNonConsumablePurchase(_ status: Bool){
        UserDefaults.standard.set(status, value(forKey: "nonConsumablePurchaseWasMade"))
    }
    
    func sendNoticationFor(status: PurchaseStatus, withIdentifier identifier: String?){
        switch status {
        case .purchased:
            NotificationCenter.default.post(name: NSNotification.Name(IAPServicePurchaseNotification), object: identifier)
        case .restored:
            NotificationCenter.default.post(name: NSNotification.Name(IAPServiceRestoreNotification), object: nil)
        case .failed:
            NotificationCenter.default.post(name: NSNotification.Name(IAPServiceFailureNotification), object: nil)
        }
    }
}





