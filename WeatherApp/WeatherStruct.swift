//
//  WeatherStruct.swift
//  WeatherApp
//
//  Created by kay weng on 30/11/2016.
//  Copyright © 2016 snackcode.org. All rights reserved.
//

import Foundation
import SnackKit

typealias Time = (hour:String, minutes:String, seconds:String)
typealias WDate = (day:String, month:String, year:String, hour:String, min:String, sec:String, ampm:String)
typealias DateDescription = (month:String, month_short:String, weekday:String, weekday_short:String)

typealias Coordination = (latitude:String, longitude:String, elevation:String)
typealias Temperature = (celsius:String, fahrenheit:String, fullString:String)
typealias Visibility = (mi:String, km:String)
typealias FeelLike = (celsius:String, fahrenheit:String, fullString:String)
typealias Icon = (description:String, url:String)
typealias Wind = (mph:String, kph:String, dir:String, degrees: Double)
typealias Conditions = (fog:Bool, rain:Bool, snow:Bool, hail:Bool, thunder:Bool, tornado:Bool)
typealias TextForecast = (period:Int, title:String, description:String, metric:String)
typealias SimpleForecast = (period:Int, high:Temperature, low:Temperature, conditions:String, maxWind:Wind, avgWind:Wind, aveHumdity:Double, maxHumidity:Double, minHumidity:Double, dateTime:WDate, month:DateDescription)

public struct Container<T>{
 
    var item:[T] = [] {
        didSet{
            self.itemDidLoad?(item)
        }
    }
    
    init(){
        
    }
    
    init(object:T) {
        self.item.append(object)
    }
    
    var itemDidLoad: ((_ item: [T]) -> Void)?
}

public class IWeatherResult : NSObject, NSCoding {
    
    override init() {
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
    }

    public func encode(with aCoder: NSCoder) {
        
    }
}

//http://api.wunderground.com/api/826830b16b7d2179/astronomy/q/Australia/Sydney.json
public class AstronomyResult : IWeatherResult{
    
    var moonPhase:(percentIlluminated:String, ageOfMoon:String, current_time:Time)?
    var sunrise:Time?
    var sunset:Time?
    var moonrise:Time?
    var moonset:Time?
    
    init(_ json:JSONDictionary) {
        super.init()
        
        if let sun:JSONDictionary = json["sun_phase"] as? JSONDictionary{
            
            let sr = sun["sunrise"] as! JSONDictionary
            let se = sun["sunset"] as! JSONDictionary
            
            sunrise = ("\(sr["hour"]!)","\(sr["minute"]!)","")
            sunset = ("\(se["hour"]!)","\(se["minute"]!)","")
        }
        
        if let moon:JSONDictionary = json["moon_phase"] as? JSONDictionary{
            
            let mr =  moon["moonrise"] as! JSONDictionary
            let me = moon["moonset"] as! JSONDictionary
            let il = moon["percentIlluminated"] as! String
            let ag = moon["ageOfMoon"] as! String
            let cr = moon["current_time"] as! JSONDictionary
            
            moonPhase = (il, ag,("\(cr["hour"]!)","\(cr["minute"]!)",""))
            moonrise = ("\(mr["hour"]!)","\(mr["minute"]!)","")
            moonset = ("\(me["hour"]!)","\(me["minute"]!)","")
        }
    }
    
    init(result:AstronomyResult){
        super.init()

        self.moonPhase = result.moonPhase
        self.moonrise = result.moonrise
        self.moonset = result.moonset
        
        self.sunrise = result.sunrise
        self.sunset = result.sunset
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //Sunrise
        self.sunrise!.hour = aDecoder.decodeObject(forKey: "sunrise.hour")! as! String
        self.sunrise!.minutes = aDecoder.decodeObject(forKey: "sunrise.minutes")! as! String
        self.sunrise!.seconds = aDecoder.decodeObject(forKey: "sunrise.seconds")! as! String
        
        //Sunset
        self.sunset!.hour = aDecoder.decodeObject(forKey: "sunset.hour")! as! String
        self.sunset!.minutes = aDecoder.decodeObject(forKey: "sunset.minutes")! as! String
        self.sunset!.seconds = aDecoder.decodeObject(forKey: "sunset.seconds")! as! String
    
        //MoonPhase
        self.moonPhase!.ageOfMoon = aDecoder.decodeObject(forKey: "moonPhase.ageOfMoon")! as! String
        self.moonPhase!.percentIlluminated = aDecoder.decodeObject(forKey: "moonPhase.percentIlluminated")! as! String
        self.moonPhase!.current_time.hour = aDecoder.decodeObject(forKey: "moonPhase.current_time.hour")! as! String
        self.moonPhase!.current_time.minutes = aDecoder.decodeObject(forKey: "moonPhase.current_time.minutes")! as! String
        self.moonPhase!.current_time.seconds = aDecoder.decodeObject(forKey: "moonPhase.current_time.seconds")! as! String
        
        //Moonrise
        self.moonrise!.hour = aDecoder.decodeObject(forKey: "moonrise.hour")! as! String
        self.moonrise!.minutes = aDecoder.decodeObject(forKey: "moonrise.minutes")! as! String
        self.moonrise!.seconds = aDecoder.decodeObject(forKey: "moonrise.seconds")! as! String
     
        //Moonset
        self.moonset!.hour = aDecoder.decodeObject(forKey: "moonset.hour")! as! String
        self.moonset!.minutes = aDecoder.decodeObject(forKey: "moonset.minutes")! as! String
        self.moonset!.seconds = aDecoder.decodeObject(forKey: "moonset.seconds")! as! String
    }
    
    public override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        
        //Sunrise
        aCoder.encode(self.sunrise?.hour,forKey: "sunrise.hour")
        aCoder.encode(self.sunrise?.minutes,forKey: "sunrise.minutes")
        aCoder.encode(self.sunrise?.seconds,forKey: "sunrise.seconds")
        
        //Sunset
        aCoder.encode(self.sunset?.hour,forKey: "sunset.hour")
        aCoder.encode(self.sunset?.minutes,forKey: "sunset.minutes")
        aCoder.encode(self.sunset?.seconds,forKey: "sunset.seconds")
        
        //MoonPhase
        aCoder.encode(self.moonPhase?.ageOfMoon,forKey: "moonPhase.ageOfMoon")
        aCoder.encode(self.moonPhase?.percentIlluminated,forKey: "moonPhase.percentIlluminated")
        aCoder.encode(self.moonPhase?.current_time.hour,forKey: "moonPhase.current_time.hour")
        aCoder.encode(self.moonPhase?.current_time.minutes,forKey: "moonPhase.current_time.minutes")
        aCoder.encode(self.moonPhase?.current_time.seconds,forKey: "moonPhase.current_time.seconds")
        
        //Moonrise
        aCoder.encode(self.moonrise?.hour,forKey: "moonrise.hour")
        aCoder.encode(self.moonrise?.minutes,forKey: "moonrise.minutes")
        aCoder.encode(self.moonrise?.seconds,forKey: "moonrise.seconds")
        
        //Moonset
        aCoder.encode(self.moonset?.hour,forKey: "moonsethour")
        aCoder.encode(self.moonset?.minutes,forKey: "moonset.minutes")
        aCoder.encode(self.moonset?.seconds,forKey: "moonset.seconds")
    }
    
}

//Returns the current temperature, weather condition, humidity, wind, 'feels like' temperature, barometric pressure, and visibility.
//http://api.wunderground.com/api/826830b16b7d2179/conditions/q/CA/San_Francisco.json
public class ConditionsResult: IWeatherResult{
    
    var displayLocation:(full:String, city:String, country:String, location:Coordination)?
    var observationLocation:(full:String, city:String, country:String, location:Coordination)?
    var weather:(temp:Temperature,description:String,humidity:String)?
    var feel:FeelLike?
    var wind:Wind?
    var visibility:Visibility?
    var icon:String?
    var uv:String?
    
    init(_ json:JSONDictionary) {
        super.init()
        
        if let co = json["current_observation"] as? JSONDictionary{
            
            if let dp = co["display_location"] as? JSONDictionary{
                
                displayLocation = ("\(dp["full"]!)","\(dp["city"]!)","\(dp["state_name"]!)",("\(dp["latitude"]!)","\(dp["longitude"])","\(dp["elevation"])"))
            }
            
            if let ol = co["observation_location"] as? JSONDictionary{
                
                observationLocation = ("\(ol["full"]!)","\(ol["city"]!)","\(ol["country"]!)",("\(ol["latitude"]!)","\(ol["longitude"]!)","\(ol["elevation"]!)"))
            }
            
            let desc = co["weather"] as? String
            let temp = ("\(co["temp_c"]!)","\(co["temp_f"]!)","\(co["temperature_string"]!)")
            let hum  = co["relative_humidity"] as? String
            
            uv = co["UV"] as? String
            weather = (temp,desc!,hum!)
            icon = co["icon"] as? String
            feel = ("\(co["feelslike_c"]!)","\(co["feelslike_f"]!)","\(co["feelslike_string"]!)")
            wind = ("\(co["wind_mph"]!)", "\(co["wind_kph"]!)", "\(co["wind_dir"]!)", co["wind_degrees"] as! Double)
            visibility = ("\(co["visibility_mi"]!)", "\(co["visibility_km"]!)")
        }
        
    }
    
    init(result:ConditionsResult){
        super.init()
        
        self.displayLocation = result.displayLocation
        self.observationLocation = result.observationLocation
        self.uv = result.uv
        self.weather = result.weather
        self.icon = result.icon
        self.feel = result.feel
        self.wind = result.wind
        self.visibility = result.visibility
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init()
        
        //DisplayLocation
        self.displayLocation?.city = aDecoder.decodeObject(forKey: "displayLocation.city")! as! String
        self.displayLocation!.country = aDecoder.decodeObject(forKey: "displayLocation.country")! as! String
        self.displayLocation!.full = aDecoder.decodeObject(forKey: "displayLocation.full")! as! String
        self.displayLocation!.location.elevation = aDecoder.decodeObject(forKey: "displayLocation.location.elevation")! as! String
        self.displayLocation!.location.latitude = aDecoder.decodeObject(forKey: "displayLocation.location.latitude")! as! String
        self.displayLocation!.location.longitude = aDecoder.decodeObject(forKey: "displayLocation.location.longitude")! as! String
        
        //ObservationLocation
        self.observationLocation!.city = aDecoder.decodeObject(forKey: "observationLocation.city")! as! String
        self.observationLocation!.country = aDecoder.decodeObject(forKey: "observationLocation.country")! as! String
        self.observationLocation!.full = aDecoder.decodeObject(forKey: "observationLocation.full")! as! String
        self.observationLocation!.location.elevation = aDecoder.decodeObject(forKey: "observationLocation.location.elevation")! as! String
        self.observationLocation!.location.latitude = aDecoder.decodeObject(forKey: "observationLocation.location.latitude")! as! String
        self.observationLocation!.location.longitude = aDecoder.decodeObject(forKey: "observationLocation.location.longitude")! as! String
        
        //UV
        self.uv = aDecoder.decodeObject(forKey: "uv")! as? String
        
        //Weather
        self.weather!.temp.celsius = aDecoder.decodeObject(forKey: "weather.temp.celsius") as! String
        self.weather!.temp.fahrenheit = aDecoder.decodeObject(forKey: "weather.temp.fahrenheit") as! String
        self.weather!.temp.fullString = aDecoder.decodeObject(forKey: "weather.temp.fullString") as! String
        
        //Icon
        self.icon! = aDecoder.decodeObject(forKey: "icon") as! String
        
        //Feel
        self.feel!.celsius = aDecoder.decodeObject(forKey: "feel.celsius") as! String
        self.feel!.fahrenheit = aDecoder.decodeObject(forKey: "feel.fahrenheit") as! String
        self.feel!.fullString = aDecoder.decodeObject(forKey: "feel.fullString") as! String
        
        //Wind
        self.wind!.mph = aDecoder.decodeObject(forKey: "wind.mph") as! String
        self.wind!.kph = aDecoder.decodeObject(forKey: "wind.kph") as! String
        self.wind!.dir = aDecoder.decodeObject(forKey: "wind.dir") as! String
        self.wind!.degrees = aDecoder.decodeDouble(forKey: "wind.degrees") as! Double

        //Visibility
        self.visibility!.mi = aDecoder.decodeObject(forKey: "visibility.mi") as! String
        self.visibility!.km = aDecoder.decodeObject(forKey: "visibility.km") as! String
    }
    
    public override func encode(with aCoder: NSCoder) {
        
        //DisplayLocation
        aCoder.encode(self.displayLocation?.city, forKey:"displayLocation.city")
        aCoder.encode(self.displayLocation?.country, forKey:"displayLocation.country")
        aCoder.encode(self.displayLocation?.full, forKey:"displayLocation.full")
        aCoder.encode(self.displayLocation?.location.elevation, forKey:"displayLocation.location.elevation")
        aCoder.encode(self.displayLocation?.location.latitude, forKey:"displayLocation.location.latitude")
        aCoder.encode(self.displayLocation?.location.longitude, forKey:"displayLocation.location.longitude")

        //ObservationLocation
        aCoder.encode(self.observationLocation?.city, forKey:"observationLocation.city")
        aCoder.encode(self.observationLocation?.country, forKey:"observationLocation.country")
        aCoder.encode(self.observationLocation?.full, forKey:"observationLocation.full")
        aCoder.encode(self.observationLocation?.location.elevation, forKey:"observationLocation.location.elevation")
        aCoder.encode(self.observationLocation?.location.latitude, forKey:"observationLocation.location.latitude")
        aCoder.encode(self.observationLocation?.location.longitude, forKey:"observationLocation.location.longitude")
        
        //UV
        aCoder.encode(self.uv, forKey:"uv")
        
        //Weather
        aCoder.encode(self.weather?.temp.celsius, forKey:"weather.temp.celsius")
        aCoder.encode(self.weather?.temp.fahrenheit, forKey:"weather.temp.fahrenheit")
        aCoder.encode(self.weather?.temp.fullString, forKey:"weather.temp.fullString")
        aCoder.encode(self.weather?.humidity, forKey:"weather.humidity")
        aCoder.encode(self.weather?.description, forKey:"weather.description")

        //Icon
        aCoder.encode(self.icon, forKey:"icon")
        
        //Feel
        aCoder.encode(self.feel?.celsius, forKey:"feel.celsius")
        aCoder.encode(self.feel?.fahrenheit, forKey:"feel.fahrenheit")
        aCoder.encode(self.feel?.fullString, forKey:"feel.fullString")
        
        //Wind
        aCoder.encode(self.wind?.mph, forKey:"wind.mph")
        aCoder.encode(self.wind?.kph, forKey:"wind.kph")
        aCoder.encode(self.wind?.dir, forKey:"wind.dir")
        aCoder.encode(self.wind?.degrees, forKey:"wind.degrees")
     
        //Visibility
        aCoder.encode(self.visibility?.mi, forKey:"visibility.mi")
        aCoder.encode(self.visibility?.km, forKey:"visibility.km")
    }
}

//Returns a summary of the weather for the next 3 days. 
//This includes high and low temperatures, a string text forecast and the conditions.
//http://api.wunderground.com/api/826830b16b7d2179/forecast/q/CA/San_Francisco.json
public class ForecastResult: IWeatherResult{
    
    var forecastText:[TextForecast] = []
    var simplyForecast:[SimpleForecast] = []
    
    init(_ json:JSONDictionary) {
        super.init()
        
        if let fo = json["forecast"] as? JSONDictionary{
            
            if let tf = fo["txt_forecast"] as? JSONDictionary{
                
                if let fd = tf["forecastday"] as? JSONArray{
                    
                    for item in fd {
                        
                        let period = item["period"]!! as! Int
                        let title = item["title"]!! as! String
                        let desc = item["fcttext"]!! as! String
                        let metric = item["fcttext_metric"]!! as! String
                        //(period:Int, title:String, description:String, metric:String)
                        forecastText.append((period,title,desc,metric))
                    }
                }
            }
            
            if let sf = fo["simpleforecast"] as? JSONDictionary{
             
                if let fd = sf["forecastday"] as? JSONArray{
                    
                    for item in fd {
                        
                        let period = item["period"]!! as! Int
                        let high = item["high"]!! as! JSONDictionary
                        let low = item["low"]!! as! JSONDictionary
                        let cond = item["conditions"] as! String
                        let mw = item["maxwind"] as! JSONDictionary
                        let aw = item["avewind"] as! JSONDictionary
                        let avgAh = item["avehumidity"] as! Double
                        let maxAh = item["maxhumidity"] as! Double
                        let minAh = item["minhumidity"] as! Double
                        let date = item["date"] as! JSONDictionary
                       
                        let highTemp = ("\(high["celsius"]!)", "\(high["fahrenheit"]!)", "")
                        let lowTemp = ("\(low["celsius"]!)", "\(low["fahrenheit"]!)", "")
                        let maxWind:Wind = ("\(mw["mph"]!)","\(mw["kph"]!)","\(mw["dir"]!)",mw["degrees"] as! Double)
                        let avgWind:Wind = ("\(aw["mph"]!)","\(aw["kph"]!)","\(aw["dir"]!)",aw["degrees"] as! Double)
                        let wDate = ("\(date["day"]!)", "\(date["month"]!)", "\(date["year"]!)", "\(date["hour"]!)","\(date["min"]!)", "\(date["sec"]!)", "\(date["ampm"]!)")
                        let dateDescription = ("\(date["monthname"]!)", "\(date["monthname_short"]!)", "\(date["weekday"]!)", "\(date["weekday_short"]!)")
                        
                        simplyForecast.append((period, highTemp, lowTemp, cond, maxWind, avgWind, avgAh, maxAh, minAh, wDate, dateDescription))
                    }
                }
            }
        }

    }
 
    public required init?(coder aDecoder: NSCoder) {
        super.init()
     
        //forecast Text
        for i in 0...7{
            let period = aDecoder.decodeInt32(forKey: "forecastText.period.\(i)")
            let title = aDecoder.decodeObject(forKey: "forecastText.title.\(i)")! as! String
            let desc = aDecoder.decodeObject(forKey: "forecastText.desc.\(i)")! as! String
            let metric = aDecoder.decodeObject(forKey: "forecastText.metric.\(i)")! as! String
            
            self.forecastText.append((Int(period),title,desc,metric))
        }
     
        //simple forecast
        for i in 0...3{
            let period = aDecoder.decodeInt32(forKey: "simplyForecast.period.\(i)")
         
            let highTemp = (aDecoder.decodeObject(forKey: "simplyForecast.high.celsius.\(i)") as! String,
                            aDecoder.decodeObject(forKey: "simplyForecast.high.fahrenheit.\(i)") as! String,
                            aDecoder.decodeObject(forKey: "simplyForecast.high.fullString.\(i)") as! String)
         
            let lowTemp = (aDecoder.decodeObject(forKey: "simplyForecast.low.celsius.\(i)") as! String, 
                           aDecoder.decodeObject(forKey: "simplyForecast.low.fahrenheit.\(i)") as! String,
                           aDecoder.decodeObject(forKey: "simplyForecast.low.fullString.\(i)") as! String)
         
            let cond = aDecoder.decodeObject(forKey: "simplyForecast.conditions.\(i)") as! String

            let maxWind:Wind = (aDecoder.decodeObject(forKey: "simplyForecast.maxWind.mph.\(i)") as! String,
                                aDecoder.decodeObject(forKey: "simplyForecast.maxWind.kph.\(i)") as! String,
                                aDecoder.decodeObject(forKey: "simplyForecast.maxWind.dir.\(i)") as! String,
                                aDecoder.decodeDouble(forKey: "simplyForecast.maxWind.degrees.\(i)") )
         
            let avgWind:Wind = (aDecoder.decodeObject(forKey: "simplyForecast.avgWind.mph.\(i)") as! String,
                                aDecoder.decodeObject(forKey: "simplyForecast.avgWind.kph.\(i)") as! String,
                                aDecoder.decodeObject(forKey: "simplyForecast.avgWind.dir.\(i)") as! String,
                                aDecoder.decodeDouble(forKey: "simplyForecast.avgWind.degrees.\(i)") )
         
            let avgAh = aDecoder.decodeDouble(forKey: "simplyForecast.aveHumdity.\(i)")
            
            let maxAh = aDecoder.decodeDouble(forKey: "simplyForecast.maxHumidity.\(i)") 
            
            let minAh = aDecoder.decodeDouble(forKey: "simplyForecast.minHumidity.\(i)") 
         
            let wDate = (aDecoder.decodeObject(forKey: "simplyForecast.dateTime.day.\(i)") as! String, 
                         aDecoder.decodeObject(forKey: "simplyForecast.dateTime.month.\(i)") as! String,
                         aDecoder.decodeObject(forKey: "simplyForecast.dateTime.year.\(i)") as! String,
                         aDecoder.decodeObject(forKey: "simplyForecast.dateTime.hour.\(i)") as! String,
                         aDecoder.decodeObject(forKey: "simplyForecast.dateTime.min.\(i)") as! String,
                         aDecoder.decodeObject(forKey: "simplyForecast.dateTime.sec.\(i)") as! String,
                         aDecoder.decodeObject(forKey: "simplyForecast.dateTime.ampm.\(i)") as! String)
                         
            let dateDescription = (aDecoder.decodeObject(forKey: "simplyForecast.month.month.\(i)") as! String,
                                   aDecoder.decodeObject(forKey: "simplyForecast.month.month_short.\(i)") as! String,
                                   aDecoder.decodeObject(forKey: "simplyForecast.month.weekday.\(i)") as! String,
                                   aDecoder.decodeObject(forKey: "simplyForecast.month.weekday_short.\(i)") as! String)
                        
            simplyForecast.append((Int(period), highTemp, lowTemp, cond, maxWind, avgWind, avgAh, maxAh, minAh, wDate, dateDescription))
        }
    }
 
    public override func encode(with aCoder: NSCoder) {
     
        //forecastText
        for i in 0...7 {
            aCoder.encode(self.forecastText[i].period, forKey:"forecastText.period.\(i)")
            aCoder.encode(self.forecastText[i].title, forKey:"forecastText.title.\(i)")
            aCoder.encode(self.forecastText[i].description, forKey:"forecastText.desc.\(i)")
            aCoder.encode(self.forecastText[i].metric, forKey:"forecastText.metric.\(i)")
        }
        
        //simple forecast
        for i in 0...3 {
            
            aCoder.encode(self.simplyForecast[i].period, forKey:"simplyForecast.period.\(i)")
            
            aCoder.encode(self.simplyForecast[i].high.celsius, forKey:"simplyForecast.high.celsius.\(i)")
            aCoder.encode(self.simplyForecast[i].high.fahrenheit, forKey:"simplyForecast.high.fahrenheit.\(i)")
            aCoder.encode(self.simplyForecast[i].high.fullString, forKey:"simplyForecast.high.fullString.\(i)")
         
            aCoder.encode(self.simplyForecast[i].low.celsius, forKey:"simplyForecast.low.celsius.\(i)")
            aCoder.encode(self.simplyForecast[i].low.fahrenheit, forKey:"simplyForecast.low.fahrenheit.\(i)")
            aCoder.encode(self.simplyForecast[i].low.fullString, forKey:"simplyForecast.low.fullString.\(i)")
            
            aCoder.encode(self.simplyForecast[i].conditions, forKey:"simplyForecast.conditions.\(i)")
         
            aCoder.encode(self.simplyForecast[i].maxWind.mph, forKey:"simplyForecast.maxWind.mph.\(i)")
            aCoder.encode(self.simplyForecast[i].maxWind.kph, forKey:"simplyForecast.maxWind.kph.\(i)")
            aCoder.encode(self.simplyForecast[i].maxWind.dir, forKey:"simplyForecast.maxWind.dir.\(i)")
            aCoder.encode(self.simplyForecast[i].maxWind.degrees, forKey:"simplyForecast.maxWind.degrees.\(i)")
         
            aCoder.encode(self.simplyForecast[i].avgWind.mph, forKey:"simplyForecast.avgWind.mph.\(i)")
            aCoder.encode(self.simplyForecast[i].avgWind.kph, forKey:"simplyForecast.avgWind.kph.\(i)")
            aCoder.encode(self.simplyForecast[i].avgWind.dir, forKey:"simplyForecast.avgWind.dir.\(i)")
            aCoder.encode(self.simplyForecast[i].avgWind.degrees, forKey:"simplyForecast.avgWind.degrees.\(i)")
            
            aCoder.encode(self.simplyForecast[i].aveHumdity, forKey:"simplyForecast.aveHumdity.\(i)")
            aCoder.encode(self.simplyForecast[i].maxHumidity, forKey:"simplyForecast.maxHumidity.\(i)")
            aCoder.encode(self.simplyForecast[i].minHumidity, forKey:"simplyForecast.minHumidity.\(i)")
         
            aCoder.encode(self.simplyForecast[i].dateTime.day, forKey:"simplyForecast.dateTime.day.\(i)")
            aCoder.encode(self.simplyForecast[i].dateTime.month, forKey:"simplyForecast.dateTime.month.\(i)")
            aCoder.encode(self.simplyForecast[i].dateTime.year, forKey:"simplyForecast.dateTime.year.\(i)")
            aCoder.encode(self.simplyForecast[i].dateTime.hour, forKey:"simplyForecast.dateTime.hour.\(i)")
            aCoder.encode(self.simplyForecast[i].dateTime.min, forKey:"simplyForecast.dateTime.min.\(i)")
            aCoder.encode(self.simplyForecast[i].dateTime.sec, forKey:"simplyForecast.dateTime.sec.\(i)")
            aCoder.encode(self.simplyForecast[i].dateTime.ampm, forKey:"simplyForecast.dateTime.ampm.\(i)")
           
            aCoder.encode(self.simplyForecast[i].month.month, forKey:"simplyForecast.month.month.\(i)")
            aCoder.encode(self.simplyForecast[i].month.month_short, forKey:"simplyForecast.month.month_short.\(i)")
            aCoder.encode(self.simplyForecast[i].month.weekday, forKey:"simplyForecast.month.weekday.\(i)")
            aCoder.encode(self.simplyForecast[i].month.weekday_short, forKey:"simplyForecast.month.weekday_short.\(i)")
        }
    }
}

//http://api.wunderground.com/api/826830b16b7d2179/history_20060405/q/CA/San_Francisco.json
public class HistoryResult: IWeatherResult{
    
    var history:[(date:WDate, temp:Temperature, cond:Conditions)] = []
    
    init(_ json:JSONDictionary) {
        super.init()
        
        if let hs = json["history"] as? JSONDictionary{
         
            if let ob = hs["observations"] as? JSONArray{
                
                for item in ob{
                 
                    let d = item["date"] as! JSONDictionary
                    let wDate = ("\(d["mday"]!)", "\(d["mon"]!)","\(d["year"]!)","\(d["hour"]!)","\(d["min"]!)","","")
                    let temp = ("\(item["tempm"]!!)", "\(item["tempi"]!!)", "")
                    let conditions = (item["fog"] as! String == "0" ? false : true,
                                      item["rain"] as! String == "0" ? false : true,
                                      item["snow"] as! String == "0" ? false : true,
                                      item["hail"] as! String == "0" ? false : true,
                                      item["thunder"] as! String == "0" ? false : true,
                                      item["tornado"] as! String == "0" ? false : true)

                    history.append((wDate,temp,conditions))
                }
            }
        }

    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init()
     
         for i in 0...23{

             let wDate = (aDecoder.decodeObject(forKey: "history.date.day.\(i)") as! String, 
                          aDecoder.decodeObject(forKey: "history.date.month.\(i)") as! String,
                          aDecoder.decodeObject(forKey: "history.date.year.\(i)") as! String,
                          aDecoder.decodeObject(forKey: "history.date.hour.\(i)") as! String,
                          aDecoder.decodeObject(forKey: "history.date.min.\(i)") as! String,
                          "","")
          
             let temp = (aDecoder.decodeObject(forKey: "history.temp.celsius.\(i)") as! String, 
                         aDecoder.decodeObject(forKey: "history.temp.fahrenheit.\(i)") as! String,
                         aDecoder.decodeObject(forKey: "history.temp.fullString.\(i)") as! String)
          
             let conditions = (aDecoder.decodeBool(forKey: "history.cond.fog.\(i)") as! Bool,
                               aDecoder.decodeBool(forKey: "history.cond.rain.\(i)") as! Bool,
                               aDecoder.decodeBool(forKey: "history.cond.snow.\(i)") as! Bool,
                               aDecoder.decodeBool(forKey: "history.cond.hail.\(i)") as! Bool,
                               aDecoder.decodeBool(forKey: "history.cond.thunder.\(i)") as! Bool,
                               aDecoder.decodeBool(forKey: "history.cond.tornado.\(i)") as! Bool)

            history.append((wDate,temp,conditions))
        }
    }
 
    public override func encode(with aCoder: NSCoder) {
    
        for i in 0...23{
            aCoder.encode(self.history[i].date.day, forKey:"history.date.day.\(i)")
            aCoder.encode(self.history[i].date.month, forKey:"history.date.month.\(i)")
            aCoder.encode(self.history[i].date.year, forKey:"history.date.year.\(i)")
            aCoder.encode(self.history[i].date.hour, forKey:"history.date.hour.\(i)")
            aCoder.encode(self.history[i].date.min, forKey:"history.date.min.\(i)")
            aCoder.encode(self.history[i].date.sec, forKey:"history.date.sec.\(i)")
            aCoder.encode(self.history[i].date.ampm, forKey:"history.date.ampm.\(i)")

            aCoder.encode(self.history[i].temp.celsius, forKey:"history.temp.celsius.\(i)")
            aCoder.encode(self.history[i].temp.fahrenheit, forKey:"history.temp.fahrenheit.\(i)")
            aCoder.encode(self.history[i].temp.fullString, forKey:"history.temp.fullString.\(i)")
         
            aCoder.encode(self.history[i].cond.fog, forKey:"history.cond.fog.\(i)")
            aCoder.encode(self.history[i].cond.rain, forKey:"history.cond.rain.\(i)")
            aCoder.encode(self.history[i].cond.snow, forKey:"history.cond.snow.\(i)")
            aCoder.encode(self.history[i].cond.hail, forKey:"history.cond.hail.\(i)")
            aCoder.encode(self.history[i].cond.thunder, forKey:"history.cond.thunder.\(i)")
            aCoder.encode(self.history[i].cond.tornado, forKey:"history.cond.tornado.\(i)")
        }
    }
}

//http://api.wunderground.com/api/826830b16b7d2179/hourly/q/CA/San_Francisco.json
//http://api.wunderground.com/api/826830b16b7d2179/hourly10day/q/CA/San_Francisco.json
public class HourlyResult : IWeatherResult{
    
    var hours:[(wDate:WDate, description:DateDescription, high:Temperature, low:Temperature, cond:String, humidity:String, feelLike:Temperature, uvindex:String, wind:Wind)] = []
    
     init(_ json:JSONDictionary) {
        super.init()
        
        if let hr = json["hourly_forecast"] as? JSONArray{
            
            for item in hr{
                
                let fc = item["FCTTIME"] as! JSONDictionary
                let tp = item["temp"] as! JSONDictionary
                let dp = item["dewpoint"] as! JSONDictionary
                let fl = item["feelslike"] as! JSONDictionary
                let wspd = item["wspd"] as! JSONDictionary
                let wdir = item["wdir"] as! JSONDictionary
                
                let wDate = (fc["mday"] as! String, fc["mon"] as! String, fc["year"] as! String, fc["hour"] as! String, fc["min"] as! String, fc["sec"] as! String, fc["ampm"] as! String)
                let dDescription = (fc["month_name"] as! String, fc["mon_abbrev"] as! String, fc["weekday_name"] as! String, fc["weekday_name_abbrev"] as! String)
                let high = (tp["metric"] as! String, tp["english"] as! String,"")
                let low = (dp["metric"] as! String, dp["english"] as! String,"")
                let cond = item["condition"] as! String
                let humi = item["humidity"] as! String
                let feel = (fl["metric"] as! String, fl["english"] as! String,"")
                let uv = item["uvi"] as! String
                let wind:Wind = (wspd["metric"] as! String, wspd["english"] as! String, wdir["dir"] as! String, (wdir["degrees"] as! String).double!)
                
                hours.append((wDate,dDescription,high,low,cond,humi,feel,uv,wind))
            }
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init()    
     
        for i in 0...35{
         
            let wDate = (aDecoder.decodeObject(forKey: "hours.wDate.day.\(i)") as! String, 
                         aDecoder.decodeObject(forKey: "hours.wDate.month.\(i)") as! String, 
                         aDecoder.decodeObject(forKey: "hours.wDate.year.\(i)") as! String, 
                         aDecoder.decodeObject(forKey: "hours.wDate.hour.\(i)") as! String,
                         aDecoder.decodeObject(forKey: "hours.wDate.min.\(i)") as! String, 
                         aDecoder.decodeObject(forKey: "hours.wDate.sec.\(i)") as! String, 
                         aDecoder.decodeObject(forKey: "hours.wDate.ampm.\(i)") as! String)
         
            let dDescription = (aDecoder.decodeObject(forKey: "hours.description.month.\(i)") as! String, 
                                aDecoder.decodeObject(forKey: "hours.description.month_short.\(i)") as! String, 
                                aDecoder.decodeObject(forKey: "hours.description.weekday.\(i)") as! String, 
                                aDecoder.decodeObject(forKey: "hours.description.weekday_short.\(i)") as! String)
         
            let high = (aDecoder.decodeObject(forKey: "hours.high.celsius.\(i)") as! String, 
                        aDecoder.decodeObject(forKey: "hours.high.farehenit.\(i)") as! String, 
                        aDecoder.decodeObject(forKey: "hours.high.fullString.\(i)") as! String)
         
            let low = (aDecoder.decodeObject(forKey: "hours.low.celsius.\(i)") as! String, 
                       aDecoder.decodeObject(forKey: "hours.low.farehenit.\(i)") as! String, 
                       aDecoder.decodeObject(forKey: "hours.low.fullString.\(i)") as! String)
         
            let cond = aDecoder.decodeObject(forKey: "hours.cond.\(i)") as! String
            let humi = aDecoder.decodeObject(forKey: "hours.humidity.\(i)") as! String
         
            let feel = (aDecoder.decodeObject(forKey: "hours.feelLike.celsius.\(i)") as! String, 
                       aDecoder.decodeObject(forKey: "hours.feelLike.farehenit.\(i)") as! String, 
                       aDecoder.decodeObject(forKey: "hours.feelLike.fullString.\(i)") as! String)
         
            let uv = aDecoder.decodeObject(forKey: "hours.uvindex.\(i)") as! String
            
      
            let wind:Wind = (aDecoder.decodeObject(forKey: "hours.wind.mph.\(i)") as! String,
                             aDecoder.decodeObject(forKey: "hours.wind.kph.\(i)") as! String,
                             aDecoder.decodeObject(forKey: "hours.wind.dir.\(i)") as! String,
                             aDecoder.decodeDouble(forKey: "hours.wind.degrees.\(i)"))
                
            hours.append((wDate,dDescription,high,low,cond,humi,feel,uv,wind))
        }
    }
 
    public override func encode(with aCoder: NSCoder) {
        
        for i in 0...35{
         
            aCoder.encode(self.hours[i].wDate.day, forKey:"hours.wDate.day.\(i)")
            aCoder.encode(self.hours[i].wDate.month, forKey:"hours.wDate.month.\(i)")
            aCoder.encode(self.hours[i].wDate.year, forKey:"hours.wDate.year.\(i)")
            aCoder.encode(self.hours[i].wDate.hour, forKey:"hours.wDate.hour.\(i)")
            aCoder.encode(self.hours[i].wDate.min, forKey:"hours.wDate.min.\(i)")
            aCoder.encode(self.hours[i].wDate.sec, forKey:"hours.wDate.sec.\(i)")
            aCoder.encode(self.hours[i].wDate.ampm, forKey:"hours.wDate.ampm.\(i)")
      
            aCoder.encode(self.hours[i].description.month, forKey:"hours.description.month.\(i)")
            aCoder.encode(self.hours[i].description.month_short, forKey:"hours.description.month_short.\(i)")
            aCoder.encode(self.hours[i].description.weekday, forKey:"hours.description.weekday.\(i)")
            aCoder.encode(self.hours[i].description.weekday_short, forKey:"hours.description.weekday_short.\(i)")
         
            aCoder.encode(self.hours[i].high.celsius, forKey:"hours.high.celsius.\(i)")
            aCoder.encode(self.hours[i].high.fahrenheit, forKey:"hours.high.farehenit.\(i)")
            aCoder.encode(self.hours[i].high.fullString, forKey:"hours.high.fullString.\(i)")
      
            aCoder.encode(self.hours[i].low.celsius, forKey:"hours.low.celsius.\(i)")
            aCoder.encode(self.hours[i].low.fahrenheit, forKey:"hours.low.fahrenheit.\(i)")
            aCoder.encode(self.hours[i].low.fullString, forKey:"hours.low.fullString.\(i)")
      
            aCoder.encode(self.hours[i].cond, forKey:"hours.cond.\(i)")
      
            aCoder.encode(self.hours[i].humidity, forKey:"hours.humidity.\(i)")
      
            aCoder.encode(self.hours[i].feelLike.celsius, forKey:"hours.feelLike.celsius.\(i)")
            aCoder.encode(self.hours[i].feelLike.fahrenheit, forKey:"hours.feelLike.fahrenheit.\(i)")
            aCoder.encode(self.hours[i].feelLike.fullString, forKey:"hours.feelLike.fullString.\(i)")
      
            aCoder.encode(self.hours[i].uvindex, forKey:"hours.uvindex.\(i)")
      
            aCoder.encode(self.hours[i].wind.mph, forKey:"hours.wind.mph.\(i)")
            aCoder.encode(self.hours[i].wind.kph, forKey:"hours.wind.kph.\(i)")
            aCoder.encode(self.hours[i].wind.dir, forKey:"hours.wind.dir.\(i)")
            aCoder.encode(self.hours[i].wind.degrees, forKey:"hours.wind.degrees.\(i)")
        }
    }
}

//http://api.wunderground.com/api/826830b16b7d2179/planner_07010731/q/CA/San_Francisco.json
public class PlannerResult : IWeatherResult{
    
    var tripTitle:String?
    var startDate:(date:WDate,wm:DateDescription)?
    var endDate:(date:WDate,wm:DateDescription)?
    var highTemp:(min:Temperature, avg:Temperature, max:Temperature)?
    var lowTemp:(min:Temperature, avg:Temperature, max:Temperature)?
    var condition:String?
    var chanceOfs:[(name:String,description:String, percentage:String)] = []
    
    init(_ json:JSONDictionary) {
        super.init()
        
        if let trip = json["trip"] as? JSONDictionary{
            
            let por = trip["period_of_record"] as! JSONDictionary
            let ds = por["date_start"] as! JSONDictionary
            let de = por["date_end"] as! JSONDictionary
            let d1 = ds["date"] as! JSONDictionary
            let d2 = de["date"] as! JSONDictionary
            let tmpH = trip["temp_high"] as! JSONDictionary
            let tmpL = trip["temp_low"] as! JSONDictionary
            let minH = tmpH["min"] as! JSONDictionary
            let avgH = tmpH["min"] as! JSONDictionary
            let maxH = tmpH["min"] as! JSONDictionary
            let minL = tmpL["min"] as! JSONDictionary
            let avgL = tmpL["min"] as! JSONDictionary
            let maxL = tmpL["min"] as! JSONDictionary
            let cc = trip["cloud_cover"] as! JSONDictionary
            let cof = trip["chance_of"] as! JSONDictionary
            
            tripTitle = trip["title"] as? String
            
            startDate = (("\(d1["day"]!)","\(d1["month"]!)", "\(d1["year"]!)", "\(d1["hour"]!)", "\(d1["min"]!)", "\(d1["sec"]!)", "\(d1["ampm"]!)"),("\(d1["monthname"]!)", "\(d1["monthname_short"]!)", "\(d1["weekday"]!)", "\(d1["weekday_short"]!)"))

            endDate = (("\(d2["day"]!)", "\(d2["month"]!)", "\(d2["year"]!)", "\(d2["hour"]!)", "\(d2["min"]!)", "\(d2["sec"]!)", "\(d2["ampm"]!)"),("\(d2["monthname"]!)", "\(d2["monthname_short"]!)", "\(d2["weekday"]!)", "\(d2["weekday_short"]!)"))
            
            highTemp = ((minH["C"] as! String, minH["F"] as! String, ""),
                        (avgH["C"] as! String, avgH["F"] as! String, ""),
                        (maxH["C"] as! String, maxH["F"] as! String, ""))
            
            lowTemp = ((minL["C"] as! String, minL["F"] as! String, ""),
                        (avgL["C"] as! String, avgL["F"] as! String, ""),
                        (maxL["C"] as! String, maxL["F"] as! String, ""))
            
            condition = cc["cond"] as? String
            
            //chanceofsultryday
            let sultry = cof["chanceofsultryday"] as! JSONDictionary
            chanceOfs.append((sultry["name"] as! String,sultry["description"] as! String, sultry["percentage"] as! String))
            
            let humidday = cof["chanceofhumidday"] as! JSONDictionary
            chanceOfs.append((humidday["name"] as! String,humidday["description"] as! String, humidday["percentage"] as! String))
            
            let cloud = cof["chanceofcloudyday"] as! JSONDictionary
            chanceOfs.append((cloud["name"] as! String,cloud["description"] as! String, cloud["percentage"] as! String))
            
            let over90 = cof["tempoverninety"] as! JSONDictionary
            chanceOfs.append((over90["name"] as! String,over90["description"] as! String, over90["percentage"] as! String))
            
            let precip = cof["chanceofprecip"] as! JSONDictionary
            chanceOfs.append((precip["name"] as! String,precip["description"] as! String, precip["percentage"] as! String))
            
            let rain = cof["chanceofrainday"] as! JSONDictionary
            chanceOfs.append((rain["name"] as! String,rain["description"] as! String, rain["percentage"] as! String))
            
            let over60 = cof["tempoversixty"] as! JSONDictionary
            chanceOfs.append((over60["name"] as! String,over60["description"] as! String, over60["percentage"] as! String))
            
            let thunder = cof["chanceofthunderday"] as! JSONDictionary
            chanceOfs.append((thunder["name"] as! String,thunder["description"] as! String, thunder["percentage"] as! String))
            
            let snowgrd = cof["chanceofsnowonground"] as! JSONDictionary
            chanceOfs.append((snowgrd["name"] as! String,snowgrd["description"] as! String, snowgrd["percentage"] as! String))
            
            let tornado = cof["chanceoftornadoday"] as! JSONDictionary
            chanceOfs.append((tornado["name"] as! String,tornado["description"] as! String, tornado["percentage"] as! String))
            
            let windy = cof["chanceofwindyday"] as! JSONDictionary
            chanceOfs.append((windy["name"] as! String,windy["description"] as! String, windy["percentage"] as! String))
            
            let freeze = cof["tempbelowfreezing"] as! JSONDictionary
            chanceOfs.append((freeze["name"] as! String,freeze["description"] as! String, freeze["percentage"] as! String))
            
            let hail = cof["chanceofhailday"] as! JSONDictionary
            chanceOfs.append((hail["name"] as! String,hail["description"] as! String, hail["percentage"] as! String))
            
            let snow = cof["chanceofsnowday"] as! JSONDictionary
            chanceOfs.append((snow["name"] as! String,snow["description"] as! String, snow["percentage"] as! String))
            
            let fog = cof["chanceoffogday"] as! JSONDictionary
            chanceOfs.append((fog["name"] as! String,fog["description"] as! String, fog["percentage"] as! String))
            
            let sunny = cof["chanceofsunnycloudyday"] as! JSONDictionary
            chanceOfs.append((sunny["name"] as! String,sunny["description"] as! String, sunny["percentage"] as! String))
            
            let pcloudy = cof["chanceofpartlycloudyday"] as! JSONDictionary
            chanceOfs.append((pcloudy["name"] as! String,pcloudy["description"] as! String, pcloudy["percentage"] as! String))
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init()
    }
    
    public override func encode(with aCoder: NSCoder) {
        
    }
}

//http://api.wunderground.com/api/826830b16b7d2179/tide/q/CA/San_Francisco.json
public class TideResult: IWeatherResult{
    
    var tideInfo:(site:String, coord:Coordination, units:String)?
    var tideSummary:[(date:WDate, type:String, height:String)]?
    
    init(_ json:JSONDictionary) {
       super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init()
    }
    
    public override func encode(with aCoder: NSCoder) {
        
    }
}

//http://api.wunderground.com/api/826830b16b7d2179/yesterday/q/CA/San_Francisco.json
public class YesterdayResult: IWeatherResult
{
    var date:WDate?
    var observations:[(date:WDate,temp:Temperature, cond:Conditions)] = []
    
    init(_ json:JSONDictionary) {
        super.init()
        
        if let his = json["history"] as? JSONDictionary{
         
            if let dt = his["date"] as? JSONDictionary{
                
                date = (dt["mday"] as! String, dt["mon"] as! String, dt["year"] as! String, dt["hour"] as! String, dt["min"] as! String,"", "")
            }
            
            if let ob = his["observations"] as? JSONArray{
                
                for item in ob{
                    
                    let dt = item["date"] as! JSONDictionary
                    let d = (dt["mday"] as! String, dt["mon"] as! String, dt["year"] as! String, dt["hour"] as! String, dt["min"] as! String,"", "")
                    let temp = (item["tempm"] as! String, item["tempi"] as! String, "")
                    let condition = (item["fog"] as! String == "0" ? false : true,
                                      item["rain"] as! String == "0" ? false : true,
                                      item["snow"] as! String == "0" ? false : true,
                                      item["hail"] as! String == "0" ? false : true,
                                      item["thunder"] as! String == "0" ? false : true,
                                      item["tornado"] as! String == "0" ? false : true)

                    observations.append((d,temp,condition))
                }
            }
        }

    }
    
    public required init?(coder aDecoder: NSCoder) {
       super.init()
    }
    
    public override func encode(with aCoder: NSCoder) {
        
    }
}

