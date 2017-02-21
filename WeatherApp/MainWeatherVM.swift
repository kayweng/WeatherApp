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
    
    init(location:UserLocation){
        
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
    
    private func GetLocationZMW(completion:(location:Location, storage:Weather)->Void){
        
        WeatherAPI.shared.GetLocationZMW(at: self.userLocation.city!, completion: { (result) in
            
            self.autoLocation = result.item[0]
            self.userLocation.type = LocationType.Phone
            
            completion()
        }
    }
    
    private func retrieveWeatherAPIResult(){
        
        let queue = dispatch_get_Global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0)
        let group = DispatchGroup()
        
        var newLocation:Location?
        var newWeather:Weather?
        
        group.enter()
        func GetLocationZMW() {
            
            newLocation = try! LocationRepo.shared.CreateOrReplace(self.userLocation!)
            newWeather = try! WeatherRepo.shared.CreateWeather(on: self.today, at: newLocation)
            
            let detail = WeatherDetailRepo.shared.CreateWeatherDetail(self.autoLocation!, type: .AutoComplete, header: newWeather!)
            
            newWeather!.addToDetail(detail)

            group.leave()
        }
        
        WeatherAPI.shared.GetCondition(at: self.autoLocation!.zmw) { (result) in
                
                DispatchQueue.main.async(){
                    
                    self.conditions = result.item[0]
                    //self.populateConditionsResult()
                    
                    let detail = WeatherDetailRepo.shared.CreateWeatherDetail(self.conditions!, type: .Condition, header: newWeather!)
                    newWeather!.addToDetail(detail)
                }
            }
            
            WeatherAPI.shared.GetAstronomy(at: self.autoLocation!.zmw) { (result) in
                
                DispatchQueue.main.async(){
                    
                    self.astronomy = result.item[0]
                    //self.populateAstronomyResult()
                    
                    let detail = WeatherDetailRepo.shared.CreateWeatherDetail(self.astronomy!, type: .Astronomy, header: newWeather!)
                    newWeather!.addToDetail(detail)
                }
            }
            
            WeatherAPI.shared.GetForecast(at: self.autoLocation!.zmw) { (result) in
                
                DispatchQueue.main.async {
                    
                    self.forecast = result.item[0]
                    //self.populateForecastResult()
                    
                    let detail = WeatherDetailRepo.shared.CreateWeatherDetail(self.forecast!, type: .Forecast, header: newWeather!)
                    newWeather!.addToDetail(detail)
                }
            }
            
            WeatherAPI.shared.GetHourly(at: self.autoLocation!.zmw) { (result) in
                
                DispatchQueue.main.async {
                    
                    self.hourly = result.item[0]
                    //self.populateHourlyResult()
                    
                    let detail = WeatherDetailRepo.shared.CreateWeatherDetail(self.hourly!, type: .Hourly, header: newWeather!)
                    newWeather!.addToDetail(detail)
                }
            }
            
            WeatherAPI.shared.GetForecast10Days(at: self.autoLocation!.zmw, completion: { (result) in
                
                DispatchQueue.main.async {
                    
                    self.daily = result.item[0]
                    //self.populateForecast10DaysResult()
                    
                    let detail = WeatherDetailRepo.shared.CreateWeatherDetail(self.daily!, type: .Forecast10Day, header: newWeather!)
                    newWeather!.addToDetail(detail)
                    
                    DispatchQueue.main.async {
                        _ = try! RepositoryBase.shared.Save()
                    }
                }
            })
    }

}
