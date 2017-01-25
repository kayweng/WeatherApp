//
//  RepositoryBase.swift
//  WeatherApp
//
//  Created by kay weng on 17/01/2017.
//  Copyright © 2017 snackcode.org. All rights reserved.
//

import Foundation
import CoreData
import SnackKit

protocol IRepositoryBase {
    
    func Create(entity: Entity) -> AnyObject
    func Delete(pred:NSPredicate, in entity:Entity) throws -> Bool
    func Save() throws -> Bool
    func RollBack()
    func GenerateUUID()->String
}

class RepositoryBase : IRepositoryBase {
    
    var context:NSManagedObjectContext!

    class var shared: RepositoryBase {
    
        struct Static {
            static var instance: RepositoryBase? = nil
        }
        
        if Static.instance == nil{
            Static.instance = RepositoryBase()
        }
        
        return Static.instance!
    }
    
    init(){
        self.context = CoreDataManager.shared.managedObjectContext!
    }
    

    internal func Create(entity: Entity) -> AnyObject {
        
        return CoreDataManager.shared.insertNewObject(forEntityName: entity.rawValue)
    }
    
    internal func Delete(pred: NSPredicate, in entity: Entity) throws -> Bool {
        
        guard let record = try CoreDataManager.shared.fetchEntityData(from: self.context, entity: entity.rawValue, predicate: pred) else {
            return false    // no found
        }
        
        guard CoreDataManager.shared.deleteData(record as AnyObject) else {
            throw CoreDataError.DeleteError
        }
        
        return true
    }

    internal func Save() throws -> Bool{
        
        if !CoreDataManager.shared.saveContext(self.context){
            CoreDataManager.shared.rollbackContext(self.context)
            throw CoreDataError.SaveError
        }
        
        return true
    }
    
    internal func RollBack() {
        CoreDataManager.shared.rollbackContext(self.context)
    }
    
    internal func GenerateUUID()->String{
        return UUID().uuidString
    }
}
