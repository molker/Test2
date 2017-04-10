//
//  Item.swift
//  Homepwner
//
//  Created by Matthew Olker on 3/12/17.
//  Copyright © 2017 Matthew Olker. All rights reserved.
//

import UIKit

class Item: NSObject, NSCoding {
    var name: String
    var valueInDollars: Int
    var serialNumber: String?
    var dateCreated: Date
    var location: String
    let itemKey: String
    
    func encode( with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(dateCreated, forKey: "dateCreated")
        aCoder.encode(itemKey, forKey: "itemKey")
        aCoder.encode(serialNumber, forKey: "serialNumber")
        aCoder.encode(location, forKey: "location")
        aCoder.encode(valueInDollars, forKey: "valueInDollars")
    }
    
    required init(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as! String
        dateCreated = aDecoder.decodeObject(forKey: "dateCreated") as! Date
        itemKey = aDecoder.decodeObject(forKey: "itemKey") as! String
        serialNumber = aDecoder.decodeObject(forKey: "serialNumber") as! String?
        location = aDecoder.decodeObject(forKey: "location") as! String
        valueInDollars = aDecoder.decodeInteger(forKey: "valueInDollars")
        
        super.init()
    }
    
    init(name: String, serialNumber: String?, valueInDollars: Int, dateCreated: Date, location: String) {
        self.name = name
        self.valueInDollars = valueInDollars
        self.serialNumber = serialNumber
        self.dateCreated = dateCreated
        self.location = location
        self.itemKey = UUID().uuidString
        
        super.init()
    }
}
