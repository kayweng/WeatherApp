//
//  LocationRepo.swift
//  WeatherApp
//
//  Created by kay weng on 17/01/2017.
//  Copyright © 2017 snackcode.org. All rights reserved.
//

import Foundation
import CoreData
import SnackKit

protocol ILocationRepo : IRepositoryBase {

    func Create(_ location: UserLocation) throws ->  Location?
    func Update(_ location: UserLocation) throws -> Location?
    func CreateOrReplace(_ location: UserLocation) throws -> Location?
    func RemoveLocation(id:String) throws -> Bool
    func GetLocation(_ type:LocationType,on date:Date) throws ->Location?
    func GetAllLocations() throws ->[Location]?
}

class LocationRepo : RepositoryBase, ILocationRepo {
    
    override init() {
        super.init()
    }
    
    override class var shared: LocationRepo {
        
        struct Static {
            static var instance: LocationRepo? = nil
        }
        
        if Static.instance == nil{
            Static.instance = LocationRepo()
        }
        
        return Static.instance!
    }

    
    internal func GetAllLocations() throws -> [Location]? {

        guard let locations:[Location] = try CoreDataManager.shared.fetchData(context: super.context, entity: Entity.Location.rawValue, predicate: nil) as? [Location] else {
            throw CoreDataError.ReadError
        }
        
        return locations
    }

    internal func GetLocation(_ type:LocationType,on date:Date) throws -> Location? {
        
        let predicate:NSPredicate = NSPredicate(format: "locationType == %@ && locationDate == %@", type.rawValue, date as NSDate)
        let sort = [NSSortDescriptor(key: "modifiedOn", ascending: false)]
        
        guard let locations:[Location] = try CoreDataManager.shared.fetchData(context: super.context, entity: Entity.Location.rawValue, predicate: predicate,sorting: sort) as! [Location]? else {
            throw CoreDataError.ReadError
        }
        
        return locations.first!
    }
    
    internal func RemoveLocation(id: String) throws -> Bool {
        
        let predicate:NSPredicate = NSPredicate(format: "locationID == %@", id)
        var retval = false
        
        do{
            retval = try super.Delete(pred: predicate, in: Entity.Location)
        }catch CoreDataError.DeleteError{
            throw CoreDataError.DeleteError
        }
        
        return retval
    }
    
    internal func CreateOrReplace(_ location: UserLocation) throws -> Location?{
     
        let predicate:NSPredicate = NSPredicate(format: "locationType == %@", location.type!.rawValue)
        
        guard let locations:[Location] = try CoreDataManager.shared.fetchData(context: super.context, entity: Entity.Location.rawValue, predicate: predicate) as! [Location]? else {
            throw CoreDataError.ReadError
        }
        
        if locations.count == 0 {
            return try self.Create(location)
        }else{
            return try self.Update(location)
        }
    }
    
    internal func Create(_ location: UserLocation) throws -> Location? {
        
        let insertedRecord = super.Create(entity: Entity.Location) as! Location
        
        insertedRecord.locationID = super.GenerateUUID()
        insertedRecord.latitude = String(describing: location.latitude)
        insertedRecord.longitude = String(describing: location.longitude)
        insertedRecord.locationCity = location.city
        insertedRecord.locationCountry = location.country
        insertedRecord.locationName = location.name
        insertedRecord.locationType = location.type?.rawValue
        insertedRecord.locationDate = Date().today as NSDate
        insertedRecord.createdOn = Date().now as NSDate
        insertedRecord.modifiedOn = Date().now as NSDate
        
        return try super.Save() ? insertedRecord : nil
    }
    
    internal func Update(_ location: UserLocation) throws -> Location? {
        
        let predicate:NSPredicate = NSPredicate(format: "locationType == %@", location.type!.rawValue)
        
        guard let records:[Location] = try CoreDataManager.shared.fetchData(context: super.context, entity: Entity.Location.rawValue, predicate: predicate) as! [Location]? else {
            throw CoreDataError.ReadError
        }
        
        if let updatedRecord = records.first {
            
            updatedRecord.latitude = String(describing: location.latitude)
            updatedRecord.longitude = String(describing: location.longitude)
            updatedRecord.locationCity = location.city
            updatedRecord.locationCountry = location.country
            updatedRecord.locationName = location.name
            updatedRecord.locationDate = Date().today as NSDate
            updatedRecord.modifiedOn = Date().now as NSDate
            
            return try super.Save() ? updatedRecord : nil
        }

        return nil
    }
}
