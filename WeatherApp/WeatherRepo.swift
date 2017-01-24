//
//  WeatherRepo.swift
//  WeatherApp
//
//  Created by kay weng on 20/01/2017.
//  Copyright © 2017 snackcode.org. All rights reserved.
//

import Foundation
import SnackKit

protocol IWeatherRepo : IRepositoryBase {
    
    func CreateWeather(on date: Date,at location:Location?) throws -> Weather?
    func GetWeather(on date:Date,at location:Location?) throws -> Weather?
}

class WeatherRepo : RepositoryBase, IWeatherRepo{
    
    override init() {
        super.init()
    }
    
    override class var shared: WeatherRepo {
        
        struct Static {
            static var instance: WeatherRepo? = nil
        }
        
        if Static.instance == nil{
            Static.instance = WeatherRepo()
        }
        
        return Static.instance!
    }
    
    internal func CreateWeather(on date: Date,at location:Location?) throws -> Weather? {
        
        let insertedRecord = super.Create(entity: .Weather) as! Weather
        
        insertedRecord.weatherID = super.GenerateUUID()
        insertedRecord.weatherDate = date.toString
        
        insertedRecord.location = location
        
        insertedRecord.createdOn = Date().now as NSDate
        insertedRecord.modifiedOn = Date().now as NSDate
        
        return insertedRecord //manually perform save after create detail
        //return try super.Save() ? insertedRecord : nil
    }

    internal func GetWeather(on date: Date, at location: Location?) throws -> Weather? {
        
        let pred = NSPredicate(format: "weatherDate =%d && location =%@", date.toString,location!)
        let sort = [NSSortDescriptor(key: "weatherDate", ascending: false), NSSortDescriptor(key: "modifiedOn", ascending: false)]
        
        guard let weather = CoreDataManager.shared.fetchData(entity: Entity.Weather.rawValue, predicate: pred, sorting: sort) as? [Weather] else {
            throw CoreDataError.ReadError
        }
        
        return weather.first!
    }
}
