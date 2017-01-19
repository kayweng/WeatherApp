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
    
    var location:String!
    
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
        LocationManager.shared.GetCurrentLocation(completion: { (location:GeoLocation) in
            print(location.name ?? "")
            self.location = "Kuala Lumpur"
        })
    }
    // MARK : - Internal private
    private func generateApiUrl(action:WeahterAction, location:String)->String{
    
        return apiUrl + apiKey + "/" + action.rawValue + "/q/" + gCountryCode + "/" + location + ".json"
    }
    
    private func generateApiUrl(action:String, location:String)->String{
    
        return apiUrl + apiKey + "/" + action + "/q/" + country + "/" + location + ".json"
    }
    
    // MARK : - API Functions
    public func GetAstronomy(at location:String?, completion:@escaping (_ result:Container<AstronomyResult>)->Void){
     
        let url = generateApiUrl(action: .Astronomy, location: location ?? self.location)
        
        ApiHelper.sendApiRequest(at: url, method: "GET") { (json) in
            
            var result:Container<AstronomyResult> = Container<AstronomyResult>()
            
            if let _ = json {
                let astronomy = AstronomyResult(json: json! as JSONDictionary)
                result = Container<AstronomyResult>(object: astronomy)
            }
            
            return completion(result)
        }
    }
    
    public func GetCondition(at location:String?, completion:@escaping (_ result:Container<ConditionsResult>)->Void){
        
        let url = generateApiUrl(action: .Conditions, location: location ?? self.location)
        
        ApiHelper.sendApiRequest(at: url) { (json) in
         
            var result:Container<ConditionsResult> = Container<ConditionsResult>()
            
            if let _ = json{
                let conditions = ConditionsResult(json: json! as JSONDictionary)
                result = Container<ConditionsResult>(object: conditions)
            }
            
            return completion(result)
        }
    }
    
    public func GetForecast(at location:String?, completion:@escaping (_ result:Container<ForecastResult>)->Void){
        
        let url = generateApiUrl(action: .Forecast, location: location ?? self.location)
        
        ApiHelper.sendApiRequest(at: url) { (json) in
            
            var result:Container<ForecastResult> = Container<ForecastResult>()
            
            if let _ = json{
                let forecast = ForecastResult(json: json! as JSONDictionary)
                result = Container<ForecastResult>(object: forecast)
            }
            
            return completion(result)
        }
    }
    
    public func GetForecast10Days(at location:String?, completion: @escaping (_ result:Container<ForecastResult>)->Void){
        
        let url = generateApiUrl(action: .Forecast10Day, location: location ?? self.location)
        
        ApiHelper.sendApiRequest(at: url) { (json) in
            
            var result:Container<ForecastResult> = Container<ForecastResult>()
            
            if let _ = json{
                let forecast = ForecastResult(json: json! as JSONDictionary)
                result = Container<ForecastResult>(object: forecast)
            }
            
            return completion(result)
        }
    }
    
    
    public func GetHistory(from dtString:String, at location:String?, completion: @escaping (_ result:Container<HistoryResult>)->Void){
     
        let url = generateApiUrl(action: WeahterAction.Forecast10Day.rawValue + "_" + dtString, location: location ?? self.location)
        
        ApiHelper.sendApiRequest(at: url) { (json) in
            
            var result:Container<HistoryResult> = Container<HistoryResult>()
            
            if let _ = json{
                let history = HistoryResult(json: json! as JSONDictionary)
                result = Container<HistoryResult>(object: history)
            }
            
            return completion(result)
        }
    }
    
    public func GetHourly(at location:String?, completion: @escaping (_ result:Container<HourlyResult>)->Void){
        
        let url = generateApiUrl(action: .Hourly, location: location ?? self.location)
        
        ApiHelper.sendApiRequest(at: url) { (json) in
            
            var result:Container<HourlyResult> = Container<HourlyResult>()
            
            if let _ = json{
                let history = HourlyResult(json: json! as JSONDictionary)
                result = Container<HourlyResult>(object: history)
            }
            
            return completion(result)
        }
    }
    
    public func GetHourly10Days(at location:String?, completion: @escaping (_ result:Container<HourlyResult>)->Void){
        
        let url = generateApiUrl(action: .Hourly10Day, location: location ?? self.location)
        
        ApiHelper.sendApiRequest(at: url) { (json) in
            
            var result:Container<HourlyResult> = Container<HourlyResult>()
            
            if let _ = json{
                let history = HourlyResult(json: json! as JSONDictionary)
                result = Container<HourlyResult>(object: history)
            }
            
            return completion(result)
        }
    }
    
    public func GetPlanner(mmddmmdd:String, at location:String?, completion: @escaping (_ result:Container<PlannerResult>)->Void){
        
        let url = generateApiUrl(action: WeahterAction.Planner.rawValue + "_" + mmddmmdd, location: location ?? self.location)
        
        ApiHelper.sendApiRequest(at: url) { (json) in
            
            var result:Container<PlannerResult> = Container<PlannerResult>()
            
            if let _ = json{
                let history = PlannerResult(json: json! as JSONDictionary)
                result = Container<PlannerResult>(object: history)
            }
            
            return completion(result)
        }
    }
    
    public func GetYesterday(at location:String?, completion: @escaping (_ result:Container<YesterdayResult>)->Void){
        
        let url = generateApiUrl(action: .Yesterday, location: location ?? self.location)
        
        ApiHelper.sendApiRequest(at: url) { (json) in
            
            var result:Container<YesterdayResult> = Container<YesterdayResult>()
            
            if let _ = json{
                let yesterday = YesterdayResult(json: json! as JSONDictionary)
                result = Container<YesterdayResult>(object: yesterday)
            }
            
            return completion(result)
        }
    }

}
