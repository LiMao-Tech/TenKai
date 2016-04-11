//
//  SettingsViewController.swift
//  Ten
//
//  Created by gt on 15/10/12.
//  Copyright © 2015年 LiMao Tech. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var loading = TenLoadingView()
    var settingList:UITableView!
    var logoutBtn:UIButton!
    let itemNames = ["个人信息","滑动解锁","更改PIN","P   币","","服务条款","隐私声明"]
    var remainingPinEntries = 3
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = SettingTitle
        self.view.backgroundColor = COLOR_BG
        settingList = UITableView(frame: CGRectMake(30, 30, SCREEN_WIDTH - 60, 400))
        settingList.dataSource = self
        settingList.delegate = self
        settingList.separatorStyle = .None
        settingList.bounces = false
        settingList.backgroundColor = UIColor.clearColor()
        
        let w:CGFloat = 215
        let h:CGFloat = 37
        let x = (SCREEN_WIDTH - w)/2
        let y = CGRectGetMaxY(settingList.frame) + (SCREEN_HEIGHT - CGRectGetMaxY(settingList.frame) - h)/2
        logoutBtn = UIButton(frame: CGRectMake(x, y, w, h))
        logoutBtn.setImage(UIImage(named: "btn_logout"), forState: .Normal)
        logoutBtn.addTarget(self, action: #selector(SettingsViewController.logout), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(settingList)
        self.view.addSubview(logoutBtn)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:settingCell!
        if(indexPath.row != 4){
            cell = settingList.dequeueReusableCellWithIdentifier("settingCell") as? settingCell
            if(cell == nil){
                cell = settingCell.init(style: .Default, reuseIdentifier: "settingCell")
            }
            cell?.itemLabel.text = itemNames[indexPath.row]
        }
        else{
            let cell = SettingDoubleLabelCell.init(style: .Default, reuseIdentifier: "settingDoubelCell")
            return cell
        }
        
        return cell!
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.row == 4){
            return 60
        }
        return 40
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemNames.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.row == 0){
            let epVC = EditProfileController()
            self.navigationController?.pushViewController(epVC, animated: true)
            settingList.deselectRowAtIndexPath(indexPath, animated: true)
        }
        else if(indexPath.row == 1){
            let pcVC = PasscodeController()
            pcVC.passcodeModel = .Reset
            self.navigationController?.pushViewController(pcVC, animated: true)
            settingList.deselectRowAtIndexPath(indexPath, animated: true)
        }
        else if (indexPath.row == 2){
            let pVC = PinCodeController()
            self.navigationController?.pushViewController(pVC, animated: true)
            settingList.deselectRowAtIndexPath(indexPath, animated: true)
        }
        else if(indexPath.row == 3){
            let pVC = PCoinViewController()
            self.navigationController?.pushViewController(pVC, animated: true)
            settingList.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    
    func logout(){
        loading.loadingTitle = "登出中..."
        self.view.addSubview(loading)
        let url = Url_Login+"?userIndex=\(SHARED_USER.UserIndex)"
        let charSet = NSCharacterSet(charactersInString: url)
        let urlNew = url.stringByAddingPercentEncodingWithAllowedCharacters(charSet)
        AFJSONManager.SharedInstance.postMethod(urlNew!, parameters: nil, success: { (task, response) in
            NSUserDefaults.standardUserDefaults().removeObjectForKey("Logined")
            NSUserDefaults.standardUserDefaults().removeObjectForKey("LoginEmail")
            NSOperationQueue.mainQueue().addOperationWithBlock({
                self.loading.removeFromSuperview()
                let wVC = WelcomeController()
                UserChatModel.removeAll()
                self.presentViewController(wVC, animated: true, completion: nil)
            })
            
            },failure:  { (task, error) in
                let opera = task?.response as! NSHTTPURLResponse
                if(opera.statusCode == 403){
                    NSUserDefaults.standardUserDefaults().removeObjectForKey("Logined")
                    NSUserDefaults.standardUserDefaults().removeObjectForKey("LoginEmail")
                    NSOperationQueue.mainQueue().addOperationWithBlock({
                        self.loading.removeFromSuperview()
                        let wVC = WelcomeController()
                        UserChatModel.removeAll()
                        self.presentViewController(wVC, animated: true, completion: nil)
                    })
                }
                print("log out failed")
                print(error.localizedDescription)
        })
        NSUserDefaults.standardUserDefaults().removeObjectForKey("Logined")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("LoginEmail")
        NSOperationQueue.mainQueue().addOperationWithBlock({
            self.loading.removeFromSuperview()
            let wVC = WelcomeController()
            UserChatModel.removeAll()
            self.presentViewController(wVC, animated: true, completion: nil)
        })

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