//
//  LocationStruct.swift
//  WeatherApp
//
//  Created by kay weng on 31/12/2016.
//  Copyright © 2016 snackcode.org. All rights reserved.
//

import Foundation
import MapKit
import SnackKit

public struct UserLocation{
 
    var createDate:Date?
    var modifiedDate:Date?
    var type:LocationType?
    
    //placemark
    var postalCode:String?{
        didSet{
            self.modifiedDate = Date().now
        }
    }
    var city:String?{
        didSet{
            self.modifiedDate = Date().now
        }
    }
    
    var street:String?{
        didSet{
            self.modifiedDate = Date().now
        }
    }
    
    var state:String?{
        didSet{
            self.modifiedDate = Date().now
        }
    }
    
    var country:String?{
        didSet{
            self.modifiedDate = Date().now
        }
    }
    
    var countryCode:String?{
        didSet{
            self.modifiedDate = Date().now
        }
    }
    
    var name:String?{
        didSet{
            self.modifiedDate = Date().now
        }
    }
    
    var latitude:CLLocationDegrees?{
        didSet{
            self.modifiedDate = Date().now
        }
    }
    
    var longitude:CLLocationDegrees?{
        didSet{
            self.modifiedDate = Date().now
        }
    }
    
    init() {
        
    }
    
    init(geoLocation:GeoLocation) {
        self.latitude = geoLocation.longitude
        self.longitude = geoLocation.longitude
        self.name = geoLocation.name
        
        self.createDate = Date().now
    }
    
    init(address:JSONDictionary) {
        
        self.postalCode = address["ZIP"] as? String
        self.street = address["Street"] as? String
        self.city = address["City"] as? String
        self.state = address["State"] as? String
        self.countryCode = address["CountryCode"] as? String
        self.country = address["Country"] as? String
        
        self.createDate = Date().now
    }
}
