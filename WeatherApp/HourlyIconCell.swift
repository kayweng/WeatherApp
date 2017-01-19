//
//  HourlyIconCell.swift
//  WeatherApp
//
//  Created by kay weng on 17/01/2017.
//  Copyright © 2017 snackcode.org. All rights reserved.
//

import UIKit

class HourlyIconCell: UICollectionViewCell {

    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblHour: UILabel!
    @IBOutlet weak var imgHour: UIImageView!
    @IBOutlet weak var lblHourTemp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.lblDay.text = ""
        self.lblHour.text = ""
        self.lblHourTemp.text = "- -"
        self.imgHour.image = WeatherStatic.GetIcon(name: "")
        
        self.underlined(width: 1.0, color: UIColor.lightGray)
    }
}
