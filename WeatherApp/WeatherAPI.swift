//
//  weatherApi.swift
//  WeatherApp
//
//  Created by kay weng on 30/11/2016.
//  Copyright © 2016 snackcode.org. All rights reserved.
//

import Foundation
import SnackKit

private let apiUrl = "http://api.wunderground.com/api/"
private let apiKey = "826830b16b7d2179"
private let country = AppLocale.countryCode

class WeatherAPI {
    
    public class var shared: WeatherAPI {
        
        struct Static {
            static var instance: WeatherAPI? = nil
        }
        
        if Static.instance == nil{
            Static.instance = WeatherAPI()
        }
        
        return Static.instance!
    }
    
    init() {

    }
    
    // MARK: - Internal private
    private func generateApiUrl(action:WeahterAction, query:String)->String{
        //http://api.wunderground.com/api/826830b16b7d2179/astronomy/q/SG/zmw:00000.148.48694.json
        //http://autocomplete.wunderground.com/aq?query=Telok%20Blangah
        return apiUrl + apiKey + "/" + action.rawValue + "/" + query + ".json"
    }
    
    private func generateApiUrl(action:String, query:String)->String{
        return apiUrl + apiKey + "/" + action + "/" + query + ".json"
    }
    
    // MARK: - API Functions
    public func GetLocationZMW(at location:String,completion:@escaping (_ result:Container<AutoLocationResult>)->Void){
    
        let url = "http://autocomplete.wunderground.com/aq?query=" + location + "&c=" + gCountryCode
        
        ApiHelper.sendApiRequest(at: url, method: "GET") { (json) in
            
            var result:Container<AutoLocationResult> = Container<AutoLocationResult>()
            
            if let _ = json {
                let autoLocation = AutoLocationResult(json! as JSONDictionary)
                result = Container<AutoLocationResult>(object: autoLocation)
            }
            
            return completion(result)
        }
    }
    
    public func GetAstronomy(at l:String, completion:@escaping (_ result:Container<AstronomyResult>)->Void){
     
        let url = generateApiUrl(action: .Astronomy, query:l)
        
        ApiHelper.sendApiRequest(at: url, method: "GET") { (json) in
            
            var result:Container<AstronomyResult> = Container<AstronomyResult>()
            
            if let _ = json {
                let astronomy = AstronomyResult(json! as JSONDictionary)
                result = Container<AstronomyResult>(object: astronomy)
            }
            
            return completion(result)
        }
    }
    
    public func GetCondition(at l:String, completion:@escaping (_ result:Container<ConditionsResult>)->Void){
        
        let url = generateApiUrl(action: .Conditions, query:l)
        
        ApiHelper.sendApiRequest(at: url) { (json) in
         
            var result:Container<ConditionsResult> = Container<ConditionsResult>()
            
            if let _ = json{
                let conditions = ConditionsResult(json! as JSONDictionary)
                result = Container<ConditionsResult>(object: conditions)
            }
            
            return completion(result)
        }
    }
    
    public func GetForecast(at l:String, completion:@escaping (_ result:Container<ForecastResult>)->Void){
        
        let url = generateApiUrl(action: .Forecast, query:l)
        
        ApiHelper.sendApiRequest(at: url) { (json) in
            
            var result:Container<ForecastResult> = Container<ForecastResult>()
            
            if let _ = json{
                let forecast = ForecastResult(json! as JSONDictionary)
                result = Container<ForecastResult>(object: forecast)
            }
            
            return completion(result)
        }
    }
    
    public func GetForecast10Days(at l:String, completion: @escaping (_ result:Container<Forecast10Result>)->Void){
        
        let url = generateApiUrl(action: .Forecast10Day, query:l)
        
        ApiHelper.sendApiRequest(at: url) { (json) in
            
            var result:Container<Forecast10Result> = Container<Forecast10Result>()
            
            if let _ = json{
                let forecast = Forecast10Result(json! as JSONDictionary)
                result = Container<Forecast10Result>(object: forecast)
            }
            
            return completion(result)
        }
    }
    
    
    public func GetHistory(from dtString:String,at l:String, completion: @escaping (_ result:Container<HistoryResult>)->Void){
     
        let url = generateApiUrl(action: WeahterAction.Forecast10Day.rawValue + "_" + dtString, query:l)
        
        ApiHelper.sendApiRequest(at: url) { (json) in
            
            var result:Container<HistoryResult> = Container<HistoryResult>()
            
            if let _ = json{
                let history = HistoryResult(json! as JSONDictionary)
                result = Container<HistoryResult>(object: history)
            }
            
            return completion(result)
        }
    }
    
    public func GetHourly(at l:String, completion: @escaping (_ result:Container<HourlyResult>)->Void){
        
        let url = generateApiUrl(action: .Hourly, query:l)
        
        ApiHelper.sendApiRequest(at: url) { (json) in
            
            var result:Container<HourlyResult> = Container<HourlyResult>()
            
            if let _ = json{
                let history = HourlyResult(json! as JSONDictionary)
                result = Container<HourlyResult>(object: history)
            }
            
            return completion(result)
        }
    }
    
    public func GetHourly10Days(at l:String, completion: @escaping (_ result:Container<HourlyResult>)->Void){
        
        let url = generateApiUrl(action: .Hourly10Day, query:l)
        
        ApiHelper.sendApiRequest(at: url) { (json) in
            
            var result:Container<HourlyResult> = Container<HourlyResult>()
            
            if let _ = json{
                let history = HourlyResult(json! as JSONDictionary)
                result = Container<HourlyResult>(object: history)
            }
            
            return completion(result)
        }
    }
    
    public func GetPlanner(mmddmmdd:String,at l:String, completion: @escaping (_ result:Container<PlannerResult>)->Void){
        
        let url = generateApiUrl(action: WeahterAction.Planner.rawValue + "_" + mmddmmdd, query:l)
        ApiHelper.sendApiRequest(at: url) { (json) in
            
            var result:Container<PlannerResult> = Container<PlannerResult>()
            
            if let _ = json{
                let history = PlannerResult(json! as JSONDictionary)
                result = Container<PlannerResult>(object: history)
            }
            
            return completion(result)
        }
    }
    
    public func GetYesterday(at l:String, completion: @escaping (_ result:Container<YesterdayResult>)->Void){
        
        let url = generateApiUrl(action: .Yesterday, query:l)
        
        ApiHelper.sendApiRequest(at: url) { (json) in
            
            var result:Container<YesterdayResult> = Container<YesterdayResult>()
            
            if let _ = json{
                let yesterday = YesterdayResult(json! as JSONDictionary)
                result = Container<YesterdayResult>(object: yesterday)
            }
            
            return completion(result)
        }
    }

}
