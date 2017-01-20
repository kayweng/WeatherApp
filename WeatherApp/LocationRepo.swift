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

protocol ILocation : IRepositoryBase {

    var _context:NSManagedObjectContext!

    func Create(location:UserLocation) -> bool
    func FindLocation()->UserLocation
    func FindAllLocations()->[UserLocation]
    func Remove(locationID:int) -> Bool
}

class LocationRepo : ILocation , RepositoryBase {


}
