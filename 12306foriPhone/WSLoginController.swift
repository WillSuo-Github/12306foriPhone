//
//  WSLoginController.swift
//  1306foriPhone
//
//  Created by ws on 2016/10/22.
//  Copyright © 2016年 WS. All rights reserved.
//

import UIKit
import SnapKit
import YYCategories

class WSLoginController: UIViewController, NVActivityIndicatorViewable {
    
    var myService = WSService.shardInstance
    

    @IBOutlet weak var accountTF: UITextField!
    @IBOutlet weak var pwdTF: UITextField!
    @IBOutlet weak var detailView: UIView!
 
    
//MARK:- cycle life
    override func viewDidLoad() {
        super.viewDidLoad()

        configSubViews()
        requestLoginInit()
        
    }
    
//MARK:- layout
    
    private func configSubViews() {
        detailView.addSubview(self.randomCodeView)
    }
    
//MARK: network
    private func requestLoginInit() {
        randomCodeView.myImage = UIImage(color: WSConfig.WSPlaceHolderColor)!
        requestVerifyImage()
    }
    
    private func requestVerifyImage() {
        randomCodeView.showHub()
        myService.preLoginFlow(success: { image in
            
            self.randomCodeView.hideHub()
            self.randomCodeView.myImage = image
            self.randomCodeView.snp.makeConstraints({ (make) in
                make.edges.equalToSuperview()
            })
        }) { error in
            self.randomCodeView.showMessage(translate(error))
        }
    }

//MARK: tapped response
    @IBAction func closeBtnChick(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func reloadImageButtonDidTapped(_ sender: Any) {
        requestVerifyImage()
    }
    
    @IBAction func loginBtnAction(_ sender: AnyObject) {
        
        if accountTF.text == "" || pwdTF.text == "" {
            return
        }
        
        if randomCodeView.selectCode == "" {
            return
        }
        
        
        view.showLoading()
        let failureHandler = { (error: NSError) in
            
            self.view.hideLoading()
            self.view.showMessage(translate(error))
            self.randomCodeView.clearCode()
            
            self.requestVerifyImage()
        }
        
        let successHandler = {
            
            self.stopAnimating()
            self.dismiss(animated: true, completion: nil)
            WSLogin.isLogin = true
        }
        
        myService.loginFlow(user: accountTF.text!, passWord: pwdTF.text!, randCodeStr: self.randomCodeView.selectCode, success: successHandler, failure: failureHandler)
    }
    
//MARK: lazy
    lazy var randomCodeView: WSLoginRandomCodeView = {
        var tmpView = WSLoginRandomCodeView(frame: self.detailView.bounds)
        return tmpView
    }()
}
