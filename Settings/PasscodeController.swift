//
//  PasscodeController.swift
//  Ten
//
//  Created by gt on 15/12/4.
//  Copyright © 2015年 LiMao Tech. All rights reserved.
//

import UIKit
enum passcodeType : Int{
    case Set,Reset,Unlock
}

class PasscodeController: UIViewController,LockViewDelegate {
    
    var passcodeModel:passcodeType = .Unlock
    var times  = 0
    var passcode = 0
    var titleLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    
    func setup(){
        let lock = LockView(frame: CGRectMake(0,64,SCREEN_WIDTH,SCREEN_HEIGHT-64))
        lock.delegate = self
        self.view.addSubview(lock)
        titleLabel = UILabel(frame: CGRectMake(0,0,SCREEN_WIDTH,40))
        titleLabel.textAlignment = .Center
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont.systemFontOfSize(17)
        if(passcodeModel == .Set){
            titleLabel.text = "设置滑动解锁"
        }else if(passcodeModel == .Reset){
            titleLabel.text = "重置滑动解锁"
        }else{
            titleLabel.text = "滑动解锁"
        }
        
        self.view.backgroundColor = COLOR_BG
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func lockView(lockView: LockView!, didFinish path: String!) {
        let passcodeTemp = Int(path)
        if(passcodeModel == .Unlock){
            if (passcodeTemp == NSUserDefaults.standardUserDefaults().valueForKey("passcode") as? Int){
                //TODO: 解锁成功
            }
        }else if(passcodeModel == .Set){
            if(times == 0){
                passcode = passcodeTemp!
                titleLabel.text = "确认滑动解锁"
            }else{
                if(passcode == passcodeTemp){
                    NSUserDefaults.standardUserDefaults().setValue(passcode, forKey: "passcode")
                    let successAlert = UIAlertController(title: "PIN设置成功", message: nil, preferredStyle: .Alert)
                    let okAction = UIAlertAction(title: "确定", style: .Cancel, handler:nil)
                    successAlert.addAction(okAction)
                    self.presentViewController(successAlert, animated: true, completion: nil)
                }else{
                    let failAlert = UIAlertController(title: "两次输入的密码不一致，请重新设置", message: nil, preferredStyle: .Alert)
                    let okAction = UIAlertAction(title: "确定", style: .Cancel, handler: nil)
                    failAlert.addAction(okAction)
                    self.presentViewController(failAlert, animated: true, completion: nil)

                }
            }
        }else{
            if(passcodeTemp == NSUserDefaults.standardUserDefaults().valueForKey("passcode") as? Int){
                passcodeModel = .Set
                titleLabel.text = "设置滑动解锁"
            }else{
                let failAlert = UIAlertController(title: "请正确滑动解锁", message: nil, preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "确定", style: .Cancel, handler: nil)
                failAlert.addAction(okAction)
                self.presentViewController(failAlert, animated: true, completion: nil)
            }
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
