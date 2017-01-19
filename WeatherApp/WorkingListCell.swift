//
//  WorkingListCell.swift
//  WeatherApp
//
//  Created by kay weng on 05/01/2017.
//  Copyright © 2017 snackcode.org. All rights reserved.
//

import UIKit

class WorkingListCell: UITableViewCell, UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var lblWorking: UILabel!
    @IBOutlet weak var vmHome: UIView!
    @IBOutlet weak var imgHome: UIImageView!
    @IBOutlet weak var lblHome: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var vmOffice: UIView!
    @IBOutlet weak var imgOffice: UIImageView!
    @IBOutlet weak var lblOffice: UILabel!
    @IBOutlet weak var collWeather: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.vmHome.circle()
        self.vmOffice.circle()
        
        self.lblHome.text = "Home"
        self.lblOffice.text = "Office"
        self.lblDistance.text = "0 km"
        
        self.collWeather.register(UINib(nibName:"WeatherIconCell", bundle:nil), forCellWithReuseIdentifier: "Cell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - UICollectionViewCell
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.collWeather.frame.width/3, height: 50)
    }
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:WeatherIconCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! WeatherIconCell
        
        return cell
    }
}
