//
//  MainWeatherVM.swift
//  WeatherApp
//
//  Created by kay weng on 20/02/2017.
//  Copyright © 2017 snackcode.org. All rights reserved.
//

import Foundation
import SnackKit

public class MainWeatherVM {
    
    var autoLocation:AutoLocationResult?
    var conditions:ConditionsResult?
    var astronomy:AstronomyResult?
    var forecast:ForecastResult?
    var hourly:HourlyResult?
    var daily:Forecast10Result?
    
    var userLocation:UserLocation!{
        didSet{
            gCountryCode = self.userLocation.countryCode!
        }
    }
    
    let today = Date().now
    
    public init(){
        // fake,empty instantiated
    }
    
//    public convenience init(location:UserLocation, completion:@escaping ()->Void){
//        self.init()
//        
//        self.userLocation = location
//        self.retrieveWeatherInfo(override: false) {
//            completion()
//        }
//    }
    
    public func initWeatherResult(location:UserLocation, completion:@escaping ()->Void){
       
        self.userLocation = location
        self.retrieveWeatherInfo(override: false) {
            completion()
        }
    }
    
    // MARK: - Public Functions
    public func retrieveWeatherInfo(override:Bool = false, completion:@escaping ()->Void){
        
        if true || self.checkLastSavedWeather() {
            
            self.retrieveWeatherAPIResult(city: self.userLocation!.city!, completion: { (done) in
                
                if done{
                    completion()
                }else{
                    //try use country code
                    self.retrieveWeatherAPIResult(city: self.userLocation!.country!, completion: { (done) in
                        completion()
                    })
                }
            })
            
        }else{
            
            self.retrieveLastSavedWeatherResult(completion: {
                completion()
            })
        }
    }
    
    // MARK: - Private Functions
    private func checkLastSavedWeather() -> Bool{
    
        var isNewLocation = false
        var isWeatherExpired = false
        
        do{
            let lastLocation = try LocationRepo.shared.GetLocation(.Phone,on: self.today)
            
            isNewLocation = lastLocation?.locationCity != self.userLocation.city!
            
            if !isNewLocation{
                
                if let lastWeather = try WeatherRepo.shared.GetWeather(on: self.today, at: lastLocation) {
                    
                    if let lastModifiedDate = lastWeather.modifiedOn as? Date{
                        isWeatherExpired = lastModifiedDate.elapsedInMinutes(Date().now) < 60 ? false : true
                    }
                    
                    if isWeatherExpired{
                        //let _ = WeatherRepo.shared.RemoveWeahter(lastWeather.weatherID!)
                        _ = WeatherRepo.shared.RemoveWeatherAt(location: lastLocation!)
                    }
                }
            }

        }catch CoreDataError.ReadError{
            
        }catch _{
            
        }
        
        return isNewLocation || isWeatherExpired
    }

    private func retrieveLastSavedWeatherResult(completion:()->Void){
        
        do{
            if let lastLocation = try LocationRepo.shared.GetLocation(.Phone,on: self.today) {
                
                if let weather = try WeatherRepo.shared.GetWeather(on: self.today, at:lastLocation) {
                    
                    if let results = WeatherDetailRepo.shared.GetWeatherDetail(on: self.today, header: weather){
               
                        for re in results{
                            
                            let type = WeatherResultType(rawValue: re.wdType!)
                            
                            switch type! {
                            case .Astronomy:
                                self.astronomy = re.wdResult as? AstronomyResult
                            case .Condition:
                                self.conditions = re.wdResult as? ConditionsResult
                            case .Forecast:
                                self.forecast = re.wdResult as? ForecastResult
                            case .Forecast10Day:
                                self.daily = re.wdResult as? Forecast10Result
                            case .Hourly:
                                self.hourly = re.wdResult as? HourlyResult
                            case .AutoComplete:
                                self.autoLocation = re.wdResult as? AutoLocationResult
                            default:
                                break
                            }
                        }
                    }
                }
            }
            print("Retrieved Last Saved Weather Result")
            completion()

        }catch CoreDataError.ReadError{
            
        }catch _{
            
        }
    }

    
    private func GetConditionAPIResult(completion:@escaping ()->Void){
        
        WeatherAPI.shared.GetCondition(at: self.autoLocation!.queryString) { (result) in
            
            self.conditions = result.item[0]
            
            completion()
        }
    }
    
    private func GetAstronomyAPIResult(completion:@escaping ()->Void){
        
        WeatherAPI.shared.GetAstronomy(at: self.autoLocation!.queryString) { (result) in
            
            self.astronomy = result.item[0]
            
            completion()
        }
    }
    
    private func GetForecastAPIResult(completion:@escaping ()->Void){
        
        WeatherAPI.shared.GetForecast(at: self.autoLocation!.queryString) { (result) in
            
            self.forecast = result.item[0]
            
            completion()
        }
    }
    
    private func GetHourlyAPIResult(completion:@escaping ()->Void){
        
        WeatherAPI.shared.GetHourly(at: self.autoLocation!.queryString) { (result) in
            
            self.hourly = result.item[0]
            
            completion()
        }
    }
    
    private func GetForecast10DaysAPIResult(completion:@escaping ()->Void){
        
        WeatherAPI.shared.GetForecast10Days(at: self.autoLocation!.queryString, completion: { (result) in
            
            self.daily = result.item[0]
            
            completion()
        })
    }
    
    private func retrieveWeatherAPIResult(city:String, completion:@escaping (_ valid:Bool)->Void){
        
        WeatherAPI.shared.GetLocationZMW(at: city, completion: { (result) in
        
            if result.item[0].queryString.isEmpty{
                completion(false)
                return
            }
            
            let queue = DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated)
            let group = DispatchGroup()
            
            var newLocation:Location?
            var newWeather:Weather?
        
            self.autoLocation = result.item[0]
            self.userLocation.type = LocationType.Phone
            
            newLocation = try! LocationRepo.shared.CreateOrReplace(self.userLocation!)
            newWeather = try! WeatherRepo.shared.CreateWeather(on: self.today, at: newLocation)
            
            let detail = WeatherDetailRepo.shared.CreateWeatherDetail(self.autoLocation!, type: .AutoComplete, header: newWeather!)
            newWeather!.addToDetail(detail)
            
            print("Found Auto Location : \(newLocation!.locationName)")
            
            //2
            group.enter()
            queue.async(group: group, qos: DispatchQoS.userInitiated, flags: DispatchWorkItemFlags.assignCurrentContext, execute: {
                
                self.GetConditionAPIResult(completion: {
                    
                    let detail = WeatherDetailRepo.shared.CreateWeatherDetail(self.conditions!, type: .Condition, header: newWeather!)
                    newWeather!.addToDetail(detail)
                    print("Saving the Condition Result")
                    group.leave()
                })
            })
            
            //3
            group.enter()
            queue.async(group: group, qos: DispatchQoS.userInitiated, flags: DispatchWorkItemFlags.inheritQoS, execute: {
                
                self.GetAstronomyAPIResult(completion: {
                    
                    let detail = WeatherDetailRepo.shared.CreateWeatherDetail(self.astronomy!, type: .Astronomy, header: newWeather!)
                    newWeather!.addToDetail(detail)
                    print("Saving the Astronomy Result")
                    group.leave()
                })
            })
            
            //4
            group.enter()
            queue.async(group: group, qos: DispatchQoS.userInitiated, flags: DispatchWorkItemFlags.inheritQoS, execute: {
                
                self.GetForecastAPIResult(completion: {
                    
                    let detail = WeatherDetailRepo.shared.CreateWeatherDetail(self.forecast!, type: .Forecast, header: newWeather!)
                    newWeather!.addToDetail(detail)
                    print("Saving the Forecast Result")
                    group.leave()
                })
            })
            
            //5
            group.enter()
            queue.async(group: group, qos: DispatchQoS.userInitiated, flags: DispatchWorkItemFlags.inheritQoS, execute: {
                
                self.GetHourlyAPIResult(completion: {
                    
                    let detail = WeatherDetailRepo.shared.CreateWeatherDetail(self.hourly!, type: .Hourly, header: newWeather!)
                    newWeather!.addToDetail(detail)
                    print("Saving the Hourly Result")
                    group.leave()
                    
                })
            })
            
            //6
            group.enter()
            queue.async(group: group, qos: DispatchQoS.userInitiated, flags: DispatchWorkItemFlags.inheritQoS , execute: {
                
                self.GetForecast10DaysAPIResult(completion: {
                    
                    let detail = WeatherDetailRepo.shared.CreateWeatherDetail(self.daily!, type: .Forecast10Day, header: newWeather!)
                    newWeather!.addToDetail(detail)
                    print("Saving the Forecast 10 Days Result")
                    group.leave()
                })
            })
            
            //7
            group.notify(queue: DispatchQueue.main, execute: {
                _ = try! RepositoryBase.shared.Save()
                print("Saved all weather results")
                completion(true)
            })
            
        })

    }

}
