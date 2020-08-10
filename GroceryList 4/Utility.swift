//
//  Utility.swift
//  GroceryList 4
//
//  Created by Vivek Pranavamurthi on 5/17/20.
//  Copyright © 2020 CS50. All rights reserved.
//

import Foundation
import UIKit

extension ViewController {
    
    //tap gesture?
    func hideKeyboardTap() {
        print("came ehre instead.")
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        //if self.addBar.isFirstResponder == true
        tap.cancelsTouchesInView = true
        
        
        self.view.addGestureRecognizer(tap)
        
        // If the first responder resigns it's authority... the main function should attempt to recollect the data from the getallgroceries. if it is not the adbbar's doing.

        
        
        
    }
    
    
    //hide keyboard function?
    @objc func hideKeyboard() {
        if self.addBar.isFirstResponder == true {
            adDisplay()
            
        }
        self.view.endEditing(true)
        print("here instead")
        reload()
    }
}
