//
//  WeatherInfoPagesController.swift
//  WeatherApp
//
//  Created by kay weng on 08/01/2017.
//  Copyright © 2017 snackcode.org. All rights reserved.
//

import UIKit
import SnackKit

class WeatherInfoPagesController: UIPageViewController, UIPageViewControllerDelegate {

    var root:UIViewController!
    var pages: [UIViewController] = []
    var currentPageIndex:Int = 0
    var timer:Timer = Timer()
   
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        self.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        pageAssignment()
        
        if let first = self.pages.first {
            
            self.setViewControllers([first],
                                    direction: .forward,
                                    animated: false,
                                    completion: nil)
        }
    }
    
    private func initPageController(_ name:String)->UIViewController{
        
        return sb.instantiateViewController(withIdentifier: name)
    }
    
    private func pageAssignment(){
        
        if pages.count > 0 {
            for i in 0...self.pages.count-1{
                pages[i].willMove(toParentViewController: nil)
                pages[i].removeFromParentViewController()
            }
        }
        
        pages.removeAll()
        
        //condition page
        let condPage:ConditionPageController = self.initPageController("ConditionPage") as! ConditionPageController
        let hourlyPage:Condition2PageController = self.initPageController("ConditionPage2") as! Condition2PageController
        
        pages.append(condPage)
        pages.append(hourlyPage)

    }
    
    public func startPagesSpining(){
        
        self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(WeatherInfoPagesController.shiftPage), userInfo: nil, repeats: true)
        
    }
    
    @objc private func shiftPage(){
        
        if self.currentPageIndex == 1{
            
            self.setViewControllers([self.pages[0]], direction: .reverse, animated: true, completion: { (done) in
                self.currentPageIndex = 0
            })
            
        }else{
            
            self.setViewControllers([self.pages[1]], direction: .forward, animated: true, completion: { (done) in
                self.currentPageIndex = 1
            })
        }
    }
}


extension WeatherInfoPagesController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    }
    
    @objc(pageViewController:willTransitionToViewControllers:) func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]){
        
        if pageViewController.viewControllers?.count == 1 && pendingViewControllers.count == 1 {
            
            if pageViewController.viewControllers![0].className == pendingViewControllers[0].className{
                
                
            }
        }
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.pages.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pages.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1 < 0 ? pages.count - 1 : viewControllerIndex - 1
        self.currentPageIndex = previousIndex
        
        guard previousIndex >= 0 else {
            return pages.last
        }
        
        guard pages.count > previousIndex else {
            return nil
        }
        
        pages[previousIndex].removeFromParentViewController()
        
        return self.pages[self.currentPageIndex]
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pages.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1 >= pages.count ? 0 : viewControllerIndex + 1
        let orderedViewControllersCount = pages.count
        
        self.currentPageIndex = nextIndex
        
        guard orderedViewControllersCount != nextIndex else {
            return pages.first
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        self.addChildViewController(pages[nextIndex])
        
        return pages[nextIndex]
    }

}
