//
//  ItemStore.swift
//  Homepwner
//
//  Created by Matthew Olker on 3/12/17.
//  Copyright © 2017 Matthew Olker. All rights reserved.
//

import UIKit

class ItemStore {
    
    var allItems = [Item]()
    let itemArchiveURL: URL = {
        let documentsDirectories =
            FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("items.archive")
    }()
    
    init() {
        if let archivedItems =
            NSKeyedUnarchiver.unarchiveObject(withFile: itemArchiveURL.path) as? [Item] {
            allItems = archivedItems
        }
    }
    
    func saveChanges() -> Bool {
        print("Savings items to: \(itemArchiveURL.path)")
        return NSKeyedArchiver.archiveRootObject(allItems, toFile: itemArchiveURL.path)
    }
    
    @discardableResult func createItem() -> Item {
        let newItem = Item(name: "",serialNumber: "",valueInDollars: 0,dateCreated: Date.init(),location: "")
        
        allItems.append(newItem)
        
        return newItem
    }
    
    func removeItem(_ item: Item) {
        if let index = allItems.index(of: item) {
            allItems.remove(at: index)
        }
    }
    
    func moveItem(from fromIndex: Int, to toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        //Get reference to object being moved so you can reinsert it
        let movedItem = allItems[fromIndex]
        
        //Remove item from array 
        allItems.remove(at: fromIndex)
        
        //Insert item in array at new location 
        allItems.insert(movedItem, at: toIndex)
    }
}
