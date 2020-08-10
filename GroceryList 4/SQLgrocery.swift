//
//  SQLgrocery.swift
//  GroceryList 4
//
//  Created by Vivek Pranavamurthi on 5/14/20.
//  Copyright © 2020 CS50. All rights reserved.
//

import Foundation
import SQLite3

struct groceryInfo {
    var id: Int
    var groceryItem: String
    var priceOne: Double
}


class groceryManager {
    var database: OpaquePointer!
    
    
    static let main = groceryManager()
    private init() {
        
    }
    
    func connect() {
        if database != nil{
            return
        }
        do {
            let databaseURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("GroceryList.sqlite3")
            if sqlite3_open(databaseURL.path, &database) != SQLITE_OK {
                print("Could not connect")
            }
            else {
                if sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS groceries (item TEXT, price INT)", nil, nil, nil) != SQLITE_OK{
                    print("Error Making Table")
                }
                
            }
            
        }
        catch let error {
            print ("Could not create database.")
        }
        
    }
    func createEntry(string: String) -> Int {
        connect()
        
        var statement: OpaquePointer!
        
        //Query
        if sqlite3_prepare_v2(database, "INSERT INTO groceries (item, price) VALUES (?,?)", -1, &statement, nil) != SQLITE_OK {
            print("Non Working query")
            return -1
        }
            
        sqlite3_bind_text(statement, 1, NSString(string: string).utf8String, -1, nil)
            
            
        
        //Insert Statement
        if sqlite3_step(statement) != SQLITE_DONE{
            print("Could not insert the note")
            return -1
        
            
        }
        sqlite3_finalize(statement)
        return Int(sqlite3_last_insert_rowid(database))
    }
    
    func updatePrice(groceryInfo: groceryInfo) {
        connect()
        var statement: OpaquePointer!
        if sqlite3_prepare_v2(database, "UPDATE groceries SET price = ? WHERE rowid = ?", -1, &statement, nil) != SQLITE_OK {
            print ("ERRROR with update statement.")
        }
        
        sqlite3_bind_double(statement, 1, Double(groceryInfo.priceOne))
        
        sqlite3_bind_int(statement, 2, Int32(groceryInfo.id) )
        
        if sqlite3_step(statement) != SQLITE_DONE{
            print("Error Runnign Update")
        }
        print("Saved those cool beans.")
        sqlite3_finalize(statement)
    }
    
    func getAllGroceries() -> [groceryInfo] {
        connect()
        var result: [groceryInfo] = []
        
        var statement: OpaquePointer!
        if sqlite3_prepare_v2(database, "Select rowid, item, price FROM groceries", -1, &statement, nil) != SQLITE_OK {
            print("Error with Select")
            return[]
        }
        
        //Come back and re-settle the price variable.
        while sqlite3_step(statement) == SQLITE_ROW {
            result.append(groceryInfo(id: Int(sqlite3_column_int(statement, 0)), groceryItem: String (cString: sqlite3_column_text(statement, 1)), priceOne: Double(sqlite3_column_double(statement, 2))))
            
            
        }
        //finalize
        sqlite3_finalize(statement)
        return result
    }
    func delete(groceryInfo: groceryInfo) {
        connect()
        var statement: OpaquePointer!
        if sqlite3_prepare_v2(database, "DELETE FROM groceries where rowid = ?", -1, &statement, nil) != SQLITE_OK {
            print ("Delete Error Statement")
            return
                
            }
            
        sqlite3_bind_int(statement, 1, Int32(groceryInfo.id))
        
        
        if sqlite3_step(statement) != SQLITE_DONE{
            print("could not delete row")
            return
        }
        sqlite3_finalize(statement)
        return
        
    
        
    }
}
