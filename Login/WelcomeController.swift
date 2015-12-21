//
//  WelcomeController.swift
//  Ten
//
//  Created by gt on 15/11/1.
//  Copyright © 2015年 LiMao Tech. All rights reserved.
//

import UIKit
import AFNetworking
import CryptoSwift

class WelcomeController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signupBtn: UIButton!
    
    @IBOutlet weak var unmatchedLB: UILabel!
    
    @IBAction func loginAct(sender: AnyObject) {
        login()
    }
    
    @IBAction func signupAct(sender: AnyObject) {
        
        var pwdTF : UITextField?
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "取消", style: .Cancel) { action -> Void in
            self.unmatchedLB.hidden = true
        }
        
        let nextAction: UIAlertAction = UIAlertAction(title: "验证", style: .Default) { action -> Void in
            if pwdTF!.text! == self.passwordTF.text! {
                self.navigationController?.navigationBar.hidden = false
                let rpVC = RegistProfileViewController()
                rpVC.email = self.emailTF.text!
                rpVC.password = self.passwordTF.text!
                self.presentViewController(rpVC, animated: true, completion: nil)
            }
            else {
                self.unmatchedLB.hidden = false
            }
        }
        
        if self.passwordTF.text!.isEmpty || emailTF.text!.isEmpty {
            let emptyAlertController = UIAlertController(title: "请输入邮箱和密码。", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            self.presentViewController(emptyAlertController, animated: true, completion: nil)
            emptyAlertController.addAction(cancelAction)
        }
        
        else if !isValidEmail(emailTF.text!) {
            let invalidEmailAlertController = UIAlertController(title: "请输入正确的邮箱。", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            self.presentViewController(invalidEmailAlertController, animated: true, completion: nil)
            invalidEmailAlertController.addAction(cancelAction)
        }
        else {
            
            let passwordAlertController = UIAlertController(title: "密码验证", message: "请重新输入密码以完成注册。", preferredStyle: UIAlertControllerStyle.Alert)
            passwordAlertController.addAction(cancelAction)
            passwordAlertController.addAction(nextAction)
            passwordAlertController.addTextFieldWithConfigurationHandler { textField -> Void in
                pwdTF = textField
            }
            self.presentViewController(passwordAlertController, animated: true, completion: nil)
        }
    }
    
    var splitView:UIView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.unmatchedLB.hidden = true
        self.view.backgroundColor = BG_COLOR
        
        emailTF.textColor = UIColor.whiteColor()
        emailTF.backgroundColor = UIColor.blackColor()
        emailTF.delegate = self
        emailTF.returnKeyType = .Done
        emailTF.setValue(WHITEGRAY_COLOR, forKeyPath: "_placeholderLabel.textColor")
        
        passwordTF.textColor = UIColor.whiteColor()
        passwordTF.backgroundColor = UIColor.blackColor()
        passwordTF.delegate = self
        passwordTF.returnKeyType = .Done
        passwordTF.setValue(WHITEGRAY_COLOR, forKeyPath: "_placeholderLabel.textColor")
        
    }
    
    func doneClicked(){
        self.view.endEditing(true)
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    
    // MARK: - Helpers
    func isValidEmail(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    func login() {
        let cancelAction = UIAlertAction(title: "确定", style: .Cancel, handler: { (action) -> Void in
        })
        if self.passwordTF.text!.isEmpty || emailTF.text!.isEmpty {
            let emptyAlertController = UIAlertController(title: "请输入邮箱和密码。", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            self.presentViewController(emptyAlertController, animated: true, completion: nil)
            emptyAlertController.addAction(cancelAction)
        }
        if !isValidEmail(emailTF.text!) {
            let invalidEmailAlertController = UIAlertController(title: "请输入正确的邮箱。", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            self.presentViewController(invalidEmailAlertController, animated: true, completion: nil)
            invalidEmailAlertController.addAction(cancelAction)
            return
        }

        let afManager = AFHTTPRequestOperationManager()
        let timeStamp = Tools.getNormalTime(NSDate())
        
        let stringHash = "\(emailTF.text!)\(passwordTF.text!)\(timeStamp)\(UUID)\(DEVICE_TOKEN!)\(COMPANYCODE)"
//        let stringHashPrint = "\(emailTF.text!)|\(passwordTF.text!)|\(timeStamp)|\(UUID)|\(DEVICE_TOKEN!)|\(COMPANYCODE)"
        let hashResult = stringHash.sha256()
        
//        print(stringHashPrint)
//        print("hashresult"+hashResult)
        
        let url:NSString = LoginUrl+"?userID=\(emailTF.text!)&userPWD=\(passwordTF.text!)&lastLogin=\(timeStamp)&DeviceUUID=\(UUID)&DeviceToken=\(DEVICE_TOKEN!)&HashValue=\(hashResult)"
        let urlNew = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        
        
        afManager.requestSerializer = AFJSONRequestSerializer()
        afManager.responseSerializer = AFJSONResponseSerializer()
        
        afManager.GET(urlNew!,
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                let dict = responseObject as! NSDictionary
                print(dict)
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                    let nVC = storyBoard.instantiateViewControllerWithIdentifier("NavController")
                    self.presentViewController(nVC, animated: true, completion: { () -> Void in
                    })
                })
            },
            failure: { (operation,error) in
                print("Error: " + error.localizedDescription)
                let data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as! NSData
//                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                let dict = try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
                print(dict)
                
//                if(responseCode == 4000){
//                    let AlertController = UIAlertController(title: "用户名不存在", message: "", preferredStyle: UIAlertControllerStyle.Alert)
//                    self.presentViewController(AlertController, animated: true, completion: nil)
//                    AlertController.addAction(cancelAction)
//                }else if(responseCode == 4003){
//                    let AlertController = UIAlertController(title: "密码错误", message: "", preferredStyle: UIAlertControllerStyle.Alert)
//                    self.presentViewController(AlertController, animated: true, completion: nil)
//                    AlertController.addAction(cancelAction)
//                }
        })
    }

}
