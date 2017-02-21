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
    
    var container:ContainerController?
    
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
    
    public init(location:UserLocation){
        
        self.userLocation = location
    }
    
    // MARK: - Public Functions
    public func retrieveWeatherInfo(override:Bool = false){
        
        if isNeededReloadWeather() || override{
            self.retrieveWeatherAPIResult()
        }else{
            self.retrieveLastSavedWeatherResult()
        }
    }
    
    // MARK: - Private Functions
    private func isNeededReloadWeather() -> Bool{
    
        var isNewLocation = false
        var isWeatherExpired = false
        
        do{
            let lastLocation = try LocationRepo.shared.GetLocation(.Phone,on: self.today)
            
            isNewLocation = lastLocation?.locationCity != self.userLocation.city!
            
            if !isNewLocation{
                
                if let lastWeather = try WeatherRepo.shared.GetWeather(on: self.today, at: lastLocation) {
                    
                    if let lastModifiedDate = lastWeather.modifiedOn as? Date{
                        isWeatherExpired = lastModifiedDate.elapsedInMinutes(Date().now) < 15 ? false : true
                    }
                    
                    if isWeatherExpired{
                        let _ = WeatherRepo.shared.RemoveWeahter(lastWeather.weatherID!)
                    }
                }
            }

        }catch CoreDataError.ReadError{
            
        }catch _{
            
        }
        
        return isNewLocation || isWeatherExpired
    }

    private func retrieveLastSavedWeatherResult(){
        
        do{
            if let lastLocation = try LocationRepo.shared.GetLocation(.Phone,on: self.today) {
                
                if let weather = try WeatherRepo.shared.GetWeather(on: self.today, at:lastLocation) {
                    
                    if let results = WeatherDetailRepo.shared.GetWeatherDetail(on: self.today, header: weather){
               
                        for re in results{
                            
                            let type = WeatherResultType(rawValue: re.wdType!)
                            
                            switch type! {
                            case .Astronomy:
                                self.astronomy = re.wdResult as? AstronomyResult
                                //self.populateAstronomyResult()
                            case .Condition:
                                self.conditions = re.wdResult as? ConditionsResult
                                //self.populateConditionsResult()
                            case .Forecast:
                                self.forecast = re.wdResult as? ForecastResult
                                //self.populateForecastResult()
                            case .Forecast10Day:
                                self.daily = re.wdResult as? Forecast10Result
                                //self.populateForecast10DaysResult()
                            case .Hourly:
                                self.hourly = re.wdResult as? HourlyResult
                                //self.populateHourlyResult()
                            case .AutoComplete:
                                self.autoLocation = re.wdResult as? AutoLocationResult
                            default:
                                break
                            }
                        }
                    }
                }
                
            }

        }catch CoreDataError.ReadError{
            
        }catch _{
            
        }
    }
    
    private func GetLocationZMW(completion:@escaping ()->Void){
        
        WeatherAPI.shared.GetLocationZMW(at: self.userLocation.city!, completion: { (result) in
            
            self.autoLocation = result.item[0]
            self.userLocation.type = LocationType.Phone
            
            completion()
        })
    }
    
    private func GetConditionAPIResult(completion:()->Void){
        
        WeatherAPI.shared.GetCondition(at: self.autoLocation!.zmw) { (result) in
            
            self.conditions = result.item[0]
        }
    }
    
    private func GetAstronomyAPIResult(completion:()->Void){
        
        WeatherAPI.shared.GetAstronomy(at: self.autoLocation!.zmw) { (result) in
            
            self.astronomy = result.item[0]
        }
    }
    
    private func GetForecastAPIResult(completion:()->Void){
        
        WeatherAPI.shared.GetForecast(at: self.autoLocation!.zmw) { (result) in
            
            self.forecast = result.item[0]
        }
    }
    
    private func GetHourlyAPIResult(completion:()->Void){
        
        WeatherAPI.shared.GetHourly(at: self.autoLocation!.zmw) { (result) in
            
            self.hourly = result.item[0]
        }
    }
    
    private func GetForecast10DaysAPIResult(completion:()->Void){
        
        WeatherAPI.shared.GetForecast10Days(at: self.autoLocation!.zmw, completion: { (result) in
            
            self.daily = result.item[0]
        })
    }
    
    private func retrieveWeatherAPIResult(){
        
        let queue = DispatchQueue(label: "ios.WeatherApp.WeatherAPI")
        let group = DispatchGroup()
        
        var newLocation:Location?
        var newWeather:Weather?
        
        //1
        group.enter()
        queue.async { 
            
            self.GetLocationZMW(completion: {
                
                newLocation = try! LocationRepo.shared.CreateOrReplace(self.userLocation!)
                newWeather = try! WeatherRepo.shared.CreateWeather(on: self.today, at: newLocation)
                
                let detail = WeatherDetailRepo.shared.CreateWeatherDetail(self.autoLocation!, type: .AutoComplete, header: newWeather!)
                newWeather!.addToDetail(detail)
                
                print("Get Location ZMW")
                group.leave()
            })
        }
        
        //2
        group.enter()
        queue.async { 
            
            self.GetConditionAPIResult(completion: { 
                
                let detail = WeatherDetailRepo.shared.CreateWeatherDetail(self.conditions!, type: .Condition, header: newWeather!)
                newWeather!.addToDetail(detail)
                
                print("Get Condition")
                group.leave()
            })
        }

        //3
        group.enter()
        queue.async { 
            
            self.GetAstronomyAPIResult(completion: {
                
                let detail = WeatherDetailRepo.shared.CreateWeatherDetail(self.astronomy!, type: .Astronomy, header: newWeather!)
                newWeather!.addToDetail(detail)
                
                print("Get Astronomy")
                group.leave()
            })
        }
        
        //4
        group.enter()
        queue.async { 
            
            self.GetForecastAPIResult(completion: { 
                
                let detail = WeatherDetailRepo.shared.CreateWeatherDetail(self.forecast!, type: .Forecast, header: newWeather!)
                newWeather!.addToDetail(detail)
                
                print("Get Forecast")
                group.leave()
            })
        }
        
        //5
        group.enter()
        queue.async { 
            
            self.GetHourlyAPIResult(completion: { 
                
                let detail = WeatherDetailRepo.shared.CreateWeatherDetail(self.hourly!, type: .Hourly, header: newWeather!)
                newWeather!.addToDetail(detail)
                
                print("Get Hourly")
                group.leave()

            })
        }
            
        //6
        group.enter()
        queue.async { 
            
            self.GetForecast10DaysAPIResult(completion: { 
                
                let detail = WeatherDetailRepo.shared.CreateWeatherDetail(self.daily!, type: .Forecast10Day, header: newWeather!)
                newWeather!.addToDetail(detail)
            
                print("Get forecast 10")
                group.leave()
            })
        }
        
        //7
        group.notify(queue: DispatchQueue.main, execute: {
             _ = try! RepositoryBase.shared.Save()
            print("Save")
        })
    }

}
