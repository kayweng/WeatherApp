//
//  Weather+CoreDataProperties.swift
//  WeatherApp
//
//  Created by kay weng on 23/01/2017.
//  Copyright © 2017 snackcode.org. All rights reserved.
//

import Foundation
import CoreData


extension Weather {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Weather> {
        return NSFetchRequest<Weather>(entityName: "Weather");
    }

    @NSManaged public var createdOn: NSDate?
    @NSManaged public var lastSyncOn: NSDate?
    @NSManaged public var modifiedOn: NSDate?
    @NSManaged public var weatherDate: String?
    @NSManaged public var weatherID: String?
    @NSManaged public var detail: NSSet?
    @NSManaged public var location: Location?

}

// MARK: Generated accessors for detail
extension Weather {

    @objc(addDetailObject:)
    @NSManaged public func addToDetail(_ value: WeatherDetail)

    @objc(removeDetailObject:)
    @NSManaged public func removeFromDetail(_ value: WeatherDetail)

    @objc(addDetail:)
    @NSManaged public func addToDetail(_ values: NSSet)

    @objc(removeDetail:)
    @NSManaged public func removeFromDetail(_ values: NSSet)

}
