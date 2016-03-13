//
//  ViewController.swift
//  Ten
//
//  Created by Yumen Cao on 8/22/15.
//  Copyright (c) 2015 LiMao Tech. All rights reserved.
//

import UIKit
import QuartzCore
import CoreLocation
import SwiftyJSON


class MainViewController: UIViewController, ADCircularMenuDelegate {
    
    

    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    // buttons
    let menuButton = UIButton(frame: CGRectMake(5, SCREEN_HEIGHT*(BUTTON_DENO-1)/BUTTON_DENO-5, SCREEN_HEIGHT/BUTTON_DENO, SCREEN_HEIGHT/BUTTON_DENO))
    let randomButton = UIButton(frame: CGRectMake(SCREEN_WIDTH-SCREEN_HEIGHT/BUTTON_DENO-5, SCREEN_HEIGHT*(BUTTON_DENO-1)/BUTTON_DENO-5, SCREEN_HEIGHT/BUTTON_DENO, SCREEN_HEIGHT/BUTTON_DENO))
    let refreshBtn = UIButton(frame: CGRectMake(0,0,22.5,21))
    
    // circular menu
    let circularMenuVC = ADCircularMenuViewController(frame: UIScreen.mainScreen().bounds)
    
    var distanceLabel:UILabel!
    
    var btnArray = [LevelButton]()
    var distance : TenSlider!
    var gap : Int!
    
    var menuBtnImageHighlight = ["btn_menu_chat_not","btn_menu_notification_not"]
    
    let portraitBtn: UIButton = UIButton(frame: CGRectMake(0, 0, SCREEN_WIDTH/5, SCREEN_WIDTH/5))
    
    let distances = [50, 100, 500, 1000]
    var index = 0
    
    
    // view loading
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barStyle = .Black

        self.navigationController?.navigationBar.backgroundColor = COLOR_NAV_BAR
        self.view.backgroundColor = COLOR_BG
        print(SHARED_USER.UserIndex)
        
        SHARED_USER.addObserver(self, forKeyPath: "Average", options: .New, context: nil)
        

        ALAMO_MANAGER.request(.GET, SHARED_USER.ProfileUrl) .responseImage { response in
            if let image = response.result.value {
                SHARED_USER.Portrait = UIImagePNGRepresentation(image)
                self.portraitBtn.setImage(Tools.toCirclurImage(SHARED_USER.PortraitImage!), forState: .Normal)
                print("get Portrait")
                UserCacheTool().upDateUserPortrait()
            }
            else {
                print("get Portrait failed")
            }
        }

        //protraitBtn
        portraitBtn.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)
        if(SHARED_USER.PortraitImage == nil){
            portraitBtn.setImage(UIImage(named: "user_pic_radar_140")!, forState: .Normal)
        }else{
            portraitBtn.setImage(Tools.toCirclurImage(SHARED_USER.PortraitImage!), forState: .Normal)
        }
        portraitBtn.addTarget(self, action: "pushUserProfileVC", forControlEvents: .TouchUpInside)
        
        // set circularMenu
        self.circularMenuVC.circularMenuDelegate = self
        self.circularMenuVC.view.frame = UIScreen.mainScreen().bounds
        
        //distanceLabel
        distanceLabel = UILabel(frame: CGRectMake(0,80,SCREEN_WIDTH,20))
        distanceLabel.textColor = UIColor.whiteColor()
        distanceLabel.font = UIFont(name: FONTNAME_NORMAL, size: 16)
        distanceLabel.textAlignment = .Center

        //setupButtons
        setupButtons()
        refreshLevelButton()
        
        
        // add location observer
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "locationChanged:",
            name: LocationNotiName,
            object: nil)
    
        // config buttons
        menuButton.setImage(UIImage(named: "btn_menu"), forState: UIControlState.Normal)
        menuButton.addTarget(self, action: "menuButtonAction", forControlEvents: UIControlEvents.TouchUpInside)
        
        randomButton.setImage(UIImage(named: "btn_radar_random"), forState: UIControlState.Normal)
        randomButton.addTarget(self, action: "randomButtonAction", forControlEvents: UIControlEvents.TouchUpInside)
        
        let distanceY = CGRectGetMinY(menuButton.frame) - 80
        distance = TenSlider(frame: CGRectMake(45, distanceY, SCREEN_WIDTH - 90, 24))
        distance.minimumValue = 0
        distance.maximumValue = 3
        distance.addTarget(self, action: "distanceChange", forControlEvents: UIControlEvents.ValueChanged)
        
        let minus = UIButton(frame: CGRectMake(10,distanceY,24,24))
        minus.setImage(UIImage(named: "btn_radar_minus"), forState: .Normal)
        minus.addTarget(self, action: "minusClicked", forControlEvents: .TouchUpInside)
        
        let plus = UIButton(frame: CGRectMake(SCREEN_WIDTH - 34,distanceY,24,24))
        plus.setImage(UIImage(named: "btn_radar_plus"), forState: .Normal)
        plus.addTarget(self, action: "plusClicked", forControlEvents: .TouchUpInside)
        
        refreshBtn.center = CGPointMake(SCREEN_WIDTH/2,menuButton.center.y)
        refreshBtn.setImage(UIImage(named: "btn_radar_refresh"), forState: .Normal)
        refreshBtn.addTarget(self, action: "refreshBtnClicked", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(portraitBtn)
        self.view.addSubview(menuButton)
        self.view.addSubview(randomButton)
        self.view.addSubview(distance)
        self.view.addSubview(minus)
        self.view.addSubview(plus)
        self.view.addSubview(refreshBtn)
        self.view.addSubview(distanceLabel)
      
        distanceChange()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = true
        updateLocation()
        let chatBtn = circularMenuVC.arrButtons[5] as! UIButton
        if(unReadNum == 0){
            chatBtn.setImage(UIImage(named: "btn_menu_chat_normal"), forState: .Normal)
        }else{
            chatBtn.setImage(UIImage(named: "btn_menu_chat_not"), forState: .Normal)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    func generateNodes() {
        let gridButtons = TenMainGridManager.SharedInstance.createButtons(2)
        showBtns(gridButtons)
    }

    func generateNodesByGender(gender: Int) {
        TenMainGridManager.SharedInstance.clearNodes()
        TenMainGridManager.SharedInstance.numToGen = 25
        let gridButtons = TenMainGridManager.SharedInstance.createButtons(gender)
        showBtns(gridButtons)
        view.bringSubviewToFront(portraitBtn)
    }

    func toTargetUser(sender: TenGridButton) {
        let otherPVC = OtherProfileMasterViewController(nibName: "ProfileMasterViewController", bundle: nil)

        let tenUser = TenUser(dict: sender.tenUserDict)
        otherPVC.tenUser = tenUser
        otherPVC.userID = tenUser.UserIndex
        self.navigationController?.pushViewController(otherPVC, animated: true)
    }

    func minusClicked(){
        if(index > 0){
            index -= 1
            distance.setValue(Float(index), animated: true)
            distanceLabel.text = "\(distances[index]) m"
        }
    }
    
    func plusClicked(){
//        distance.value = distance.value + 200
        if(index < 3){
            index += 1
            distance.setValue(Float(index), animated: true)
            distanceLabel.text = "\(distances[index]) m"
        }
    }
    
    func distanceChange() {
        index = Int(distance.value+0.5)
        distance.setValue(Float(index), animated: true)
        distanceLabel.text = "\(distances[index]) m"
    }
    
    func refreshBtnClicked() {
        self.refreshBtn.enabled = false
        TenMainGridManager.SharedInstance.clearNodes()
        TenMainGridManager.SharedInstance.numToGen = 25
        
        generateNodes()
        view.bringSubviewToFront(portraitBtn)
        refreshBtn.enabled = true
    }
    
    
    func setupButtons(){
        let marginw:CGFloat = 30
        let marginh:CGFloat = 20
        let iconw:CGFloat = 58
        let iconh:CGFloat = 67
        let x = (SCREEN_WIDTH - iconw*3 - marginw*2)/2
        let y:CGFloat = 90
        
        for i in 1...9{
            let row = (i-1)/3
            let col = (i-1)%3
            
            let levelBtn = LevelButton(frame: CGRectMake(x + CGFloat(col)*(marginw+iconw), y + CGFloat(row)*(marginh+iconh), iconw, iconh))
            levelBtn.level = i
            levelBtn.addTarget(self, action: "levelSelect:", forControlEvents: UIControlEvents.TouchUpInside)
            self.circularMenuVC.view.addSubview(levelBtn)
            btnArray.append(levelBtn)
        }
        
      let lvtenBtn = LevelButton(frame: CGRectMake(x+marginw+iconw, y + 3*(marginh+iconh), iconw, iconh))
        lvtenBtn.level = 10
        lvtenBtn.addTarget(self, action: "levelSelect:", forControlEvents: UIControlEvents.TouchUpInside)
        self.circularMenuVC.view.addSubview(lvtenBtn)
        btnArray.append(lvtenBtn)
        
    }
    
    func refreshLevelButton(){
        let index = SHARED_USER.AVG
        for btn in btnArray{
            if(btn.level <= index){
                btn.lockState = .UnLock
            }else{
                btn.lockState = .Lock
            }
        }
    }
    
    // button actions
    func levelSelect(sender:LevelButton){
        if(sender.lockState == .Lock){
            let unlockAlert = UIAlertController(title: "等级解锁", message: "您需要花费 \(sender.level*10) P币来解锁该等级", preferredStyle: UIAlertControllerStyle.Alert)
            let ok = UIAlertAction(title: "解锁", style: UIAlertActionStyle.Destructive, handler: { (ac) -> Void in
                print("解锁")
                if(SHARED_USER.PCoin < Double(sender.level*10)){
                    //P币不足
                    print("P币不足")
                    let insufficientAlert = UIAlertController(title: "解锁失败", message: "P币数量不足，请充值后解锁", preferredStyle: .Alert)
                    let pay = UIAlertAction(title: "充值", style: .Destructive, handler: { (ac) -> Void in
                        let pVC = PCoinViewController()
                        self.navigationController?.navigationBar.hidden = false
                        self.navigationController?.pushViewController(pVC, animated: true)
                    })
                    let cancel = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
                    insufficientAlert.addAction(pay)
                    insufficientAlert.addAction(cancel)
                    self.presentViewController(insufficientAlert, animated: true, completion: nil)
                }else{
                    //同步服务器数据，获得相应的等级
                    let url = Url_User + "/\(SHARED_USER.UserIndex)?pcoin=\(sender.level*10)&level=\(sender.level)"
                    let urlComplete = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
                    AFJSONManager.SharedInstance.putMethod(urlComplete!, success: { (task, response) -> Void in
                        let info = response as! NSDictionary
                        SHARED_USER.Expire = info["Expire"] as! Int
                        SHARED_USER.AVG = info["AVG"] as! Int
                        SHARED_USER.PCoin -= Double(sender.level*10)
                        print(SHARED_USER.AVG)
                        self.refreshLevelButton()
                        UserCacheTool().updateUserInfo()
                        let insufficientAlert = UIAlertController(title: "解锁成功", message: nil, preferredStyle: .Alert)
                        let cancel = UIAlertAction(title: "确定", style: .Cancel, handler: nil)
                        insufficientAlert.addAction(cancel)
                        self.presentViewController(insufficientAlert, animated: true, completion: nil)
                        }, failure: { (task, error) -> Void in
                            print("put pcoin error:")
                            print(error.localizedDescription)
                            let insufficientAlert = UIAlertController(title: "解锁失败", message: "请检查网络连接是否通畅", preferredStyle: .Alert)
                            let cancel = UIAlertAction(title: "确定", style: .Cancel, handler: nil)
                            insufficientAlert.addAction(cancel)
                            self.presentViewController(insufficientAlert, animated: true, completion: nil)
                    })
                }
                
            })
            let cancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
            unlockAlert.addAction(cancel)
            unlockAlert.addAction(ok)
            self.presentViewController(unlockAlert, animated: true, completion: nil)
        }else{
            self.navigationController?.navigationBar.hidden = false
            let lVC = LevelUserController()
            lVC.level = sender.level
            self.navigationController?.pushViewController(lVC, animated: true)
        }
    }
    
    deinit{
//        SHARED_USER.removeObserver(self, forKeyPath: "Average", context: nil)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if(keyPath == "Average"){
            refreshLevelButton()
        }else{
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    func menuButtonAction() {
        self.view.addSubview(self.circularMenuVC.view)
        self.circularMenuVC.view.backgroundColor = COLOR_BG
        circularMenuVC.show()
    }
    func randomButtonAction() {
        self.navigationController?.navigationBar.hidden = false
        let rVC = RandomUserController()
        self.navigationController?.pushViewController(rVC, animated: true)
    }
    
    
    func circularMenuClickedButtonAtIndex(buttonIndex: Int32) {
        
        //TODO: add more pos to different pages
        self.navigationController?.navigationBar.hidden = false
        self.navigationController?.navigationBar.backgroundColor = UIColor.blackColor()
        
        switch buttonIndex {
        case 0:
            generateNodesByGender(1)

        case 1:
            generateNodesByGender(0)

        case 2:
            refreshBtnClicked()

        case 3:
            pushUserProfileVC()
        
        case 4:
            self.navigationController?.navigationBar.hidden = true
            self.circularMenuVC.resignFirstResponder()
            
        case 5:
            let cVC = ChatViewController()
            self.navigationController?.pushViewController(cVC, animated: true)
            
        case 6:
            let nVC = NotificationViewController()
            self.navigationController?.pushViewController(nVC, animated: true)
            
        case 7:
            let sVC = SettingsViewController()
            self.navigationController?.pushViewController(sVC, animated: true)
            
        default:
            self.circularMenuVC.resignFirstResponder()
        }
    }

    func pushUserProfileVC() {
        let pVC = MeProfileMasterViewController(nibName: "ProfileMasterViewController", bundle: nil)
        pVC.userID = SHARED_USER.UserIndex
        self.navigationController?.pushViewController(pVC, animated: true)
    }

    private func showBtns(gridBtns: [TenGridButton]) {
        for btn in gridBtns {

            // add nodes with animation
            self.view.addSubview(btn)
            UIView.animateWithDuration(0.5, animations: {()->Void in
                btn.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1)
                },

                completion: {(finished) -> Void in
                    NSThread.sleepForTimeInterval(0.1)
            })
            btn.addTarget(self, action: "toTargetUser:", forControlEvents: .TouchUpInside)
            
        }
    }


    private func updateLocation() {
        if let loc = LOC_MANAGER.location {

            // Location Manager
            let params = [
                "UserIndex": SHARED_USER.UserIndex,
                "UserName" : SHARED_USER.UserName,
                "PhoneType" : SHARED_USER.PhoneType,
                "Gender" : SHARED_USER.Gender,
                "Marrige" : SHARED_USER.Marriage,
                "Birthday" : SHARED_USER.Birthday,
                "JoinedDate" : SHARED_USER.JoinedDate,
                "PCoin" : SHARED_USER.PCoin,
                "ProfileUrl":SHARED_USER.ProfileUrl,
                "OuterScore" : SHARED_USER.OuterScore,
                "InnerScore" : SHARED_USER.InnerScore,
                "Energy" : SHARED_USER.Energy,
                "Hobby" : SHARED_USER.Hobby,
                "Quote" : SHARED_USER.Quote,
                "Expire":SHARED_USER.Expire,
                "AVG":SHARED_USER.AVG,
                "Lati" : loc.coordinate.latitude,
                "Longi" : loc.coordinate.longitude
            ]

            let targetUrl = Url_User + String(SHARED_USER.UserIndex)

            ALAMO_MANAGER.request(.PUT, targetUrl, parameters: params as? [String : AnyObject], encoding: .JSON) .responseJSON
            {
                    response in
            }
        }
    }
}
