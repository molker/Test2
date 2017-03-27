//
//  DateViewController.swift
//  Homepwner
//
//  Created by Matthew Olker on 3/27/17.
//  Copyright © 2017 Matthew Olker. All rights reserved.
//

import UIKit

class DateViewController: UIViewController {
    
    @IBOutlet var datePicker: UIDatePicker!
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
