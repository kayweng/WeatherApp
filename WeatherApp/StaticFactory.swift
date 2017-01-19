//
//  AppFactory.swift
//  WeatherApp
//
//  Created by kay weng on 11/01/2017.
//  Copyright © 2017 snackcode.org. All rights reserved.
//

import Foundation
import SnackKit

public class StaticFactory{
    
    public static func currentPartOfDay()->PartsOfDay{
        
        let hour = Date().now.hour()!
        
        switch hour {
        case 5...13:
            return PartsOfDay.Morning
        case 13..<17:
            return PartsOfDay.Afternoon
        case 17..<21:
            return PartsOfDay.Evening
        default:
            return PartsOfDay.Night
        }
    }
}
