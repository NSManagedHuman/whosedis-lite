//
//  MainViewController.swift
//  whosethis
//
//  Copyright © 2018 dannyharris. All rights reserved.
//

import UIKit
import BarcodeScanner

class MainViewController: UIViewController {

    // MARK: - *** Vars ***
    
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var logo: UIButton!
    private let userDefaults = UserDefaults.standard
    
    // MARK: - *** Main ***
    @IBAction func scanButtonWasPressed(_ sender: Any) {
        let viewController = makeBarcodeScannerViewController()
        viewController.title = "Barcode Scanner"
        present(viewController, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scanButton.layer.cornerRadius = 2
        logo.imageView?.tintColor = .white
    }
    
    private func makeBarcodeScannerViewController() -> BarcodeScannerViewController {
        let viewController = BarcodeScannerViewController()
        // Had to do this in order for the barcode scanner not to display placeholders
        viewController.headerViewController.titleLabel.text = ""
        viewController.headerViewController.closeButton.setTitle("Back", for: .normal)
        viewController.messageViewController.messages.scanningText = "Please place a valid barcode or QR-code in front of the rear camera"
        viewController.codeDelegate = self
        viewController.errorDelegate = self
        viewController.dismissalDelegate = self
        return viewController
    }
    
    private func makeProductViewController() -> ProductViewController {
        let viewController = ProductViewController()
        return viewController
    }
    
    private func loadDataFromCode(code: String) -> Array<Product>? {
        let products = userDefaults.object(forKey: code) as? Array<Dictionary<String, Any>>
        guard (products != nil) else { return nil}
        var array = Array<Product>()
        for product in products! {
            let prod = Product(code: (product["code"] as? String)!, owner: (product["owner"] as? String)!, name: (product["name"] as? String)!, progress: (product["progress"] as? Float)!, available: (product["available"] as? Bool)!)
            array.append(prod)
        }
        return array
    }

}

// MARK: - BarcodeScannerCodeDelegate

extension MainViewController: BarcodeScannerCodeDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        scannerDidDismiss(controller)
        let products = loadDataFromCode(code: code)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ProductVC") as! ProductViewController
        controller.barcode = code
        controller.products = products
        controller.loadData()
        self.present(controller, animated: true, completion: nil)
    }
}

// MARK: - BarcodeScannerErrorDelegate

extension MainViewController: BarcodeScannerErrorDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        // Manage Errors in the future?
    }
}

// MARK: - BarcodeScannerDismissalDelegate

extension MainViewController: BarcodeScannerDismissalDelegate {
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
