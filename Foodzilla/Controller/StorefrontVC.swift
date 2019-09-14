//
//  ViewController.swift
//  Foodzilla
//
//  Created by Molnár Csaba on 2019. 09. 14..
//  Copyright © 2019. Molnár Csaba. All rights reserved.
//

import UIKit

class StorefrontVC: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        IAPService.instance.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: <#T##Selector#>, name: NSNotification.Name(IAPServiceRestoreNotification), object: nil)
    }

    @IBAction func restoreBtnWasPressed(_ sender: Any) {
        let alertVC = UIAlertController(title: "Restore Purchases?", message: "Do you want to restore any in-app purchases you've previously purchased?", preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Restore", style: .default) { (action) in
            IAPService.instance.restorePurchases()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertVC.addAction(action)
        alertVC.addAction(cancelAction)
        present(alertVC,animated: true, completion: nil)
    }
    
    func showAlert() {
        let alertVC = UIAlertController(title: "Succes!", message: "your purchases were succesfully restored.", preferredStyle: .alert)
        let action = UIAlertAction(title: "ok", style: .default, handler: nil)
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
    }
    
}

extension StorefrontVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as? ItemCell else { return UICollectionViewCell()}
        cell.configureCell(forItem: foodItems[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let detailsVC = storyboard?.instantiateViewController(withIdentifier: "detailsVC") as? DetailsVC else { return }
        detailsVC.initData(forItem: foodItems[indexPath.row])
        present(detailsVC, animated: true, completion: nil)
    }
}

extension StorefrontVC: IAPServiceDelegate {
    func iapProductsLoaded() {
        print("IAP PRoducts loaded")
    }
}







