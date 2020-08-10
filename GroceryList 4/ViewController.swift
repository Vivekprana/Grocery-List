//
//  ViewController.swift
//  GroceryList 4
//
//  Created by Vivek Pranavamurthi on 5/12/20.
//  Copyright © 2020 CS50. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController{
    
    
    var grocery: groceryInfo!
    var groceries: [groceryInfo] = []
    var readyforText: Bool = false
    
    
    @IBOutlet weak var totalPrice: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addBar: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var AddButton: UIButton!
    
    /*override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("mariah")
        self.view.endEditing(true)
    }*/
   
    func updateTotal() {
        var totalPrice = 0.00
        for items in groceries{
            totalPrice += items.priceOne
            
        }
        print(totalPrice)
    }
    
    func showAlert(alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
        return
    }
    
    override func viewDidLoad() {
        
        //UIText Field Delegate Controls

        super.viewDidLoad()
        
        addBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        //Add Bar properties
        self.addBar.alpha = 0.0
        self.addBar.layer.cornerRadius = 5.0
        reload()
        
        
        //tap gesture?
        self.hideKeyboardTap()
    }
    
    
    
    //Animate the addBar
    @IBAction func showViewWithAnimations(_sender: Any) {
        adDisplay()
        
    }
    
  
    // Fade the background when the add item button is pressed.
    func adDisplay()
    {
        if self.addBar.alpha == 0.0 {
            
            UITextField.animate(withDuration: 1.0, delay: 0, options: .transitionCurlDown, animations: {
                self.addBar.alpha = 1.0 }
            , completion: nil)
            
            UITableView.animateKeyframes(withDuration: 1.0, delay: 0, options: .beginFromCurrentState, animations:{
                self.tableView.alpha = 0.2
                
            }, completion: nil)
            
            self.addBar.becomeFirstResponder()
        
            
            
        }
        else {
            UITextField.animate(withDuration: 1.0, delay: 0, options: .transitionCurlDown, animations: {
                self.addBar.alpha = 0.0 }
            , completion: nil)
            
            UITableView.animateKeyframes(withDuration: 1.0, delay: 0, options: .beginFromCurrentState, animations:{
                self.tableView.alpha = 1.0
                
            }, completion: nil)
            
        }
    }
    //Reload the function for groceries.
    func reload() {
        groceries = groceryManager.main.getAllGroceries()
        self.tableView.reloadData()
        updatePrice()
    }

    //Update total price
    func updatePrice() {
        var totalCost = 0.00
        for items in groceries {
            totalCost += items.priceOne
        }
        let newFormat = NumberFormatter()
        newFormat.numberStyle = .currency
        newFormat.locale = Locale.current
        
        totalPrice.text = newFormat.string(from: NSNumber(value: totalCost))
        
    }

}

//table Update
extension ViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groceries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Redirect cell customization to customization sheet.
        let cell = tableView.dequeueReusableCell(withIdentifier: "drop") as! CellManeTableViewCell
           
        
        //Check whether the groceries list item is nil
        
        //Then use the list of structures to populate the list.
        
        let item = groceries[indexPath.row]
        cell.cellPopulation(item: item)
        
        
            
       
    
        return cell
    }
    
    
    //Able to edit data.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        print ("at least here?")
        if editingStyle == .delete {
            ("try to")
            groceryManager.main.delete(groceryInfo: groceries[indexPath.row])
            reload()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("mariah")
        self.view.endEditing(true)
    }
}


//Return The Keyboard
extension ViewController: UITextFieldDelegate{
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        adDisplay()
        
        
        guard let item = addBar.text else{
            return true
        }
        
        //Sql Method
        let _ = groceryManager.main.createEntry(string: item)
        reload()
        addBar.text = nil
        
        return true
    }
    
    // This might be a repeat of above.
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool{

        return true
    }
    

    
}
