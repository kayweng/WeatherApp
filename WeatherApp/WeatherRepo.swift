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
    func RemoveWeahter(_ id:String)
    func RemoveWeatherAt(location:Location)
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
        insertedRecord.weatherDate = date.toISODateString()
        
        insertedRecord.location = location
        
        insertedRecord.createdOn = Date().now as NSDate
        insertedRecord.modifiedOn = Date().now as NSDate
        
        return insertedRecord //manually perform save after create detail
        //return try super.Save() ? insertedRecord : nil
    }

    internal func GetWeather(on date: Date, at location: Location?) throws -> Weather? {
        
        let pred = NSPredicate(format: "weatherDate =%@ && location =%@", date.toISODateString(),location!)
        let sort = [NSSortDescriptor(key: "weatherDate", ascending: false), NSSortDescriptor(key: "modifiedOn", ascending: false)]
        
        guard let weather = CoreDataManager.shared.fetchEntityData(entity: Entity.Weather.rawValue, predicate: pred, sorting: sort) as? [Weather] else {
            throw CoreDataError.ReadError
        }
        
        return weather.count > 0 ? weather.first! : nil
    }
    
    internal func RemoveWeatherAt(location:Location){
        
        let pred = NSPredicate(format: "location =%@", location)
        
        do {
            let _ = try self.Delete(pred: pred, in: Entity.Weather)
        }catch CoreDataError.DeleteError{
            
        }catch _{
            
        }
    }
    
    internal func RemoveWeahter(_ id:String){
        
        let pred = NSPredicate(format: "weatherID =%@", id)
        
        do {
            let _ = try self.Delete(pred: pred, in: Entity.Weather)
        }catch CoreDataError.DeleteError{
            
        }catch _{
            
        }
    }
}
