//
//  WSLoginController.swift
//  1306foriPhone
//
//  Created by ws on 2016/10/22.
//  Copyright © 2016年 WS. All rights reserved.
//

import UIKit
import SnapKit

class WSLoginController: UIViewController, NVActivityIndicatorViewable {
    
    var myService = WSService.shardInstance
    

    @IBOutlet weak var accountTF: UITextField!
    @IBOutlet weak var pwdTF: UITextField!
    @IBOutlet weak var detailView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        requestLoginInit()
        
        
    }
    
    
//MARK: network
    private func requestLoginInit() {

        self.randomCodeView.showHub()
        myService.preLoginFlow(success: { image in
            
            self.randomCodeView.hideHub()
            self.randomCodeView.myImage = image
            self.detailView.addSubview(self.randomCodeView)
            self.randomCodeView.snp.makeConstraints({ (make) in
                make.edges.equalToSuperview()
            })
        }) { error in
            print(error)
        }
    }

//MARK: action
    @IBAction func closeBtnChick(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func reloadImageButtonDidTapped(_ sender: Any) {
        requestLoginInit()
    }
    @IBAction func loginBtnAction(_ sender: AnyObject) {
        
        if accountTF.text == "" || pwdTF.text == "" {
            return
        }
        
        if randomCodeView.selectCode == "" {
            return
        }
        
        self.startAnimating()
        let failureHandler = { (error: NSError) in
            self .stopAnimating()
            print(error)
        }
        
        let successHandler = {
            
            self .stopAnimating()
        }
        
        myService.loginFlow(user: accountTF.text!, passWord: pwdTF.text!, randCodeStr: self.randomCodeView.selectCode, success: successHandler, failure: failureHandler)
    }
//MARK: lazy
    lazy var randomCodeView: WSLoginRandomCodeView = {
        var tmpView = WSLoginRandomCodeView(frame: self.detailView.bounds)
        return tmpView
    }()
}
