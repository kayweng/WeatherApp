//
//  WeatherDetailRepo.swift
//  WeatherApp
//
//  Created by kay weng on 20/01/2017.
//  Copyright © 2017 snackcode.org. All rights reserved.
//

import Foundation
import SnackKit

protocol IWeatherDetailRepo : IRepositoryBase {
    
    func CreateWeatherDetail(_ result: AnyObject,type:WeatherResultType, header:Weather) -> WeatherDetail
}

class WeatherDetailRepo : RepositoryBase, IWeatherDetailRepo{
   
    override init() {
        super.init()
    }
    
    override class var shared: WeatherDetailRepo {
        
        struct Static {
            static var instance: WeatherDetailRepo? = nil
        }
        
        if Static.instance == nil{
            Static.instance = WeatherDetailRepo()
        }
        
        return Static.instance!
    }

    internal func CreateWeatherDetail(_ result: AnyObject, type:WeatherResultType, header:Weather) -> WeatherDetail{
        
        let insertedRecord = CoreDataManager.shared.insertNewObject(forEntityName: Entity.WeatherDetail.rawValue) as! WeatherDetail
        
        insertedRecord.wdID = super.GenerateUUID()
        insertedRecord.wdResult = result as? NSObject
        insertedRecord.wdType = type.rawValue
        insertedRecord.createdOn = Date().now as NSDate
        insertedRecord.weather = header
        
        return insertedRecord
    }
}
