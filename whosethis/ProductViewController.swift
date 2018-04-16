//
//  ProductViewController.swift
//  whosethis
//
//  Copyright © 2018 dannyharris. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController {
    
    @IBOutlet weak var productName: UILabel?
    @IBOutlet weak var statusStripe: UILabel?
    @IBOutlet weak var collectionView: UICollectionView?
    private let userDefaults = UserDefaults.standard
    var products: Array<Product>?
    var barcode: String!
    @IBAction func backButtonWasPressed(_ sender: Any) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func addButtonWasPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "AddProductVC") as! AddProductViewController
        controller.barcode = barcode
        controller.delegate = self
        if products != nil {
            controller.productName = products?.first?.name
        }
        self.present(controller, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.prefetchDataSource = self
        collectionView?.backgroundColor = .clear
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadData()
    }
    
    func loadData() {
        collectionView?.reloadData()
        var set = false
        if products != nil {
            for product in products! {
                if product.available {
                    set = true
                    statusStripe?.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
                }
            }
        }
        if !set {
            statusStripe?.backgroundColor =  #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        }
        guard products != nil else {
            productName?.text = "Not Registered"
            return
        }
        productName?.text = products?.first?.name
    }
}

// MARK: *** Delegate ***
extension ProductViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
// MARK: *** DataSource ***
extension ProductViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard products != nil else { return 1 }
        return (products?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let nocell = collectionView.dequeueReusableCell(withReuseIdentifier: "noProductCell", for: indexPath)
        guard products != nil else { return nocell}
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! ProductCollectionViewCell
        cell.userName.text = products?[indexPath.item].owner
        if (products?[indexPath.item].available)! {
            cell.availabilityLabel.backgroundColor =  #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        } else {
            cell.availabilityLabel.backgroundColor =  #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        }
        cell.progressBar.progress = (products?[indexPath.item].progress)!
        cell.useButton.layer.cornerRadius = 5
        cell.deleteButton.layer.cornerRadius = 5
        cell.layer.cornerRadius = 5
        cell.backgroundView?.alpha = 0.4
        cell.backgroundView?.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        cell.indexPath = indexPath
        cell.delegate = self
        return cell
    }
}
// MARK: *** Prefetching ***
extension ProductViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        
    }
}

// MARK: - *** AddProduct Delegate ***
extension ProductViewController: AddProductViewControllerDelegate {
    
    func productDidCreate(product: Product) {
        if products != nil {
            products?.append(product)
        } else {
            products = [product]
        }
        var array = Array<Dictionary<String, Any>>()
        for product in products! {
            let dict = product.propertyListRepresentation
            array.append(dict)
        }
        userDefaults.set(array, forKey: product.code)
    }
}

extension ProductViewController: CellDelegate {
    
    func cellWillBeUsed(controller: UseProductViewController) {
        controller.name = productName?.text
        self.present(controller, animated: true, completion: nil)
    }
    
    func cellWasUsed(percent: Float, indexPath: IndexPath) {
        products![indexPath.item].progress = percent
        var array = Array<Dictionary<String, Any>>()
        for product in products! {
            let dict = product.propertyListRepresentation
            array.append(dict)
        }
        loadData()
        userDefaults.set(array, forKey: barcode)
    }
    
    func cellWasDeleted(indexPath: IndexPath) {
        guard ((collectionView?.cellForItem(at: indexPath)) != nil) else { loadData(); return }
        products?.remove(at: indexPath.item)
        var array = Array<Dictionary<String, Any>>()
        for product in products! {
            let dict = product.propertyListRepresentation
            array.append(dict)
        }
        if array.count == 0 {
            products = nil
            userDefaults.set(nil, forKey: barcode)
            loadData()
            return
        }
        self.collectionView?.performBatchUpdates({
            self.collectionView?.deleteItems(at: [indexPath])
        }, completion: nil)
        loadData()
        userDefaults.set(array, forKey: barcode)
    }
}

extension ProductViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let sectionInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        let cellWidth = CGFloat(250)
        let cellHeight : CGFloat = 37.0 + (250.0 * 3.0) / 5.0
        let itemsPerRow : Int = Int((view.frame.width - sectionInsets.right) / (cellWidth + sectionInsets.left))
        let items : CGFloat = CGFloat(itemsPerRow)
        let width : CGFloat = (view.frame.width - (items + 1.0) * sectionInsets.left)/items - (sectionInsets.left + 1.0)
        let height = (cellHeight * width)/cellWidth
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let sectionInsetsCustom = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        return sectionInsetsCustom
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
}

