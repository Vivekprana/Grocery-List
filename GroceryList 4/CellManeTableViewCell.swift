//
//  CellManeTableViewCell.swift
//  GroceryList 4
//
//  Created by Vivek Pranavamurthi on 5/14/20.
//  Copyright © 2020 CS50. All rights reserved.
//

import UIKit



class CellManeTableViewCell: UITableViewCell {
    
    
    let vc = ViewController()
    var grocery: groceryInfo!
    @IBOutlet weak var priceTag: UITextField!
    
    
    var amt:Int = 0
   
    
 
    
    func cellPopulation(item: groceryInfo) {
        self.textLabel?.text = item.groceryItem
        print(item.priceOne)
        let x = initValues(amount: item.priceOne)
        print(x)
        self.priceTag.text = x
        print(item)
        self.grocery = item
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        priceTag.delegate = self
        
        
        //priceTag.delegate.placeholder = updateAmount()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
//Return The Keyboard
extension CellManeTableViewCell: UITextFieldDelegate{
    
    func initValues(amount: Double) -> String {
        
        let value = amount
        if value != nil {
            let newFormat = NumberFormatter()
            newFormat.numberStyle = .currency
            newFormat.locale = Locale.current
            
            return newFormat.string(from: NSNumber(value: amount))!
        }
        else {
            return ("$0.00")
        }
    }
    
    func updateAmountToDollar(amount: Int) -> String {
        
        
        
        let nprice = amount
        
        if  nprice !=  nil {
            
            let newFormat = NumberFormatter()
            newFormat.numberStyle = .currency
            newFormat.locale = Locale.current
            
            let amount = Double(nprice / 100) + Double(nprice % 100)/100
            return newFormat.string(from: NSNumber(value: amount))!
        }
        else{
            print("straight")
            return ("$0.00")
        }
    }
    func updateAmountToNumber(value: String) -> Double {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency

        if let number = formatter.number(from: value) {
            var amount = number.doubleValue
            return amount
        }
        return (0)
    }
    
    
    //When number field changes.
    func textField(_ textFieldToChange: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //f textFieldToChange == priceTag{
            
    
        if let digit = Int(string) {
            
            if amt <= 9999 {
        
                amt = amt * 10 + ((digit))
                
            }
            else{
                return false
            }
            priceTag.text = updateAmountToDollar(amount: amt)
        }
        
        
        if string == "" {
            amt = amt / 10
            priceTag.text = updateAmountToDollar(amount: amt)
        }
        return false
        
    }
    
    
    // Save Value.
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool{
        guard let price = priceTag.text else {
                 return true
             }
             
        
        let doubPrice = updateAmountToNumber(value: price)

         //Sql Method
        grocery.priceOne = doubPrice
        let _ = groceryManager.main.updatePrice(groceryInfo: grocery)
        
        return true
    }
    
    
    // Write code to detect when the editing has ended. This is when the grocery Manager should resave it's data.
    
}
