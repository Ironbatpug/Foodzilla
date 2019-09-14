//
//  IAPService.swift
//  Foodzilla
//
//  Created by Molnár Csaba on 2019. 09. 14..
//  Copyright © 2019. Molnár Csaba. All rights reserved.
//

import Foundation
import StoreKit

class IAPService: NSOBject, SKProductsRequestDelegate {
    static let instance = IAPService()
    
    func loadProducts() {
        
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        <#code#>
    }
}
