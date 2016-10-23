///Users/ws/Desktop/1306foriPhone
//  WSTabBarController.swift
//  1306foriPhone
//
//  Created by ws on 2016/10/22.
//  Copyright © 2016年 WS. All rights reserved.
//

import UIKit

class WSTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpSubControllers()
    }
    
    private func setUpSubControllers() {
        
        let ticketVc = WSGrapTicketontroller()
        let ticketNav = WSNavigationController(rootViewController: ticketVc)
        let orderVc = WSOrderController()
        let orderNav = WSNavigationController(rootViewController: orderVc)
        let viewControllers = [ticketNav, orderNav]
        
        setViewControllers(viewControllers, animated: true)
        setTabBarItems(viewControllers: viewControllers)
    }
    
    private func setTabBarItems(viewControllers: [UIViewController]) {
        let titles = ["抢票", "订单"]
        let images = ["tab_index", "tab_order"]
        let selectImages = ["tab_index_s", "tab_order_s"]
        for (index, vc) in viewControllers.enumerated() {
            
            vc.tabBarItem = UITabBarItem(title: titles[index], image: UIImage(named: images[index]), selectedImage: UIImage(named: selectImages[index]))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
