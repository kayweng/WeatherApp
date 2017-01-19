//
//  ProtocolDataSource.swift
//  WeatherApp
//
//  Created by kay weng on 05/01/2017.
//  Copyright © 2017 snackcode.org. All rights reserved.
//

import Foundation
import UIKit

protocol UIViewControllerProtocol{
    
    var delegate:UIViewController? { get set }
    
    func initWithDataSource()->Void
}

protocol UITableViewCellProtocol{
    
    var delegate:UITableViewCell? { get set }
    
    func initWithDataSource()->Void
}


protocol UICollectionViewProtocol {
    
    var delegate:UICollectionView? { get set }
    
    func initWithDataSource()->Void
}
