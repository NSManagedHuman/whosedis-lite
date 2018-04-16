//
//  ProductCollectionViewCell.swift
//  whosethis
//
//  Copyright © 2018 dannyharris. All rights reserved.
//

import UIKit

protocol CellDelegate: class {
    func cellWillBeUsed(controller: UseProductViewController)
    func cellWasUsed(percent: Float, indexPath: IndexPath)
    func cellWasDeleted(indexPath: IndexPath)
}

class ProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var availabilityLabel: UILabel!
    @IBOutlet weak var useButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBAction func useButtonWasPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "UseProductVC") as! UseProductViewController
        controller.owner = userName.text
        controller.percentage = progressBar.progress
        controller.delegate = self
        delegate?.cellWillBeUsed(controller: controller)
    }
    @IBAction func deleteButtonWasPressed(_ sender: Any) {
        delegate?.cellWasDeleted(indexPath: indexPath!)
    }
    
    var indexPath: IndexPath?
    var delegate: CellDelegate? = nil
    override func awakeFromNib() {
        cellView.layer.cornerRadius = 10
        //backgroundColor = UIColor.clear
        
    }
}

extension ProductCollectionViewCell: UseProductViewControllerProtocol {
    func percentageChanged(percentage: Float) {
        delegate?.cellWasUsed(percent: percentage, indexPath: indexPath!)
    }
}
