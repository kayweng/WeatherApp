//
//  TaskingDataSource.swift
//  WeatherApp
//
//  Created by kay weng on 05/01/2017.
//  Copyright © 2017 snackcode.org. All rights reserved.
//

import Foundation
import UIKit

class TaskingDataSource: NSObject, UITableViewDataSource, UITableViewDelegate, UIViewControllerProtocol{
    
    @IBOutlet private weak var tableView:UITableView!

    private var records:[AnyObject] = []
    
    internal var delegate: UIViewController?{
        didSet{
            self.initWithDataSource()
        }
    }

    internal func initWithDataSource() {
        
        self.tableView.reloadData()
    }
    
    //MARK: - UITableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1//self.records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:WorkingListCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! WorkingListCell
        
        return cell
    }
}
