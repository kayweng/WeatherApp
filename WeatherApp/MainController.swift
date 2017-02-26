//
//  MainController.swift
//  WeatherApp
//
//  Created by kay weng on 01/01/2017.
//  Copyright © 2017 snackcode.org. All rights reserved.
//

import UIKit
import SnackKit
import CoreLocation

private let SegueOfContainer = "SegueOfContainer"

class MainController: UIViewController, CLLocationManagerDelegate {

    // MARK: - UI Fields
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
    
    // MARK: - Variables
    var dHeight = CGFloat(0.0)
    var counter:Int = 0
    var timer = Timer()
    var isExpand = false
    var isNetworkUnReachable = false
    
    var shortcutWD:[(icon:String,value:String)] = []
    var weatherDesc:String = ""{
        didSet{
            self.lblConditionDesc.text = weatherDesc
        }
    }
    
    var vm:MainWeatherVM = MainWeatherVM()
    
    // MARK: - Screen Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.weatherView.backgroundColor = .clear
        
        self.weatherView.backgroundColor = StaticFactory.currentPartOfDay() == PartsOfDay.Night ? UIColor(patternImage: UIImage(named: "bg-night")!) : UIColor(patternImage: UIImage(named: "bg-sky")!)
        
        self.tblTaskingList.register(UINib(nibName: "WorkingListCell", bundle: nil), forCellReuseIdentifier: "Cell")
        self.tblTaskingList.estimatedRowHeight = CGFloat(100)
        self.tblTaskingList.rowHeight = CGFloat(100)
        self.tblTaskingList.backgroundColor = UIColor.clear
        self.tblTaskingList.tableFooterView = UIView(frame: CGRect.zero)
        self.tblTaskingList.translatesAutoresizingMaskIntoConstraints = false
        
        self.resetFieldValues()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard isNetworkUnReachable else {
            //self.alert(title: "Error", message: "No Internet Connection")
            
            
            
            return
        }
        
        if self.timer.timeInterval <= 0 {
            self.initConstantHeights()
            self.initLocation()
        }
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

            self.btnExpand.setImage(self.isExpand ? UIImage(named: "Double Up_50") : UIImage(named: "Double Down_50"), for: .normal)
            
            self.vwDetails.layoutIfNeeded()
            self.mainView.layoutIfNeeded()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(sec), execute: {
                
                self.lblFeelLike.isHidden = self.isExpand
                self.imgWeatherInfo.isHidden = self.isExpand
            })
        }
    }
    
    // MARK : - Private Functions
    public func initLocation(){
        
        LocationManager.shared.GetNearestCity { (json) in
            
            let location = UserLocation(address: json)
            self.lblPlaceName.text = location.city
            
            self.vm.initWeatherResult(location: location, completion: { 
                print("View Model is instantiated")
                self.populateConditionsResult()
                self.populateAstronomyResult()
                self.populateForecastResult()
                self.populateHourlyResult()
                self.populateForecast10DaysResult()
                print("Done Weather Result population")
            })
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
        
        self.btnExpand.setImage(self.isExpand ? UIImage(named: "Double Up_50") : UIImage(named: "Double Down_50"), for: .normal)
    }
    
    public func updateWeatherCondition(){
        
        self.lblFeelLike.TransiteFromTop(duration: 0.3)
        self.lblFeelLike.text = self.shortcutWD[self.counter].value
        
        self.imgWeatherInfo.isHidden = self.isExpand ? true : false
        self.imgWeatherInfo.TransiteFromTop(duration: 0.3)
        self.imgWeatherInfo.image = UIImage(named: self.shortcutWD[self.counter].icon)
        
        self.counter = (self.shortcutWD.count-1 == self.counter ? 0 : self.counter + 1)
    }

    // MARK: - Populate Weather Results
    private func populateConditionsResult(){
        
        if let cond = self.vm.conditions{
            
            //Update Condition Page
            if let _ = self.container, let pCtrl = self.container!.pageController{
                
                let o = pCtrl.pages[0] as! ConditionPageController
                o.condResult = cond
                o.populateConditionInfo()
            }
            
            self.lblTemperature.text = gTemperatureUnit == SnackKit.TemperatureUnit.Celsius ?
                    "\(cond.weather.temp.celsius.localize(format: "%.0f"))\(dsymbol)" :
            "\(cond.weather.temp.fahrenheit.localize(format: "%.0f"))\(dsymbol)"
            
            self.weatherDesc = "\(cond.weather.description)"
            
            self.imgCondition.image = WeatherStatic.GetIcon(name: cond.weather.description)
            
            self.shortcutWD.append(("Humidity_25"," Humidity \(cond.weather.humidity)"))
            
            if gTemperatureUnit == SnackKit.TemperatureUnit.Celsius {
                self.shortcutWD.append(("temperature_25"," Feels Like \(cond.feel.celsius.localize(format: "%.0f"))".degreeFormat))
            }else{
                self.shortcutWD.append(("temperature_25"," Feels Like \(cond.feel.fahrenheit.localize(format: "%.0f"))".degreeFormat))
            }
            
            self.shortcutWD.append(("wind_25"," \(cond.wind.dir), \(cond.wind.mph) MPH"))
            self.shortcutWD.append(("visible_25"," Visiblity \(cond.visibility.km) KM"))
            self.shortcutWD.append(("uv_25","\(cond.uv.uvDescription)"))
            
            if self.shortcutWD.count > 0 && self.timer.timeInterval <= 0{
                
                self.timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(MainController.updateWeatherCondition), userInfo: nil, repeats: true)
                
                self.weatherView.layoutIfNeeded()
            }
            
        }else{
            self.alert(title: "Warning", message: "Application is failed to get weather info from server.Please try again.")
        }
    }
    
    private func populateAstronomyResult(){
        
        if let astro = self.vm.astronomy{
            
            //Update Condition Page
            if let _ = self.container, let pCtrl = self.container!.pageController{
                
                let o = pCtrl.pages[0] as! ConditionPageController
                o.astronomyResult = astro
                o.populateAstronomyInfo()
            }
            
             self.shortcutWD.append(("Sunrise_25"," Sunrise at " + "\(astro.sunrise.hour):\(astro.sunrise.minutes)".hour12Format))
             self.shortcutWD.append(("Sunset_25"," Sunset at " + "\(astro.sunset.hour):\(astro.sunset.minutes)".hour12Format))
        }else{
            self.alert(title: "Warning", message: "Application is failed to get weather info from server.Please try again.")
        }
    }
    
    private func populateForecastResult(){
        
        if let fc = self.vm.forecast{
            
            //Update Condition Page
            if let _ = self.container, let pCtrl = self.container!.pageController{
                
                let o = pCtrl.pages[0] as! ConditionPageController
                o.forecastResult = fc
                o.populateForecastInfo()
            }
            
            let sf = fc.simplyForecast
            let todayFC = sf[0] 
            
            let highTemp = gTemperatureUnit == .Celsius ? todayFC.high.celsius.degreeFormat : todayFC.high.fahrenheit.degreeFormat
            let lowTemp = gTemperatureUnit == .Celsius ? todayFC.low.celsius.degreeFormat : todayFC.low.fahrenheit.degreeFormat
            
            self.shortcutWD.append(("temperature_25","  \(lowTemp) / \(highTemp)"))
            self.lblMaxMinTemperature.text = "\(lowTemp) / \(highTemp)"
        }
    }
    
    private func populateHourlyResult(){
        
        if let hr = self.vm.hourly{
            
            if let _ = self.container, let pCtrl = self.container!.pageController{
                let o = pCtrl.pages[1] as! Condition2PageController
                o.hourlyResult = hr
            }
        }
    }
    
    private func populateForecast10DaysResult(){
        
        if let daily = self.vm.daily{
            
            if let _ = self.container, let pCtrl = self.container!.pageController{
                let o = pCtrl.pages[1] as! Condition2PageController
                o.dailyResult = daily
            }
        }
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == SegueOfContainer{
            
            let destination = segue.destination as! ContainerController
            destination.thisParent = self

            self.container = destination
        }
    }
    
    // MARK: - Location Delegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        if status == .notDetermined || status == .denied{
            self.btnExpand.isEnabled = false
            self.lblPlaceName.text = "Location Unknown"
        }else{
            self.btnExpand.isEnabled = true
            self.lblPlaceName.text = ""
            initLocation()
        }
    }
}
