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
    }

    @IBAction func buyBtnWasPressed(_ sender: Any) {
        IAPService.instance.attemptPruchaseForItemWith(productIndex: .meal)
    }
    
    @IBAction func hideAdsBtnWasPressed(_ sender: Any) {
    }
    
    @IBAction func closeBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
