//
//  HourlyDataSource.swift
//  WeatherApp
//
//  Created by kay weng on 17/01/2017.
//  Copyright © 2017 snackcode.org. All rights reserved.
//

import Foundation
import UIKit
import SnackKit

class HourlyDataSource: NSObject, UICollectionViewProtocol, UICollectionViewDelegate, UICollectionViewDataSource{

    @IBOutlet private weak var collectionView:UICollectionView!
    
    var records:HourlyResult?
    
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
        
        return self.records!.hours.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HourlyIconCell
        
        let hrDetail = self.records!.hours[indexPath.row]
    
        //Day
        if indexPath.row == 0 {
            cell.lblDay.text = hrDetail.description.weekday == Date().now.dayName ? "Today" : hrDetail.description.weekday
        }else{
            
            let lastDesc = self.records!.hours[indexPath.row-1].description.weekday_short
            
            if lastDesc != hrDetail.description.weekday_short{
                cell.lblDay.text = hrDetail.description.weekday
            }else{
                cell.lblDay.text = ""
            }
        }

        //Hour
        if hrDetail.wDate.hour == "0"{
            cell.lblHour.text = "\(12) AM"
            
        }else{
            cell.lblHour.text = "\(hrDetail.wDate.hour.int! > 12 ? hrDetail.wDate.hour.int! - 12 : hrDetail.wDate.hour.int!) \(hrDetail.wDate.ampm)"
        }
        
        cell.imgHour.image = WeatherStatic.GetIcon(name: hrDetail.cond)
        
        //Temperature
        if gTemperatureUnit == TemperatureUnit.Celsius{
            cell.lblHourTemp.text = "\(hrDetail.low.celsius)\(dsymbol)/\(hrDetail.high.celsius)\(dsymbol)"
        }else{
            cell.lblHourTemp.text = "\(hrDetail.low.fahrenheit)\(dsymbol)/\(hrDetail.high.fahrenheit)\(dsymbol)"
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.collectionView.frame.width/6.01,
                      height: CGFloat(100.0))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
}
