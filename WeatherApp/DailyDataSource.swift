//
//  DailyDataSource.swift
//  WeatherApp
//
//  Created by kay weng on 18/01/2017.
//  Copyright © 2017 snackcode.org. All rights reserved.
//

import Foundation
import UIKit
import SnackKit

class DailyDataSource: NSObject, UICollectionViewProtocol,
UICollectionViewDelegate, UICollectionViewDataSource{

    @IBOutlet private weak var collectionView:UICollectionView!
    
    var records:ForecastResult?
    
    var delegate: UICollectionView?{
        didSet{
            self.initWithDataSource()
        }
    }
    
    internal func initWithDataSource() {
        self.collectionView.reloadData()
    }
    
    // MARK: - UICollectionView
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let _ = self.records else {
            return 0
        }
        
        return self.records!.simplyForecast.count - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! DailyIconCell
        
        let daDetail = self.records?.simplyForecast[indexPath.row + 1]
        
        //Day
        cell.lblDay.text = daDetail!.month.weekday
        
        if gTemperatureUnit == .Celsius{
            cell.lblTemperature.text = "\(daDetail!.low.celsius)\(dsymbol) / \(daDetail!.high.celsius)\(dsymbol)"
        }else{
            cell.lblTemperature.text = "\(daDetail!.low.fahrenheit)\(dsymbol) / \(daDetail!.high.fahrenheit)\(dsymbol)"
        }
        
        if daDetail!.month.weekday == DayOfWeek.Sunday.rawValue{
            cell.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.2)
        }else{
            cell.backgroundColor = .clear
        }
        
        cell.imgCondition.image = WeatherStatic.GetIcon(name: daDetail!.conditions)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.collectionView.frame.width/3.01,
                      height: CGFloat(self.collectionView.frame.height))
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
}
