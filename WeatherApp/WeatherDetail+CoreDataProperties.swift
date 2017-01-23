//
//  WeatherDetail+CoreDataProperties.swift
//  WeatherApp
//
//  Created by kay weng on 22/01/2017.
//  Copyright © 2017 snackcode.org. All rights reserved.
//

import Foundation
import CoreData


extension WeatherDetail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherDetail> {
        return NSFetchRequest<WeatherDetail>(entityName: "WeatherDetail");
    }

    @NSManaged public var createdOn: NSDate?
    @NSManaged public var lastSyncOn: NSDate?
    @NSManaged public var modifiedOn: NSDate?
    @NSManaged public var wdID: String?
    @NSManaged public var wdResult: NSObject?
    @NSManaged public var wdType: String?
    @NSManaged public var weather: Weather?

}
