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
typealias Temperature = (celcius:String, fahrenheit:String, fullString:String)
typealias Visibility = (mi:String, km:String)
typealias FeelLike = (celcius:String, fahrenheit:String, fullString:String)
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

//http://api.wunderground.com/api/826830b16b7d2179/astronomy/q/Australia/Sydney.json
public struct AstronomyResult{
    
    var moonPhase:(percentIlluminated:String, ageOfMoon:String, current_time:Time)?
    var sunrise:Time?
    var sunset:Time?
    var moonrise:Time?
    var moonset:Time?
    
    init(json:JSONDictionary) {

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
}

//Returns the current temperature, weather condition, humidity, wind, 'feels like' temperature, barometric pressure, and visibility.
//http://api.wunderground.com/api/826830b16b7d2179/conditions/q/CA/San_Francisco.json
public struct ConditionsResult{
    
    var displayLocation:(full:String, city:String, country:String, location:Coordination)?
    var observationLocation:(full:String, city:String, country:String, location:Coordination)?
    var weather:(temp:Temperature,description:String,humidity:String)?
    var feel:FeelLike?
    var wind:Wind?
    var visibility:Visibility?
    var icon:String?
    var uv:String?
    
    init(json:JSONDictionary) {
     
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
}

//Returns a summary of the weather for the next 3 days. 
//This includes high and low temperatures, a string text forecast and the conditions.
//http://api.wunderground.com/api/826830b16b7d2179/forecast/q/CA/San_Francisco.json
public struct ForecastResult{
    
    var forecastText:[TextForecast] = []
    var simplyForecast:[SimpleForecast] = []
    
    init(json:JSONDictionary) {
     
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
}

//http://api.wunderground.com/api/826830b16b7d2179/history_20060405/q/CA/San_Francisco.json
public struct HistoryResult{
    
    var history:[(date:WDate, temp:Temperature, cond:Conditions)] = []
    
    init(json:JSONDictionary) {
        
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
}

//http://api.wunderground.com/api/826830b16b7d2179/hourly/q/CA/San_Francisco.json
//http://api.wunderground.com/api/826830b16b7d2179/hourly10day/q/CA/San_Francisco.json
public struct HourlyResult{
    
    var hours:[(wDate:WDate, description:DateDescription, high:Temperature, low:Temperature, cond:String, humidity:String, feelLike:Temperature, uvindex:String, wind:Wind)] = []
    
    init(json:JSONDictionary) {
        
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
}

//http://api.wunderground.com/api/826830b16b7d2179/planner_07010731/q/CA/San_Francisco.json
public struct PlannerResult{
    
    var tripTitle:String?
    var startDate:(date:WDate,wm:DateDescription)?
    var endDate:(date:WDate,wm:DateDescription)?
    var highTemp:(min:Temperature, avg:Temperature, max:Temperature)?
    var lowTemp:(min:Temperature, avg:Temperature, max:Temperature)?
    var condition:String?
    var chanceOfs:[(name:String,description:String, percentage:String)] = []
    
    init(json:JSONDictionary) {
        
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
}

//http://api.wunderground.com/api/826830b16b7d2179/tide/q/CA/San_Francisco.json
public struct TideResult{
    
    var tideInfo:(site:String, coord:Coordination, units:String)?
    var tideSummary:[(date:WDate, type:String, height:String)]?
    
    init(json:JSONDictionary) {
        
        
        
        
    }
    
}

//http://api.wunderground.com/api/826830b16b7d2179/yesterday/q/CA/San_Francisco.json
public struct YesterdayResult
{
    var date:WDate?
    var observations:[(date:WDate,temp:Temperature, cond:Conditions)] = []
    
    init(json:JSONDictionary) {
     
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
}


