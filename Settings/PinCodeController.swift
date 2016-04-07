//
//  PinCodeController.swift
//  Ten
//
//  Created by gt on 16/2/1.
//  Copyright © 2016年 LiMao Tech. All rights reserved.
//

import UIKit

enum PinCodeMode:Int{
    case Set,ReSet,Unlock
}

protocol TenPinCodeDelegate:class {
    func PinCodeDidSet(pVC:PinCodeController)
}

class PinCodeController: UIViewController {
    
    var textLabel = UILabel(frame: CGRectMake(0,64,SCREEN_WIDTH,40))
    var lightView:UIView!
    var dotOn:UIImageView!
    var dotTw:UIImageView!
    var dotTh:UIImageView!
    var dotFo:UIImageView!
    var pinCodes = [Int]()
    var pin = 0
    var pinTemp = 0
    var times = 0
    var pinModel = PinCodeMode.ReSet
    var count = 0{
        didSet{
            light(count)
        }
    }
    var numberView:UIView!
    
    var deleteBtn:UIButton!
    
    var firstSet = false
    
    weak var delegate:TenPinCodeDelegate?
    
    let successAlert = UIAlertController(title: "设置成功", message: nil, preferredStyle: .Alert)
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUp(){
        let okAction = UIAlertAction(title: "确定", style: .Cancel, handler:{ (ac) -> Void in
            self.delegate?.PinCodeDidSet(self)
        })
        successAlert.addAction(okAction)
        
        textLabel.textColor = UIColor.whiteColor()
        textLabel.textAlignment = .Center
        textLabel.font = UIFont.systemFontOfSize(17)
        self.view.addSubview(textLabel)
        textLabel.font = UIFont.systemFontOfSize(15)
        if(SHARED_USER.DevicePin == 0){
            textLabel.text = "设置PIN"
            pinModel = .Set
        }else{
            textLabel.text = "重置PIN"
            print("pin is:")
            print(NSUserDefaults.standardUserDefaults().valueForKey("PinCode"))
        }
        lightView = UIView(frame: CGRectMake(0,0,180,40))
        lightView.center = CGPointMake(SCREEN_WIDTH/2, 120)
        lightView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(lightView)
        let len:CGFloat = 12
        let y:CGFloat = 14
        let margin = (180 - len*4)/5
        dotOn = UIImageView(frame: CGRectMake(margin,y,len,len))
        dotOn.image = UIImage(named: "icon_passcode_circle")
        lightView.addSubview(dotOn)
        dotTw = UIImageView(frame: CGRectMake(margin*2 + len,y,len,len))
        dotTw.image = UIImage(named: "icon_passcode_circle")
        lightView.addSubview(dotTw)
        dotTh = UIImageView(frame: CGRectMake(margin*3 + len*2,y,len,len))
        dotTh.image = UIImage(named: "icon_passcode_circle")
        lightView.addSubview(dotTh)
        dotFo = UIImageView(frame: CGRectMake(margin*4 + len*3,y,len,len))
        dotFo.image = UIImage(named: "icon_passcode_circle")
        lightView.addSubview(dotFo)
        
        deleteBtn = UIButton(frame: CGRectMake(SCREEN_WIDTH-80,SCREEN_HEIGHT-50,80,50))
        deleteBtn.setTitle("删  除", forState: .Normal)
        deleteBtn.addTarget(self, action: #selector(PinCodeController.deleteBtnClick), forControlEvents: .TouchUpInside)
        self.view.addSubview(deleteBtn)
        self.view.addSubview(lightView)
        
        let h = SCREEN_HEIGHT-190
        numberView = UIView(frame: CGRectMake(0,160,SCREEN_WIDTH,h))
        numberView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(numberView)
        self.view.backgroundColor = COLOR_BG
        setupButtons()
    }
    
    func setupButtons(){
        let x:CGFloat = SCREEN_WIDTH*0.1
        let y:CGFloat = SCREEN_HEIGHT*0.03
        let iconw:CGFloat = 70
        let iconh:CGFloat = 70
        let marginw:CGFloat = (SCREEN_WIDTH - iconw*3 - x*2)/2
        let marginh:CGFloat = 20
        for i in 1...9{
            let row = (i-1)/3
            let col = (i-1)%3
            
            let numberBtn = UIButton(frame: CGRectMake(x + CGFloat(col)*(marginw+iconw), y + CGFloat(row)*(marginh+iconh), iconw, iconh))
            numberBtn.setImage(UIImage(named: "icon\(i)"), forState: .Normal)
            numberBtn.setImage(UIImage(named: "icon\(i)_click"), forState: .Highlighted)
            numberBtn.tag = i
            numberBtn.addTarget(self, action: #selector(PinCodeController.numberClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            self.numberView.addSubview(numberBtn)
        }
        
        let numberBtn = UIButton(frame: CGRectMake(x+marginw+iconw, y + 3*(marginh+iconh), iconw, iconh))
        numberBtn.tag = 0
        numberBtn.setImage(UIImage(named: "icon0"), forState: .Normal)
        numberBtn.setImage(UIImage(named: "icon0_click"), forState: .Highlighted)
        numberBtn.addTarget(self, action: #selector(PinCodeController.numberClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.numberView.addSubview(numberBtn)
    }
    
    func deleteBtnClick(){
        if(count > 0){
            print("delete...")
            count = count - 1
            pinCodes.removeLast()
        }
    }
    
    func numberClick(sender:UIButton){
        if(count < 4){
            count += 1
            pinCodes.append(sender.tag)
        }
        if(count == 4){
            for num in pinCodes{
                pinTemp = num + pinTemp*10
            }
            print("pinTemp:")
            print(pinTemp)
            if(pinModel == .Unlock){
                if( pinTemp == SHARED_USER.DevicePin){
                    //解锁成功，回到主界面
                    pinTemp = 0
                }else{
                    //解锁失败
                    let failedAction = UIAlertController(title: "解锁失败，请重新尝试", message:nil , preferredStyle: .Alert)
                    let okAction = UIAlertAction(title: "确定", style: .Cancel, handler: { (ac) -> Void in
                        self.pinStateReset(nil)
                    })
                    failedAction.addAction(okAction)
                }
            }
            else if(pinModel == .ReSet){
                if( pinTemp == SHARED_USER.DevicePin){
                    pinModel = .Set
                    self.textLabel.text = "设置PIN"
                    self.pinTemp = 0
                    self.count = 0
                    self.pinCodes.removeAll()
                    
                }else{
                    //解锁失败
                    let failedAlert = UIAlertController(title: "请输入正确的PIN", message:nil , preferredStyle: .Alert)
                    let okAction = UIAlertAction(title: "确定", style: .Cancel, handler: { (ac) -> Void in
                        self.pinStateReset("重置PIN")
                    })
                    failedAlert.addAction(okAction)
                    self.presentViewController(failedAlert, animated: true, completion: nil)
                }
            }
            else{
                if(times == 0){
                    self.times = 1
                    self.pin = self.pinTemp
                    self.count = 0
                    self.pinTemp = 0
                    let time: NSTimeInterval = 0.2
                    let delay = dispatch_time(DISPATCH_TIME_NOW,
                        Int64(time * Double(NSEC_PER_SEC)))
                    dispatch_after(delay, dispatch_get_main_queue()) {
                        self.textLabel.text = "确认PIN"
                        self.pinCodes.removeAll()
                    }
                }else{
                    if(pin == pinTemp){
                        //保存pin并上传
                        if(firstSet){
                            let params = ["UserIndex": SHARED_USER.UserIndex,
                                          "DevicePin": pin,
                                          "GesturePin": SHARED_USER.GesturePin]
                            AFJSONManager.SharedInstance.postMethod(Url_Pin, parameters:params as? [String : AnyObject] , success: { (task, response) in
                                    SHARED_USER.DevicePin = self.pin
                                    UserCacheTool().updateUserPassCode()
                                    UserCacheTool().updateUserPinCode()
                                    self.presentViewController(self.successAlert, animated: true, completion: nil)
                                }, failure: { (task, error) in
                                    let failedAlert = UIAlertController(title: "设置失败，请重新尝试！", message: nil, preferredStyle: .Alert)
                                    let okAction = UIAlertAction(title: "确定", style: .Cancel, handler: {(ac) -> Void in
                                        self.pinStateReset(nil)
                                    })
                                    failedAlert.addAction(okAction)
                                    self.presentViewController(failedAlert, animated: true, completion: nil)
                            })
                        }else{
                            let url = Url_Pin+"?userIndex=\(SHARED_USER.UserIndex)&devicePin=\(pin)&gesturePin=-1"
                            let charSet = NSCharacterSet(charactersInString: url)
                            let urlNew = url.stringByAddingPercentEncodingWithAllowedCharacters(charSet)
                            AFJSONManager.SharedInstance.putMethod(urlNew!, success: { (task, reponse) in
                                SHARED_USER.DevicePin = self.pin
                                UserCacheTool().updateUserPinCode()
                                let putSuccessAlert = UIAlertController(title: "设置成功", message: nil, preferredStyle: .Alert)
                                let okAction = UIAlertAction(title: "确定", style: .Cancel, handler: {(ac) -> Void in
                                    self.pinStateReset("重置PIN")
                                    self.pinModel = .ReSet
                                })
                                putSuccessAlert.addAction(okAction)
                                self.presentViewController(putSuccessAlert, animated: true, completion: nil)
                                }, failure: { (task, error) in
                                    let failedAlert = UIAlertController(title: "设置失败，请重新尝试！", message: nil, preferredStyle: .Alert)
                                    let okAction = UIAlertAction(title: "确定", style: .Cancel, handler: { (ac) -> Void in
                                        self.pinStateReset(nil)
                                    })
                                    failedAlert.addAction(okAction)
                                    self.presentViewController(failedAlert, animated: true, completion: nil)
                            })
                        }
                    }else{
                        let failAlert = UIAlertController(title: "两次输入的密码不一致，请重新设置", message: nil, preferredStyle: .Alert)
                        let okAction = UIAlertAction(title: "确定", style: .Cancel, handler: { (ac) -> Void in
                            self.pinStateReset(nil)
                        })
                        failAlert.addAction(okAction)
                        self.presentViewController(failAlert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func light(count:Int){
        switch count{
        case 1:
            dotOn.image = UIImage(named: "icon_chat_dot_l1")
            dotTw.image = UIImage(named: "icon_passcode_circle")
            dotTh.image = UIImage(named: "icon_passcode_circle")
            dotFo.image = UIImage(named: "icon_passcode_circle")
            break
        case 2:
            dotOn.image = UIImage(named: "icon_chat_dot_l1")
            dotTw.image = UIImage(named: "icon_chat_dot_l1")
            dotTh.image = UIImage(named: "icon_passcode_circle")
            dotFo.image = UIImage(named: "icon_passcode_circle")
            break
        case 3:
            dotOn.image = UIImage(named: "icon_chat_dot_l1")
            dotTw.image = UIImage(named: "icon_chat_dot_l1")
            dotTh.image = UIImage(named: "icon_chat_dot_l1")
            dotFo.image = UIImage(named: "icon_passcode_circle")
            break
        case 4:
            dotOn.image = UIImage(named: "icon_chat_dot_l1")
            dotTw.image = UIImage(named: "icon_chat_dot_l1")
            dotTh.image = UIImage(named: "icon_chat_dot_l1")
            dotFo.image = UIImage(named: "icon_chat_dot_l1")
            break
        default:
            dotOn.image = UIImage(named: "icon_passcode_circle")
            dotTw.image = UIImage(named: "icon_passcode_circle")
            dotTh.image = UIImage(named: "icon_passcode_circle")
            dotFo.image = UIImage(named: "icon_passcode_circle")
            break
            
        }
    }
    
    func pinStateReset(title:String?){
        self.times = 0
        self.count = 0
        self.pinTemp=0
        self.pin = 0
        let time: NSTimeInterval = 0.2
        let delay = dispatch_time(DISPATCH_TIME_NOW,Int64(time * Double(NSEC_PER_SEC)))
        dispatch_after(delay, dispatch_get_main_queue()) {
            if(title == nil){
                self.textLabel.text = "设置PIN"
            }else{
                self.textLabel.text = title!
            }
            
            self.pinCodes.removeAll()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
