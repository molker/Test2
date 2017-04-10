//
//  LocationViewController.swift
//  Homepwner
//
//  Created by Matthew Olker on 4/10/17.
//  Copyright © 2017 Matthew Olker. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController {
    
    @IBOutlet var locationPicker: UIPickerView
    var item: Item!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Date Created"
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        item.dateCreated = datePicker.date
    }
}
