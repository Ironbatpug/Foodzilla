//
//  DetailsVC.swift
//  Foodzilla
//
//  Created by Molnár Csaba on 2019. 09. 14..
//  Copyright © 2019. Molnár Csaba. All rights reserved.
//

import UIKit

class DetailsVC: UIViewController {
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var itemPriceLbl: UILabel!
    @IBOutlet weak var uglyAdView: UIView!
    @IBOutlet weak var buyItemBtn: UIButton!
    @IBOutlet weak var hideAdsBtn: UIButton!
    
    public private(set) var item: Item!
    
    func initData(forItem item: Item) {
        self.item = item
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.itemImageView.image = item.image
        self.itemNameLbl.text = item.name
        self.itemPriceLbl.text = "\(item.price)"
        buyItemBtn.setTitle("Buy this item for $\(item.price)", for: .normal)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handlePurchase(_:)), name: NSNotification.Name(IAPServicePurchaseNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleFailure), name: NSNotification.Name(IAPServiceFailureNotification), object: nil)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handlePurchase(_ notification: Notification) {
        guard let productID = notification.object as? String else { return }
        
        switch productID {
        case IAP_MEAL_ID:
            buyItemBtn.isEnabled = true
            break
        case IAP_HIDE_ADS_ID:
            break
        default:
            break
        }
    }
    
    @objc func handleFailure() {
        buyItemBtn.isEnabled = true

        print("Purchase Failed!")
    }

    @IBAction func buyBtnWasPressed(_ sender: Any) {
        buyItemBtn.isEnabled = false
        IAPService.instance.attemptPruchaseForItemWith(productIndex: .meal)
    }
    
    @IBAction func hideAdsBtnWasPressed(_ sender: Any) {
    }
    
    @IBAction func closeBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
