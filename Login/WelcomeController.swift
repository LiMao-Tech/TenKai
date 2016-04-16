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
    var okAction : UIAlertAction?
    var loading:TenLoadingView?
    //忘记密码
    @IBAction func forgetPassword(sender: AnyObject) {
        okAction = UIAlertAction(title: "确定", style: .Cancel, handler: nil)
        if(emailTF.text!.isEmpty){
            let emptyAlertController = UIAlertController(title: "请输入邮箱", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            self.presentViewController(emptyAlertController, animated: true, completion: nil)
            emptyAlertController.addAction(self.okAction!)
        }else if(!isValidEmail(emailTF.text!)){
            //TODO:发送回邮箱的请求
            let emptyAlertController = UIAlertController(title: "请输入正确的邮箱", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            self.presentViewController(emptyAlertController, animated: true, completion: nil)
            emptyAlertController.addAction(self.okAction!)
        }else{
            let url = Url_BundInfo + "?email=\(emailTF.text!)"
            let charSet = NSCharacterSet(charactersInString: url)
            let urlNew = url.stringByAddingPercentEncodingWithAllowedCharacters(charSet)
            AFJSONManager.SharedInstance.getMethod(urlNew!, success: { (task, response) in
                    let emptyAlertController = UIAlertController(title: "已将找回密码连接发送至邮箱，请注意查收", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                    self.presentViewController(emptyAlertController, animated: true, completion: nil)
                    emptyAlertController.addAction(self.okAction!)
                }, failure: { (task, error) in
                    let opera = task?.response as! NSHTTPURLResponse
                    switch opera.statusCode {
                    case 403:
                        self.unmatchedLB.textColor = UIColor.redColor()
                        self.unmatchedLB.text = "您的帐号没有绑定相关邮箱"
                    case 404:
                        self.unmatchedLB.textColor = UIColor.redColor()
                        self.unmatchedLB.text = "用户不存在"
                    default:
                        break
                    }
            })
            
        }
        
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
                textField.secureTextEntry = true
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
        
        UserChatModel.removeAll()
        
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
        if(DEVICE_TOKEN == nil){
            return
        }
        let cancelAction = UIAlertAction(title: "确定", style: .Cancel) { (ac) -> Void in
            self.loginBtn.enabled = true
        }
        loginBtn.enabled = false
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
        if(loading == nil){
            loading = TenLoadingView()
            loading?.loadingTitle = "登录中..."
        }
        self.view.addSubview(loading!)
        AFJSONManager.SharedInstance.getMethod(urlComplete!, success: { (task, response) -> Void in
            
            let dict = response as! [String : AnyObject]
            print(dict)
            SHARED_USER.ValueWithDict(dict)
            print(Tools.getSinceTime(NSDate()))
            self.getRaterUserIndexs()
        },
        failure: { (task, error) -> Void in
            self.loginBtn.enabled = true
            self.loading?.removeFromSuperview()
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
            self.getPinCode()
            },failure: { (task, error) -> Void in
                print("get raterIndex failed")
                print(error.localizedDescription)
                self.loginBtn.enabled = true
                self.loading?.removeFromSuperview()
                self.unmatchedLB.textColor = UIColor.redColor()
                self.unmatchedLB.text = "网络异常请重新登陆"
        })
    }
    
    func getPinCode(){
        let url = Url_Pin+"?userIndex=\(SHARED_USER.UserIndex)"
        let charSet = NSCharacterSet(charactersInString: url)
        let newUrl = url.stringByAddingPercentEncodingWithAllowedCharacters(charSet)
        AFJSONManager.SharedInstance.getMethod(newUrl!, success: { (task, response) in
            print(response)
            let pinDict = response as! NSDictionary
            SHARED_USER.GesturePin = pinDict["GesturePin"] as! String
            SHARED_USER.DevicePin = pinDict["DevicePin"] as! Int
            UserCacheTool().updateUserPinCode()
            UserCacheTool().updateUserPassCode()
            self.getMsgIndex()
            },failure:  { (task, error) in
                print("get pinCode failed")
                print(error.localizedDescription)
                self.loginBtn.enabled = true
                self.loading?.removeFromSuperview()
                self.unmatchedLB.textColor = UIColor.redColor()
                self.unmatchedLB.text = "网络异常请重新登陆"
        })
    }
    
    func getMsgIndex(){
        let url = Url_Api+"TenMsgs?userIndex=\(SHARED_USER.UserIndex)"
        let charSet = NSCharacterSet(charactersInString: url)
        let newUrl = url.stringByAddingPercentEncodingWithAllowedCharacters(charSet)
        
        let mana = AFHTTPSessionManager()
        mana.requestSerializer = AFHTTPRequestSerializer()
        mana.responseSerializer = AFHTTPResponseSerializer()
        
        mana.GET(newUrl!, parameters: nil, progress: nil, success: { (task, response) -> Void in
            let index = response as! NSData
            SHARED_USER.MsgIndex = Int(String.init(data: index, encoding: NSUTF8StringEncoding)!)!
            print(SHARED_USER.MsgIndex)
            let getResult = UserCacheTool().isUserInDB(SHARED_USER.UserIndex)
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
                NSUserDefaults.standardUserDefaults().setValue(self.emailTF.text!, forKey: "LoginEmail")
                print("avg:\(SHARED_USER.AVG)")
                self.loginBtn.enabled = true
                self.loading?.removeFromSuperview()
                let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                let nVC = storyBoard.instantiateViewControllerWithIdentifier("NavController") as! UINavigationController
                self.presentViewController(nVC, animated: true, completion: nil)
            })

            }, failure: { (task, error) -> Void in
                print("get msgIndex failed")
                print(error.localizedDescription)
                print("-------------")
                self.loginBtn.enabled = true
                self.loading?.removeFromSuperview()
                self.unmatchedLB.textColor = UIColor.redColor()
                self.unmatchedLB.text = "网络异常请重新登陆"
            })
        }
}
