//
//  Enums.swift
//  WeatherApp
//
//  Created by kay weng on 01/12/2016.
//  Copyright © 2016 snackcode.org. All rights reserved.
//

import Foundation
import UIKit

public enum Entity:String {
    
    case Location = "Location"
    case Weather = "Weather"
    case WeatherDetail = "WeatherDetail"
}

public enum WeatherResultType:String{
    
    case Astronomy = "Astronomy"
    case Condition = "Condition"
    case Forecast = "Forecast"
    case Forecast10Day = "Forecast10Day"
    case History = "History"
    case Hourly = "Hourly"
    case Planner = "Planner"
    case Tide = "Tide"
    case Yesterday = "Yesterday"
}

public enum WeahterAction:String{
    
    case Alerts = "alerts"
    case Astronomy = "astronomy"
    case Conditions = "conditions"
    case Forecast = "forecast"
    case Forecast10Day = "forecast10day"
    case History = "history"
    case Planner = "planner"
    case Hourly = "hourly"
    case Hourly10Day = "hourly10day"
    case Tide = "tide"
    case Yesterday = "yesterday"
}

public enum LocationType:String{
    
    case Phone = "phone"
    case Home = "home"
    case Office = "office"
    case Country = "country"
    case Domestic = "domestic"
}
public enum WeatherIcon{
    
    case Clear
    case Cloudy
    case CloudFlare
    case Clouds
    case Downpour
    case FogDay
    case FogNight
    case HeavyRain
    case IntenseRain
    case LightRain
    case Sleet
    case ModerateRain
    case PartlyCloudyDay
    case PartlyCloudyNight
    case PartlyCloudyRain
    case Rain
    case Storm
    case Snow
    case Windy
    
    case Unknown
    
    var image:UIImage{

        switch self {
        case .Cloudy, .Clouds:
            return UIImage(named: "Cloudy")!
        case .CloudFlare:
            return UIImage(named: "CloudFlare")!
        case .Downpour:
            return UIImage(named: "Downpour")!
        case .FogDay:
            return UIImage(named: "Fog Day")!
        case .FogNight:
            return UIImage(named: "Fog Night")!
        case .Rain:
            return UIImage(named: "Rain")!
        case .HeavyRain:
            return UIImage(named: "Heavy Rain")!
        case .IntenseRain:
            return UIImage(named: "Intense Rain")!
        case .LightRain:
            return UIImage(named: "Light Rain")!
        case .Sleet:
            return UIImage(named: "Sleet")!
        case .ModerateRain:
            return UIImage(named: "Moderate Rain")!
        case .PartlyCloudyDay:
            return UIImage(named: "Partly Cloudy")!
        case .PartlyCloudyNight:
            return UIImage(named: "Partly Cloudy Night")!
        case .PartlyCloudyRain:
            return UIImage(named: "Partly Cloudy Rain")!
        case .Storm:
            return UIImage(named: "Storm")!
        case .Snow:
            return UIImage(named: "Snow")!
        case .Windy:
            return UIImage(named: "Windy")!
        default:
            return UIImage(named: "Unknown")!
        }
    }
}

public class WeatherStatic{
    
    public static func GetIcon(name:String)->UIImage{
        
        func isNightMode()->Bool{
            
            let hour = Date().hour()
            
            return (hour! > 19 || hour! < 4 ) ? true : false
        }
        
        let night = isNightMode()
        
        if name == "Sunny" || name == "Clear"{
            return WeatherIcon.Clear.image
        }
        
        if name == "Rain"{
            return WeatherIcon.Rain.image
        }
        
        if name == "Chance of Rain"{
            return WeatherIcon.LightRain.image
        }
        
        if name == "Freezing Rain"{
            return WeatherIcon.Sleet.image
        }
        
        if name == "Snow"{
            return WeatherIcon.Snow.image
        }
        
        if name == "Thunderstorm" || name == "Chance of a Thunderstorm"{
            return WeatherIcon.Storm.image
        }
        
        if name == "Partly Sunny" || name == "Mostly Sunny"{
            return WeatherIcon.CloudFlare.image
        }
        
        if name == "Partly Cloudy" || name == "Mostly Cloudy" || name == "Overcast"{
            return !night ? WeatherIcon.PartlyCloudyDay.image : WeatherIcon.PartlyCloudyNight.image
        }
        
        if name == "Scattered Clouds"{
            return WeatherIcon.Clouds.image
        }
        
        if name == "Fog" {
            return !night ? WeatherIcon.FogDay.image : WeatherIcon.FogNight.image
        }
        
        if name == "Flurries"{
            return WeatherIcon.Downpour.image
        }
        
        return WeatherIcon.Unknown.image
    }
}
