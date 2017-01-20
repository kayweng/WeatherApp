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
    
    func Save() throws -> Bool
    func RollBack()
    func GenerateUUID()->String
}

class RepositoryBase : IRepositoryBase {
    
    var context:NSManagedObjectContext!

    class var sharedInstance: RepositoryBase {
    
        struct Static {
            static var instance: RepositoryBase? = nil
        }
        
        if Static.instance == nil{
            Static.instance = RepositoryBase()
        }
        
        return Static.instance!
    }
    
    init(){
        self.context = AppCoreDataHelper.sharedInstance.classContext
    }

    func Save() throws -> Bool{
        
        if !AppCoreDataHelper.sharedInstance.saveContext(self.context){
            AppCoreDataHelper.sharedInstance.rollbackContext(context: self.context)
            throw CoreDataError.saveError
        }
        
        return true
    }
    
    func RollBack() {
        AppCoreDataHelper.sharedInstance.rollbackContext(context: self.context)
    }
    
    func GenerateUUID()->String{
        return UUID().uuidString
    }
}
