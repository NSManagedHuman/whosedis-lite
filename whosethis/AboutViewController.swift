//
//  AboutViewController.swift
//  whosethis
//
//  Copyright © 2018 dannyharris. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var versionLabel: UILabel!
    @IBAction func webPressed(_ sender: Any) {
        // TODO: - Go to web
    }
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        logo.tintColor = .white
        updateVersionLabel()
    }
    
    func updateVersionLabel() {
        guard let path = Bundle.main.path(forResource: "Info", ofType: "plist") else {
            return
        }
        
        guard let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] else {
            return
        }
        
        versionLabel.text = String(format: "v%@.%@", dict["CFBundleShortVersionString"] as! String,
                                      dict["CFBundleVersion"] as! String)
    }
}
