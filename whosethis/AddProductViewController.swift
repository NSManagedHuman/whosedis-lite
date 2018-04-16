//
//  AddProductViewController.swift
//  whosethis
//
//  Copyright © 2018 dannyharris. All rights reserved.
//

import UIKit

protocol AddProductViewControllerDelegate : class {
    func productDidCreate( product : Product)
}

class AddProductViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ownerTextField: UITextField!
    @IBOutlet weak var availabilitySwitch: UISwitch!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var stepperControl: UIStepper!
    @IBAction func stepperPressed(_ sender: Any) {
        multiplyCount.text = "\(Int(stepperControl.value))"
    }
    @IBOutlet weak var multiplyCount: UILabel!
    var productName: String?
    var barcode: String?
    var delegate : AddProductViewControllerDelegate? = nil
    @IBAction func backButtonWasPressed(_ sender: Any) { performSegueToReturnBack() }
    @IBAction func saveButtonWasPressed(_ sender: Any) { checkAndSave() }
    
    override func viewDidLoad() {
        if productName != nil {
            nameTextField.text = "\(productName!) (Locked)"
            nameTextField.isEnabled = false
        }
        
        saveButton.layer.cornerRadius = 5
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameTextField.endEditing(true)
        ownerTextField.endEditing(true)
    }
    
    func checkAndSave() {
        guard
            (nameTextField.text?.count != 0 && nameTextField.text != "New Product"),
            ownerTextField.text?.count != 0 && ownerTextField.text != "Enter an owner for the product",
            barcode != nil
            else {
                showAlertView(message: "Please fill in all required fields.")
                return
        }
        
        let name = productName != nil ? productName : nameTextField.text
        let owner = ownerTextField.text
        let available = availabilitySwitch.isOn
        let product = Product(code: barcode!, owner: owner!, name: name!, progress: 1.0, available: available)
        let count = Int(stepperControl.value) - 1
        for _ in 0 ... count{
            delegate?.productDidCreate(product: product)
        }
        //delegate?.productDidCreate(product: product)
        performSegueToReturnBack()
    }
    
    func showAlertView(message:String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        present(alert, animated: true, completion: nil)
        
    }
    
    func performSegueToReturnBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
