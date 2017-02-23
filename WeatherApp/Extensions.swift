//
//  Extension.swift
//  WeatherApp
//
//  Created by kay weng on 07/01/2017.
//  Copyright © 2017 snackcode.org. All rights reserved.
//

import Foundation
import UIKit
import SnackKit

extension NSLayoutConstraint{
    
    override open var description: String {
        let id = identifier ?? ""
        return "id: \(id), constant: \(constant)" //you may print whatever you want here
    }
}

extension UILabel{
    var defaultFont: UIFont? {
        get { return self.font }
        set { self.font = newValue }
    }
}

extension String {
    
    var degreeFormat:String{
        
        var txt = self
        
        if gTemperatureUnit == .Celsius{
            txt = "\(txt)\(TemperatureUnit.Celsius.symbol)"
        }
        
        if gTemperatureUnit == .Fahrenheit{
            txt = "\(txt)\(TemperatureUnit.Fahrenheit.symbol)"
        }
        
        return txt
    }
    
    var hour12Format:String{
        
        let arr = self.components(separatedBy: ":")
        var ampm:String = ""
        let hours:Int = "\(arr[0])".int!
        
        ampm = hours > 12 ? "PM" : "AM"
        
        return "\(ampm == "AM" ? hours : hours - 12):\(arr[1]) \(ampm)"
    }
    
    var uvDescription:String{

        var description = ""
        let uv = "\(self)".double!
        
        switch uv{
        case 0..<3.0:
            description = "Low"
        case 3.0..<6.0:
            description = "Moderate"
        case 6.0..<8.0:
            description = "High"
        case 8.0..<11:
            description = "Very High"
        case 11..<100:
            description = "Extreme"
        default:
            description = "Normal"
        }

        return  description + " level of UV"
    }
}
