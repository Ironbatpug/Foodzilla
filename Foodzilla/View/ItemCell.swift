//
//  ItemCell.swift
//  Foodzilla
//
//  Created by Molnár Csaba on 2019. 09. 14..
//  Copyright © 2019. Molnár Csaba. All rights reserved.
//

import UIKit

class ItemCell: UICollectionViewCell {
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    
    func configureCell(forItem item: Item){
        self.itemName.text = item.name
        self.itemPrice.text = "\(item.price)"
        self.itemImage.image = item.image

    }
}
