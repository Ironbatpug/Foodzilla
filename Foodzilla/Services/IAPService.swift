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
    
    func loadProducts() {
        productIdToStringSet()
        requestProducts(forIds: productIDs)
    }
    
    func productIdToStringSet(){
        productIDs.insert(IAP_MEAL_ID)
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
}

extension IAPService: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
                break
            case .restored:
                break
            case .failed:
                break
            case .deferred:
                break
            case .purchasing:
                break
            }
        }
    }
}





