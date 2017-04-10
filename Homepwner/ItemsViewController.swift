//
//  ItemsViewController.swift
//  Homepwner
//
//  Created by Matthew Olker on 3/12/17.
//  Copyright © 2017 Matthew Olker. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController {
    
    var itemStore: ItemStore!
    var imageStore: ImageStore!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        //Create a new item and add it to the store
        let newItem = itemStore.createItem()
        
        //Figure out where that item is in the array
        if let index = itemStore.allItems.index(of: newItem) {
            let indexPath = IndexPath(row: index, section: 0)
            
            //Insert this new row into the table
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return itemStore.allItems.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row < itemStore.allItems.count {
            //Get a new or recycled cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
            //Set the text on the cell with the dsecription of the item
            //that is at the nth index of items, where n = row this cell
            //will appear in on the tableview
            let item = itemStore.allItems[indexPath.row]
        
            //Configure the cell with the Item
            cell.nameLabel.text = item.name
            cell.serialNumberLabel.text = item.serialNumber
            cell.valueLabel.text = "$\(item.valueInDollars)"
            cell.locationLabel.text = item.location
            if item.valueInDollars >= 50 {
                cell.valueLabel.textColor = UIColor.red
            } else {
                cell.valueLabel.textColor = UIColor.green
            }
            return cell
        } else {
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "LastCell")
            cell.textLabel?.text = "No More Items!"
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row >= itemStore.allItems.count {
            return false
        }
        return true
    }
    
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath,
                            toProposedIndexPath proprosedDestinationIndexPath: IndexPath) -> IndexPath {
        if proprosedDestinationIndexPath.row >= itemStore.allItems.count {
            return sourceIndexPath
        }
        return proprosedDestinationIndexPath
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        //If the table view is asking to commit a delete command...
        if editingStyle == .delete {
            let item = itemStore.allItems[indexPath.row]
            
            let title = "Remove \(item.name)?"
            let message = "Are you sure you want to delete this item?"
            
            let ac = UIAlertController(title: title,
                                       message: message,
                                       preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Remove", style: .destructive, handler: { (action) -> Void in
                //Remove the item from the store
                self.itemStore.removeItem(item)
                
                //Remove the item's image from the image store
                self.imageStore.deleteImage(forKey: item.itemKey)
                
                //Also remove that row from the table view with an animation
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            })
            ac.addAction(deleteAction)
            
            //Present the alert controller
            present(ac, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            moveRowAt sourceIndexPath: IndexPath,
                            to destinationIndexPath: IndexPath) {
        //Update the model
        itemStore.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if the triggered segue is the "showItem" segue
        switch segue.identifier {
        case "showItem"?:
            //Figure out which row was just tapped
            if let row = tableView.indexPathForSelectedRow?.row {
                
                //Get the item associated with this row and pass it along
                let item = itemStore.allItems[row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.item = item
                detailViewController.imageStore = imageStore
            }
            
        case "newItem"?:
            
            let tempItemStore = self.itemStore
            let tempImageStore = self.imageStore
            //Create a new item and add it to the store
            let newItem = itemStore.createItem()
            
            var indexPathForDetail: IndexPath!
            
            //Figure out where that item is in the array
            if let index = itemStore.allItems.index(of: newItem) {
                let indexPath = IndexPath(row: index, section: 0)
                
                indexPathForDetail = indexPath
                
                //Insert this new row into the table
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
            
            //Get the item associated with this row and pass it along
            let item = itemStore.allItems[itemStore.allItems.index(of: newItem)!]
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.item = item
            detailViewController.imageStore = tempImageStore
            detailViewController.itemStore = tempItemStore
            detailViewController.row = indexPathForDetail
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 65
    }
    
}
