//
//  WelcomeController.swift
//  Ten
//
//  Created by gt on 15/11/1.
//  Copyright © 2015年 LiMao Tech. All rights reserved.
//

import UIKit
import Alamofire
import CryptoSwift
import AFNetworking

class WelcomeController: UIViewController,UITextFieldDelegate {
    
    var cancelAction: UIAlertAction?

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
            emptyAlertController.addAction(self.cancelAction!)
        }
        
        else if !isValidEmail(emailTF.text!) {
            let invalidEmailAlertController = UIAlertController(title: "请输入正确的邮箱。", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            self.presentViewController(invalidEmailAlertController, animated: true, completion: nil)
            invalidEmailAlertController.addAction(self.cancelAction!)
        }
        else {
            
            let passwordAlertController = UIAlertController(title: "密码验证", message: "请重新输入密码以完成注册。", preferredStyle: UIAlertControllerStyle.Alert)
            passwordAlertController.addAction(self.cancelAction!)
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
        self.cancelAction = UIAlertAction(title: "取消", style: .Cancel) { action -> Void in
            self.unmatchedLB.hidden = true
        }
        
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
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    func login() {
        let cancelAction = UIAlertAction(title: "确定", style: .Cancel, handler:nil)
        
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

        let timeStamp = Tools.getNormalTime(NSDate())
        let stringHash = "\(emailTF.text!)\(passwordTF.text!)\(timeStamp)\(UUID)\(DEVICE_TOKEN!)\(COMPANYCODE)"
        let hashResult = stringHash.sha256()
        
        let url:NSString = LoginUrl+"?userID=\(emailTF.text!)&userPWD=\(passwordTF.text!)&lastLogin=\(timeStamp)&DeviceUUID=\(UUID)&DeviceToken=\(DEVICE_TOKEN!)&HashValue=\(hashResult)"
        let urlComplete = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        
        AFNetworkTools.getMethod(urlComplete!, success: { (task, response) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                print(response)
                let dict = response as! NSDictionary
                let getResult = UserCacheTool().getUserInfo(dict["UserIndex"] as! Int)
                if(getResult.inDB){
                    UserCacheTool().updateUserInfo(dict)
                }else{
                    SharedUser.changeValue(dict as! [String : AnyObject])
                    UserCacheTool().addUserInfoByUser(SHARED_USER)
                }
                NSUserDefaults.standardUserDefaults().setValue(SHARED_USER.UserIndex, forKey: "Logined")
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                    let nVC = storyBoard.instantiateViewControllerWithIdentifier("NavController") as! UINavigationController
                    self.presentViewController(nVC, animated: true, completion: { () -> Void in
                    })
                })
            })
            },failure: { (task, error) -> Void in
                let opera = task?.response as! NSHTTPURLResponse
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    switch opera.statusCode{
                    case 401:
                        self.unmatchedLB.hidden = false
                        self.unmatchedLB.text = "用户名或密码错误"
                    case 404:
                        self.unmatchedLB.hidden = false
                        self.unmatchedLB.text = "用户不存在"
                    default:
                        break
                    }
                })
                
        })
       

    }
}
