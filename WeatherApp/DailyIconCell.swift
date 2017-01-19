//
//  DailyIconCell.swift
//  WeatherApp
//
//  Created by kay weng on 18/01/2017.
//  Copyright © 2017 snackcode.org. All rights reserved.
//

import UIKit

class DailyIconCell: UICollectionViewCell {

    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var imgCondition: UIImageView!
    @IBOutlet weak var lblTemperature: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblDay.text = ""
        self.lblTemperature.text = "- -"
        self.imgCondition.image = WeatherStatic.GetIcon(name: "")
    }

}
