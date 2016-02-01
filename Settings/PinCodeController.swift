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

class PinCodeController: UIViewController {
    
    var textLabel = UILabel(frame: CGRectMake(0,64,SCREEN_WIDTH,40))
    var lightView:UIView!
    var dotOn:UIImageView!
    var dotTw:UIImageView!
    var dotTh:UIImageView!
    var dotFo:UIImageView!
    var pinCodes = [Int]()
    var pin = 0
    var times = 0
    var pinModel = PinCodeMode.Set
    var count = 0{
        didSet{
            light(count)
        }
    }
    var numberView:UIView!
    
    var deleteBtn:UIButton!
   
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
        textLabel.textColor = UIColor.whiteColor()
        textLabel.textAlignment = .Center
        self.view.addSubview(textLabel)
        textLabel.font = UIFont.systemFontOfSize(15)
        if(NSUserDefaults.standardUserDefaults().valueForKey("PinCode") == nil){
            textLabel.text = "设置PIN"
        }else{
            textLabel.text = "重置PIN"
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
        deleteBtn.addTarget(self, action: "deleteBtnClick", forControlEvents: .TouchUpInside)
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
        let x:CGFloat = 30
        let y:CGFloat = 20
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
            numberBtn.addTarget(self, action: "numberClick:", forControlEvents: UIControlEvents.TouchUpInside)
            self.numberView.addSubview(numberBtn)
        }
        
        let numberBtn = UIButton(frame: CGRectMake(x+marginw+iconw, y + 3*(marginh+iconh), iconw, iconh))
        numberBtn.tag = 0
        numberBtn.setImage(UIImage(named: "icon0"), forState: .Normal)
        numberBtn.setImage(UIImage(named: "icon0_click"), forState: .Highlighted)
        numberBtn.addTarget(self, action: "numberClick:", forControlEvents: UIControlEvents.TouchUpInside)
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
            var pinTemp = 0
            for num in pinCodes{
                pinTemp += num
            }
            if(pinModel == .Unlock){
                if( pin == NSUserDefaults.standardUserDefaults().valueForKey("PinCode") as! Int){
                    //解锁成功，回到主界面
                }else{
                    //解锁失败
                    let failedAction = UIAlertController(title: "解锁失败，请重新尝试", message:nil , preferredStyle: .Alert)
                    let okAction = UIAlertAction(title: "确定", style: .Cancel, handler: { (ac) -> Void in
                        self.count = 0
                        self.pinCodes.removeAll()
                    })
                    failedAction.addAction(okAction)
                }
            }
            else if(pinModel == .ReSet){
                if( pin == NSUserDefaults.standardUserDefaults().valueForKey("PinCode") as! Int){
                    pinModel = .Set
                }else{
                    //解锁失败
                    let failedAction = UIAlertController(title: "请输入正确的PIN", message:nil , preferredStyle: .Alert)
                    let okAction = UIAlertAction(title: "确定", style: .Cancel, handler: { (ac) -> Void in
                        self.count = 0
                        self.pinCodes.removeAll()
                    })
                    failedAction.addAction(okAction)
                }
            }
            else{
                if(times == 0){
                    let time: NSTimeInterval = 0.5
                    let delay = dispatch_time(DISPATCH_TIME_NOW,
                        Int64(time * Double(NSEC_PER_SEC)))
                    dispatch_after(delay, dispatch_get_main_queue()) {
                        self.times = 1
                        self.pin = pinTemp
                        self.textLabel.text = "确认PIN"
                        self.count = 0
                        self.pinCodes.removeAll()
                    }
                }else{
                    if(pin == pinTemp){
                        NSUserDefaults.standardUserDefaults().setValue(pin, forKey: "PinCode")
                        self.navigationController?.popViewControllerAnimated(true)
                    }else{
                        let failAlert = UIAlertController(title: "两次输入的密码不一致，请重新设置", message: nil, preferredStyle: .Alert)
                        let okAction = UIAlertAction(title: "确定", style: .Cancel, handler: { (ac) -> Void in
                            let time: NSTimeInterval = 0.5
                            let delay = dispatch_time(DISPATCH_TIME_NOW,
                                Int64(time * Double(NSEC_PER_SEC)))
                            dispatch_after(delay, dispatch_get_main_queue()) {
                                self.times = 0
                                self.count = 0
                                self.pinCodes.removeAll()
                                self.pin = 0
                                self.textLabel.text = "设置PIN"
                            }
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
