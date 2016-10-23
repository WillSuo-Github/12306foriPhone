//
//  WSLoginController.swift
//  1306foriPhone
//
//  Created by ws on 2016/10/22.
//  Copyright © 2016年 WS. All rights reserved.
//

import UIKit

class WSLoginController: UIViewController {
    
    var myService = WSService()
    

    @IBOutlet weak var accountTF: UITextField!
    @IBOutlet weak var pwdTF: UITextField!
    @IBOutlet weak var detailView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        requestPassCode()
    }
    
    private func requestPassCode() {
        myService.requestLoginCode(successBlock: { (returnImage) in
            
            let imageV = UIImageView(image: returnImage)
            imageV.frame = self.detailView.bounds
            self.detailView.addSubview(imageV)
            }) { (error) in
                print(error)
        }
    }

//MARK: action
    @IBAction func closeBtnChick(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func loginBtnAction(_ sender: AnyObject) {
        
    }

}
