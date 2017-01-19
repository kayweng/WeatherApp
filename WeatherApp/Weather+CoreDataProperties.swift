//
//  Weather+CoreDataProperties.swift
//  WeatherApp
//
//  Created by kay weng on 20/01/2017.
//  Copyright © 2017 snackcode.org. All rights reserved.
//

import Foundation
import CoreData


extension Weather {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Weather> {
        return NSFetchRequest<Weather>(entityName: "Weather");
    }

    @NSManaged public var createdOn: NSDate?
    @NSManaged public var modifiedOn: NSDate?
    @NSManaged public var weatherID: String?
    @NSManaged public var weatherDate: NSDate?
    @NSManaged public var lastSyncOn: NSDate?
    @NSManaged public var location: Location?
    @NSManaged public var detail: WeatherDetail?

}
