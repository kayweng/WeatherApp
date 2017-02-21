//
//  ConditionPageController.swift
//  WeatherApp
//
//  Created by kay weng on 08/01/2017.
//  Copyright © 2017 snackcode.org. All rights reserved.
//

import UIKit
import SnackKit

class ConditionPageController: UITableViewController {

    @IBOutlet weak var cellHumidity: UITableViewCell!
    @IBOutlet weak var cellFeelsLike: UITableViewCell!
    @IBOutlet weak var cellWind: UITableViewCell!
    @IBOutlet weak var cellVisibility: UITableViewCell!
    @IBOutlet weak var cellUVIndex: UITableViewCell!
    @IBOutlet weak var cellSunPhase: UITableViewCell!
    @IBOutlet weak var cellDescription: UITableViewCell!
    
    @IBOutlet weak var lblHumidityTitle: UILabel!
    @IBOutlet weak var lblFeelsLikeTitle: UILabel!
    @IBOutlet weak var lblWindTitle: UILabel!
    @IBOutlet weak var lblVisibilityTitle: UILabel!
    @IBOutlet weak var lblUVTitle: UILabel!
    @IBOutlet weak var lblSunriseTitle: UILabel!
    @IBOutlet weak var lblSunsetTitle: UILabel!
    
    @IBOutlet weak var lblHumidityValue: UILabel!
    @IBOutlet weak var lblFeelsLikeValue: UILabel!
    @IBOutlet weak var lblWindValue: UILabel!
    @IBOutlet weak var lblVisibilityValue: UILabel!
    @IBOutlet weak var lblUVValue: UILabel!
    @IBOutlet weak var lblSunriseValue: UILabel!
    @IBOutlet weak var lblSunsetValue: UILabel!
    
    @IBOutlet weak var imgSunrise: UIImageView!
    @IBOutlet weak var imgSunset: UIImageView!
    
    @IBOutlet weak var vwLine: UIView!
    @IBOutlet weak var tvDescription: UITextView!
    
    var condResult:ConditionsResult?
    var astronomyResult:AstronomyResult?
    var forecastResult:ForecastResult?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        
        self.tableView.separatorStyle = .none
        //self.tableView.backgroundColor = .clear
        self.tableView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.2)
        self.tableView.tableFooterView = UIView()
        
        self.cellHumidity.separatorInset = .zero
        self.cellFeelsLike.separatorInset = .zero
        self.cellWind.separatorInset = .zero
        self.cellVisibility.separatorInset = .zero
        self.cellUVIndex.separatorInset = .zero
        self.cellSunPhase.separatorInset = .zero
        
        self.lblHumidityTitle.textColor = .white
        self.lblFeelsLikeTitle.textColor = .white
        self.lblWindTitle.textColor = .white
        self.lblVisibilityTitle.textColor = .white
        self.lblUVTitle.textColor = .white
        self.lblSunriseTitle.textColor = .white
        self.lblSunsetTitle.textColor = .white
        
        self.lblHumidityValue.textColor = .white
        self.lblFeelsLikeValue.textColor = .white
        self.lblWindValue.textColor = .white
        self.lblVisibilityValue.textColor = .white
        self.lblUVValue.textColor = .white
        self.lblSunriseValue.textColor = .white
        self.lblSunsetValue.textColor = .white
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func populateConditionInfo(){
        
        if let cond = condResult {
            
            self.lblHumidityValue.text = cond.weather.humidity
            self.lblFeelsLikeValue.text = "\(cond.feel.celsius)\(dsymbol)"
            self.lblWindValue.text = "\(cond.wind.dir) \(cond.wind.mph)MPH"
            self.lblVisibilityValue.text = "\(cond.visibility.km) KM"
            self.lblUVValue.text = cond.uv.uvDescription + " (\(cond.uv))"
        }
    }
    
    public func populateAstronomyInfo(){
        
        if let astro = astronomyResult{
            
            self.lblSunriseValue.text = "\(astro.sunrise.hour):\(astro.sunrise.minutes)".hour12Format
            self.lblSunsetValue.text = "\(astro.sunset.hour):\(astro.sunset.minutes)".hour12Format
        }
    }
    
    public func populateForecastInfo(){
        
        if let forecast = self.forecastResult{
            
            self.tvDescription.text =  "Today : " + (
                StaticFactory.currentPartOfDay() == PartsOfDay.Morning ||
                StaticFactory.currentPartOfDay() == PartsOfDay.Afternoon ? forecast.forecastText[1].description : forecast.forecastText[0].description)
        }
    }
    
    // MARK : UITableView
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 5 {
            return CGFloat(50)
        }
        
        if indexPath.row == 6 {
            return CGFloat(70)
        }
        
        return CGFloat(40)
    }
}
