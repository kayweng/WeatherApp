//
//  ContainerController.swift
//  WeatherApp
//
//  Created by kay weng on 07/01/2017.
//  Copyright © 2017 snackcode.org. All rights reserved.
//

import UIKit

class ContainerController: UIViewController {

    var thisParent:UIViewController!
    var pageController:WeatherInfoPagesController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.performSegue(withIdentifier: "SegueOfPageView", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK : Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! WeatherInfoPagesController
        
        destinationVC.root = thisParent!
       
        self.addChildViewController(destinationVC as UIViewController)
        
        segue.destination.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width,height: self.view.frame.size.height)
        
        self.view.addSubview(segue.destination.view)
        
        self.pageController = destinationVC
    }
}
