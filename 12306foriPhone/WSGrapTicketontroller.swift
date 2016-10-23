//
//  WSGrapTicketontroller.swift
//  1306foriPhone
//
//  Created by ws on 2016/10/22.
//  Copyright © 2016年 WS. All rights reserved.
//

import UIKit

class WSGrapTicketontroller: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "抢票"
        view.backgroundColor = .brown
        
        setUpNavItem()
    }
    
    private func setUpNavItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "tab_grap"), landscapeImagePhone: UIImage(named: "tab_grap"), style: .plain, target: self, action: #selector(WSGrapTicketontroller.startGrapTicket))
    }
    
// MARK: action
    func startGrapTicket() {
        
        if !WSLogin.checkLogin() {return}
        print(11111)
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
