//
//  MainController.swift
//  WeatherApp
//
//  Created by kay weng on 01/01/2017.
//  Copyright © 2017 snackcode.org. All rights reserved.
//

import UIKit
import SnackKit

private let SegueOfContainer = "SegueOfContainer"

class MainController: UIViewController {

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var weatherView: UIView!
    @IBOutlet weak var imgPlacemarker: UIImageView!
    @IBOutlet weak var lblConditionDesc: UILabel!
    @IBOutlet weak var lblTemperature: UILabel!
    @IBOutlet weak var lblFeelLike: UILabel!
    @IBOutlet weak var lblPlaceName: UILabel!
    @IBOutlet weak var imgCondition: UIImageView!
    @IBOutlet weak var tblTaskingList: UITableView!
    @IBOutlet weak var vwDetails: UIView!
    @IBOutlet weak var vwContainer: UIView!
    @IBOutlet weak var btnExpand: UIButton!
    @IBOutlet weak var lblToday: UILabel!
    @IBOutlet weak var lblMaxMinTemperature: UILabel!
    @IBOutlet weak var imgWeatherInfo: UIImageView!
    
    @IBOutlet weak var constWeatherHeight: NSLayoutConstraint!
    @IBOutlet weak var constTaskingHeight: NSLayoutConstraint!
    @IBOutlet weak var constDetailHeight: NSLayoutConstraint!
    
    var container:ContainerController?
    
    let today:Date = Date().today
    var dHeight = CGFloat(0.0)
    var counter:Int = 0
    var timer = Timer()
    var isExpand = false
    var userLocation:UserLocation?
    var weatherDesc:String = ""{
        didSet{
            self.lblConditionDesc.text = weatherDesc
        }
    }
    var weatherInfo:[(icon:String,value:String)] = []
    
    //API Results
    var conditions:ConditionsResult?
    var astronomy:AstronomyResult?
    var forecast:ForecastResult?
    var hourly:HourlyResult?
    var daily:ForecastResult?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.weatherView.backgroundColor = .clear
        self.weatherView.backgroundColor = UIColor(patternImage: UIImage(named: "bg-night")!)
        
        self.tblTaskingList.register(UINib(nibName: "WorkingListCell", bundle: nil), forCellReuseIdentifier: "Cell")
        self.tblTaskingList.estimatedRowHeight = CGFloat(100)
        self.tblTaskingList.rowHeight = CGFloat(100)
        self.tblTaskingList.backgroundColor = UIColor.clear
        self.tblTaskingList.tableFooterView = UIView(frame: CGRect.zero)
        self.tblTaskingList.translatesAutoresizingMaskIntoConstraints = false
        
        self.resetFieldValues()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.initConstantHeights()
        self.refreshWeatherInfo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPressMoreInfo(sender:UIButton){

        UIView.animate(withDuration: 0.4) {
            
            self.isExpand = !self.isExpand

            let sec:Int = self.isExpand ? 0 : 1
            
            if self.isExpand{
                self.constWeatherHeight.constant = CGFloat(self.mainView.frame.height)
                self.constDetailHeight.constant = CGFloat(self.dHeight)
            }else{
                self.constWeatherHeight.constant = CGFloat(self.mainView.frame.height - self.dHeight)
                self.constDetailHeight.constant = CGFloat(0.0)
            }

            self.changeButtonImage()
            self.vwDetails.layoutIfNeeded()
            self.mainView.layoutIfNeeded()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(sec), execute: {
                
                self.lblFeelLike.isHidden = self.isExpand
                self.imgWeatherInfo.isHidden = self.isExpand
            })
            
            if let _ = self.container, let pCtrl = self.container!.pageController{
                
                if self.isExpand{
                    pCtrl.startPagesSpining()
                }else{
                    pCtrl.stopPageSpining()
                }
            }
        }
        
    }
    
    private func initConstantHeights(){
        
        self.dHeight = CGFloat(self.mainView.frame.height * 60/100)
        self.constWeatherHeight.constant = CGFloat(self.mainView.frame.height - self.dHeight)
        self.constDetailHeight.constant = CGFloat(0.0)
        
        self.vwDetails.layoutIfNeeded()
        self.mainView.layoutIfNeeded()
    }
    
    private func resetFieldValues(){
        
        self.isExpand = false

        self.imgWeatherInfo.isHidden = true
        self.lblPlaceName.reset()
        self.lblFeelLike.reset()
        self.lblTemperature.text = "- -"
        self.lblConditionDesc.reset()
        self.lblMaxMinTemperature.reset()
        self.lblToday.text = Date().now.dayName
        self.changeButtonImage()
        
    }
    
    private func changeButtonImage(){
       
        let ddDown = UIImage(named: "Double Down_50")
        let ddUp = UIImage(named: "Double Up_50")
        
        self.btnExpand.setImage(self.isExpand ? ddUp : ddDown, for: .normal)
    }
    
    private func refreshWeatherInfo(){

        //Retrieve Last Location
        let lastLocation = try! LocationRepo.shared.GetLocation(.Phone,on: self.today)
        
        func createNewWeather(){
            
            self.userLocation!.type = LocationType.Phone
            
            let newLocation = try! LocationRepo.shared.CreateOrReplace(self.userLocation!)
            let newWeather = try! WeatherRepo.shared.CreateWeather(on: self.today, at: newLocation)
                
            self.getWeatherAPIResults(at: newLocation!, linkTo: newWeather!)
            
            DispatchQueue.main.async {
                print("Saving")
                _ = try! RepositoryBase.shared.Save()
            }
        }
        
        func loadLastWeather(){
            self.getWeatherSavedResult(at: lastLocation!)
        }
        
        LocationManager.shared.GetNearestCity { (json) in

            var isNewWeather:Bool = true
            
            self.userLocation = UserLocation(address: json)
            let isNewLocation:Bool = lastLocation == nil ? true : (lastLocation?.locationCity != self.userLocation!.city)
            
            self.lblPlaceName.text = self.userLocation!.city
            gCountryCode = self.userLocation!.countryCode!
        
            if !isNewLocation{
                 //Same Location, retrieve Weather data from CoreData If weahter last modifiedOn < 30min elpased
                if let lastWeatherDate = try! WeatherRepo.shared.GetWeather(on: self.today, at: lastLocation) {
                    
                    if let lastModifiedDate = lastWeatherDate.modifiedOn as? Date{
                        isNewWeather = lastModifiedDate.elapsedInMinutes(Date().now) < 15 ? false : true
                    }
                }
            }
            
            if isNewLocation || isNewWeather {
                createNewWeather()
            }else{
                //loadLastWeather()
                createNewWeather()
            }
        }
    }

    private func getWeatherSavedResult(at location:Location){
        
        if let weather = try! WeatherRepo.shared.GetWeather(on: self.today, at:location) {
            
            if let results = WeatherDetailRepo.shared.GetWeatherDetail(on: self.today, header: weather){
             
                for re in results{
                    
                    let type = WeatherResultType(rawValue: re.wdType!)
                    
                    switch type! {
                    case .Astronomy:
                        self.astronomy = re.wdResult as? AstronomyResult
                        self.populateAstronomyResult()
                    case .Condition:
                        self.conditions = re.wdResult as? ConditionsResult
                        self.populateConditionsResult()
                    case .Forecast:
                        self.forecast = re.wdResult as? ForecastResult
                        self.populateForecastResult()
                    case .Forecast10Day:
                        self.forecast = re.wdResult as? ForecastResult
                        self.populateForecast10DaysResult()
                    case .Hourly:
                        self.hourly = re.wdResult as? HourlyResult
                        self.populateHourlyResult()
                    default:
                        break
                    }
                }
            }
        }
    }

    private func getWeatherAPIResults(at location:Location, linkTo newWeather:Weather){
       
        let location:String = location.locationCity!
        
        WeatherAPI.shared.GetCondition(at: location) { (result) in
            
            DispatchQueue.main.async(){
                
                self.conditions = result.item[0]
                self.populateConditionsResult()
                
                let detail = WeatherDetailRepo.shared.CreateWeatherDetail(self.conditions!, type: .Condition, header: newWeather)
                newWeather.addToDetail(detail)
                
                print("condition population completed !")
            }
        }
        
        WeatherAPI.shared.GetAstronomy(at: location) { (result) in
            
            DispatchQueue.main.async(){
                
                self.astronomy = result.item[0]
                self.populateAstronomyResult()
                
                let detail = WeatherDetailRepo.shared.CreateWeatherDetail(self.astronomy!, type: .Condition, header: newWeather)
                newWeather.addToDetail(detail)
                
                print("astronomy population completed !")
            }
        }
        
        WeatherAPI.shared.GetForecast(at: location) { (result) in
            
            DispatchQueue.main.async {
                
                self.forecast = result.item[0]
                self.populateForecastResult()
                
                let detail = WeatherDetailRepo.shared.CreateWeatherDetail(self.forecast!, type: .Condition, header: newWeather)
                newWeather.addToDetail(detail)
                
                print("forecast population completed !")
            }
        }
        
        WeatherAPI.shared.GetHourly(at: location) { (result) in
            
            DispatchQueue.main.async {
                
                self.hourly = result.item[0]
                self.populateHourlyResult()
                
                let detail = WeatherDetailRepo.shared.CreateWeatherDetail(self.hourly!, type: .Condition, header: newWeather)
                newWeather.addToDetail(detail)
                
                print("hourly population completed !")
            }
        }
        
        WeatherAPI.shared.GetForecast10Days(at: location, completion: { (result) in
            
            DispatchQueue.main.async {
                
                self.daily = result.item[0]
                self.populateForecast10DaysResult()
                
                let detail = WeatherDetailRepo.shared.CreateWeatherDetail(self.daily!, type: .Condition, header: newWeather)
                newWeather.addToDetail(detail)
                
                print("forecast 10 days population completed !")
            }
        })
    }

    private func populateConditionsResult(){
        
        if let cond = self.conditions{
            
            //Update Condition Page
            if let _ = self.container, let pCtrl = self.container!.pageController{
                
                let o = pCtrl.pages[0] as! ConditionPageController
                o.condResult = cond
                o.populateConditionInfo()
            }
            
            if let w = cond.weather {
                
                self.lblTemperature.text = gTemperatureUnit == SnackKit.TemperatureUnit.Celsius ?
                    "\(w.temp.celcius.localize(format: "%.0f"))\(dsymbol)" :
                    "\(w.temp.fahrenheit.localize(format: "%.0f"))\(dsymbol)"
                
                self.weatherDesc = "\(w.description)"
                
                self.imgCondition.image = WeatherStatic.GetIcon(name: w.description)
                
                self.weatherInfo.append(("Humidity_25"," Humidity \(w.humidity)"))
            }
            
            if let f = cond.feel {
                //self.weatherInfo.append("Feels Like \(f.celcius.localize(format: "%.0f"))".degreeFormat)
                if gTemperatureUnit == SnackKit.TemperatureUnit.Celsius {
                    self.weatherInfo.append(("temperature_25"," Feels Like \(f.celcius.localize(format: "%.0f"))".degreeFormat))
                }else{
                    self.weatherInfo.append(("temperature_25"," Feels Like \(f.fahrenheit.localize(format: "%.0f"))".degreeFormat))
                }
            }
            
            if let w = cond.wind{
                self.weatherInfo.append(("wind_25"," \(w.dir), \(w.mph)MPH"))
            }
            
            if let v = cond.visibility{
                self.weatherInfo.append(("visible_25"," Visiblity \(v.km)KM"))
            }
            
            if let u = cond.uv{
                self.weatherInfo.append(("uv_25","\(u.uvDescription)"))
            }
            
            if self.weatherInfo.count > 0{
                
                self.timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(MainController.updateWeatherCondition), userInfo: nil, repeats: true)
                
                self.weatherView.layoutIfNeeded()
            }
            
        }else{
            self.alert(title: "Warning", message: "Application is failed to get weather info from server.Please try again.")
        }
    }
    
    private func populateAstronomyResult(){
        
        if let astro = self.astronomy{
            
            //Update Condition Page
            if let _ = self.container, let pCtrl = self.container!.pageController{
                
                let o = pCtrl.pages[0] as! ConditionPageController
                o.astronomyResult = astro
                o.populateAstronomyInfo()
            }
            
            if let sr = astro.sunrise{
                self.weatherInfo.append(("Sunrise_25"," Sunrise at " + "\(sr.hour):\(sr.minutes)".hour12Format))
            }
            
            if let ss = astro.sunset{
                self.weatherInfo.append(("Sunset_25"," Sunset at " + "\(ss.hour):\(ss.minutes)".hour12Format))
            }

        }else{
            self.alert(title: "Warning", message: "Application is failed to get weather info from server.Please try again.")
        }
    }
    
    private func populateForecastResult(){
        
        if let fc = self.forecast{
            
            //Update Condition Page
            if let _ = self.container, let pCtrl = self.container!.pageController{
                
                let o = pCtrl.pages[0] as! ConditionPageController
                o.forecastResult = fc
                o.populateForecastInfo()
            }
            
            let sf = fc.simplyForecast
            let todayFC = sf[0] 
            
            let highTemp = gTemperatureUnit == .Celsius ? todayFC.high.celcius.degreeFormat : todayFC.high.fahrenheit.degreeFormat
            let lowTemp = gTemperatureUnit == .Celsius ? todayFC.low.celcius.degreeFormat : todayFC.low.fahrenheit.degreeFormat
            
            self.weatherInfo.append(("temperature_25","     \(lowTemp) / \(highTemp)"))
            self.lblMaxMinTemperature.text = "\(lowTemp) / \(highTemp)"
        }
    }
    
    private func populateHourlyResult(){
        
        if let hr = self.hourly{
            
            if let _ = self.container, let pCtrl = self.container!.pageController{
                let o = pCtrl.pages[1] as! Condition2PageController
                o.hourlyResult = hr
            }
        }
    }
    
    private func populateForecast10DaysResult(){
        
        if let daily = self.daily{
            
            if let _ = self.container, let pCtrl = self.container!.pageController{
                let o = pCtrl.pages[1] as! Condition2PageController
                o.dailyResult = daily
            }
        }
    }
    
    public func updateWeatherCondition(){
    
        self.lblFeelLike.TransiteFromTop(duration: 0.3)
        self.lblFeelLike.text = self.weatherInfo[self.counter].value
        
        self.imgWeatherInfo.isHidden = self.isExpand ? true : false
        self.imgWeatherInfo.TransiteFromTop(duration: 0.3)
        self.imgWeatherInfo.image = UIImage(named: self.weatherInfo[self.counter].icon)
        
        self.counter = (self.weatherInfo.count-1 == self.counter ? 0 : self.counter + 1)
    }
    
    // MARK : - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == SegueOfContainer{
            
            let destination = segue.destination as! ContainerController
            destination.thisParent = self
            
            self.container = destination
        }
    }
}
