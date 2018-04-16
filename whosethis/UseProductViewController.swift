//
//  UseProductViewController.swift
//  whosethis
//
//  Copyright © 2018 dannyharris. All rights reserved.
//

import UIKit
import SectionedSlider

protocol UseProductViewControllerProtocol: class {
    func percentageChanged(percentage: Float)
}

class UseProductViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    var name: String!
    @IBOutlet weak var ownerLabel: UILabel!
    var owner: String!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var sectionedSlider: SectionedSlider?
    @IBOutlet weak var okButton: UIButton!
    @IBAction func okWasPressed(_ sender: Any) {
        delegate?.percentageChanged(percentage: percentage!)
        self.dismiss(animated: true, completion: nil)
    }
    var delegate: UseProductViewControllerProtocol? = nil
    var percentage: Float?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = name
        ownerLabel.text = owner
        sectionedSlider?.selectedSection = Int(percentage! * 10)
        percentageLabel.text = "\(Int(percentage! * 100))%"
        okButton.layer.cornerRadius = 5
        sectionedSlider?.delegate = self
    }
    
}

extension UseProductViewController: SectionedSliderDelegate {
    
    func sectionChanged(slider: SectionedSlider, selected: Int) {
        percentageLabel.text = "\(selected * 10)%"
        percentage = Float(selected)*0.1
    }
    
}
