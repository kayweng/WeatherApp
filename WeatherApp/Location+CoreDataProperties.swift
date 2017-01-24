//
//  Location+CoreDataProperties.swift
//  WeatherApp
//
//  Created by kay weng on 23/01/2017.
//  Copyright © 2017 snackcode.org. All rights reserved.
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location");
    }

    @NSManaged public var createdOn: NSDate?
    @NSManaged public var lastSyncOn: NSDate?
    @NSManaged public var latitude: String?
    @NSManaged public var locationCity: String?
    @NSManaged public var locationCountry: String?
    @NSManaged public var locationDate: String?
    @NSManaged public var locationID: String?
    @NSManaged public var locationName: String?
    @NSManaged public var locationType: String?
    @NSManaged public var longitude: String?
    @NSManaged public var modifiedOn: NSDate?
    @NSManaged public var weather: Weather?

}
