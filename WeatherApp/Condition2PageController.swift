//
//  Condition2PageController.swift
//  WeatherApp
//
//  Created by kay weng on 17/01/2017.
//  Copyright © 2017 snackcode.org. All rights reserved.
//

import UIKit

class Condition2PageController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var collDaily: UICollectionView!
    @IBOutlet weak var collHourly: UICollectionView!
    
    @IBOutlet var dtDaily: DailyDataSource!
    @IBOutlet var dtHourly: HourlyDataSource!
    
    var hourlyResult:HourlyResult?{
        didSet{
            dtHourly.records = hourlyResult!
        }
    }
    
    var dailyResult:Forecast10Result?{
        didSet{
            dtDaily.records = dailyResult!
        }
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.collDaily.register(UINib(nibName:"DailyIconCell",bundle:nil), forCellWithReuseIdentifier: "Cell")
        self.collHourly.register(UINib(nibName:"HourlyIconCell",bundle:nil), forCellWithReuseIdentifier: "Cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
