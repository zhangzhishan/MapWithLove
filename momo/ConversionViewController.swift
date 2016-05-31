//
//  ConversionViewController.swift
//  momo
//
//  Created by Zhishan Zhang on 3/24/16.
//  Copyright © 2016 Zhishan Zhang. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController {
    
    @IBOutlet var textField: UITextField!
    @IBOutlet var celsiusLabel: UILabel!
    
    @IBAction func fahrenheitFieldEditingChanged(textField: UITextField) {
        celsiusLabel.text = textField.text
    }
    
    @IBAction func dismissKeyboard(sender: AnyObject) {
        textField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
    }
}



