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
    //忘记密码
    @IBAction func forgetPassword(sender: AnyObject) {
        print("forgotPassword")
    }
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
                self.unmatchedLB.textColor = UIColor.redColor()
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
    
    init() {
        super.init(nibName: "WelcomeController", bundle: NSBundle.mainBundle())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.unmatchedLB.textColor = COLOR_BG
        self.cancelAction = UIAlertAction(title: "取消", style: .Cancel) { action -> Void in
            self.unmatchedLB.textColor = COLOR_BG
        }
        
        self.view.backgroundColor = COLOR_BG
        
        emailTF.textColor = UIColor.whiteColor()
        emailTF.backgroundColor = UIColor.blackColor()
        emailTF.delegate = self
        emailTF.returnKeyType = .Done
        emailTF.setValue(COLOR_WHITEGRAY, forKeyPath: "_placeholderLabel.textColor")
        
        passwordTF.textColor = UIColor.whiteColor()
        passwordTF.backgroundColor = UIColor.blackColor()
        passwordTF.delegate = self
        passwordTF.returnKeyType = .Done
        passwordTF.setValue(COLOR_WHITEGRAY, forKeyPath: "_placeholderLabel.textColor")
        
        splitView = UIView(frame: CGRectMake(0,63,SCREEN_WIDTH,1))
        splitView.backgroundColor = UIColor.whiteColor()
        splitView.alpha = 0.6
        self.view.addSubview(splitView)
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
        
        let url:NSString = Url_Login+"?userID=\(emailTF.text!)&userPWD=\(passwordTF.text!)&lastLogin=\(timeStamp)&DeviceUUID=\(UUID)&DeviceToken=\(DEVICE_TOKEN!)&HashValue=\(hashResult)"
        let urlComplete = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        
        AFJSONManager.SharedInstance.getMethod(urlComplete!, success: { (task, response) -> Void in
            print(response)
            let dict = response as! NSDictionary
            SHARED_USER.ValueWithDict(dict as! [String : AnyObject])
            self.getRaterUserIndexs()
        },
        failure: { (task, error) -> Void in
            let opera = task?.response as! NSHTTPURLResponse
            switch opera.statusCode {
                case 401:
                    self.unmatchedLB.textColor = UIColor.redColor()
                    self.unmatchedLB.text = "用户名或密码错误"
                case 404:
                    self.unmatchedLB.textColor = UIColor.redColor()
                    self.unmatchedLB.text = "用户不存在"
                default:
                    break
            }
        })
    }
    
    func getRaterUserIndexs(){
        AFJSONManager.SharedInstance.getMethodWithParams(Url_Rater, parameters: ["raterIndex":SHARED_USER.UserIndex], success: { (task, response) -> Void in
            let raters = response as! NSDictionary
            let innerRaters = raters["Inner"] as! [Int]
            let outerRaters = raters["Outer"] as! [Int]
            UserRaterCache().removeAllRater()
            print(raters)
            if(innerRaters.count > 0){
                SHARED_CHATS.raterIndex = innerRaters
                UserRaterCache().addUserRaterByArray(innerRaters,type: 0)
            }
            if(outerRaters.count > 0){
                SHARED_CHATS.outerRaterIndex = outerRaters
                UserRaterCache().addUserRaterByArray(outerRaters, type: 1)
            }
            self.getMsgIndex()
            },failure: { (task, error) -> Void in
                print("get raterIndex failed")
                print(error.localizedDescription)
                self.unmatchedLB.textColor = UIColor.redColor()
                self.unmatchedLB.text = "网络异常请重新登陆"
        })
    }
    
    func getMsgIndex(){
        let url = Url_Api+"TenMsgs?userIndex=\(SHARED_USER.UserIndex)"
        let newUrl = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        
        let mana = AFHTTPSessionManager()
        mana.requestSerializer = AFHTTPRequestSerializer()
        mana.responseSerializer = AFHTTPResponseSerializer()
        
        mana.GET(newUrl!, parameters: nil, progress: nil, success: { (task, response) -> Void in
            let index = response as! NSData
            SHARED_USER.MsgIndex = Int(String.init(data: index, encoding: NSUTF8StringEncoding)!)!
            print(SHARED_USER.MsgIndex)
            let getResult = UserCacheTool().getUserInfo(SHARED_USER.UserIndex)
            if getResult {
                UserCacheTool().updateUserInfo()
            }
            else {
                UserCacheTool().addUserInfoByUser()
            }
            DataInitializerTool.initialiseInfo()
            //to mainVC
            NSUserDefaults.standardUserDefaults().setValue(SHARED_USER.UserIndex, forKey: "Logined")
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                let nVC = storyBoard.instantiateViewControllerWithIdentifier("NavController") as! UINavigationController
                self.presentViewController(nVC, animated: true, completion: nil)
            })

            }, failure: { (task, error) -> Void in
                print("get msgIndex failed")
                print(error.localizedDescription)
                print("-------------")
                self.unmatchedLB.textColor = UIColor.redColor()
                self.unmatchedLB.text = "网络异常请重新登陆"
            })
        }
}
