//
//  WSLoginController.swift
//  1306foriPhone
//
//  Created by ws on 2016/10/22.
//  Copyright © 2016年 WS. All rights reserved.
//

import UIKit
import SnapKit

class WSLoginController: UIViewController {
    
    var myService = WSService()
    

    @IBOutlet weak var accountTF: UITextField!
    @IBOutlet weak var pwdTF: UITextField!
    @IBOutlet weak var detailView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        requestPassCode()
    }
    
    
//MARK: network
    private func requestPassCode() {

        
        myService.requestLoginCode(randomCode:randomCodeView.randomCode.description, successBlock: { (returnImage) in
            
            self.randomCodeView.myImage = returnImage
            self.detailView.addSubview(self.randomCodeView)
            self.randomCodeView.snp.makeConstraints({ (make) in
               make.edges.equalToSuperview()
            })
            
            }) { (error) in
                print(error)
        }
    }
    
    private func requestLogin() {
        myService.requestLogin(randomCode: randomCodeView.selectCode, successBlock: { responseData in
            
        }, failBlock: { error in

        })
    }

//MARK: action
    @IBAction func closeBtnChick(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func loginBtnAction(_ sender: AnyObject) {
        
        requestLogin()
    }
//MARK: lazy
    lazy var randomCodeView: WSLoginRandomCodeView = {
        var tmpView = WSLoginRandomCodeView(frame: self.detailView.bounds)
        return tmpView
    }()
}
