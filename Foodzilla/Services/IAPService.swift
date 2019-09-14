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
}
