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
import Foundation


class MainViewController: UIViewController, ADCircularMenuDelegate {

    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    let menuButton = UIButton(frame: CGRectMake(5, SCREEN_HEIGHT*(BUTTON_DENO-1)/BUTTON_DENO-5, SCREEN_HEIGHT/BUTTON_DENO, SCREEN_HEIGHT/BUTTON_DENO))
    let randomButton = UIButton(frame: CGRectMake(SCREEN_WIDTH-SCREEN_HEIGHT/BUTTON_DENO-5, SCREEN_HEIGHT*(BUTTON_DENO-1)/BUTTON_DENO-5, SCREEN_HEIGHT/BUTTON_DENO, SCREEN_HEIGHT/BUTTON_DENO))
    
    // circular menu
    let circularMenuVC = ADCircularMenuViewController(frame: UIScreen.mainScreen().bounds)
    
    var distanceLabel:UILabel!
    
    var lvoneBtn : LevelButton!
    var lvtwoBtn : LevelButton!
    var lvthreeBtn : LevelButton!
    var lvfourBtn : LevelButton!
    var lvfiveBtn : LevelButton!
    var lvsixBtn : LevelButton!
    var lvsevenBtn : LevelButton!
    var lveightBtn : LevelButton!
    var lvnineBtn : LevelButton!
    var lvtenBtn : LevelButton!
    var distance : GTSlider!
    var tenUser:TenUser!
    var gap : Int!
    var btns = Array<UIButton!>()
    
    let distances = [50,100,500,1000]
    var index = 0
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = true
    }
    
    // view loading
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barStyle = .Black
//    self.navigationController?.navigationBar.setBackgroundImage(UIImage(named:"navBar_bg"), forBarMetrics: .Default)
        self.navigationController?.navigationBar.backgroundColor = NAV_BAR_COLOR
        self.view.backgroundColor = BG_COLOR
        print(SharedUser.StandardUser().UserIndex)
//        let bg = UIImageView(frame: CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT))
//        bg.image = UIImage(named: "bg_radar")
//        bg.contentMode = UIViewContentMode.ScaleAspectFill
        
        // set circularMenu
        self.circularMenuVC.circularMenuDelegate = self
        self.circularMenuVC.view.frame = UIScreen.mainScreen().bounds
        
        //distanceLabel
        distanceLabel = UILabel(frame: CGRectMake(0,80,SCREEN_WIDTH,20))
        distanceLabel.textColor = UIColor.whiteColor()
        distanceLabel.font = UIFont(name: FONTNAME_NORMAL, size: 16)
        distanceLabel.textAlignment = .Center
        
        // gif
//        let l = SCREEN_WIDTH*0.915
//        let gifView = YLImageView(frame: CGRectMake(0, 0, l, l))
//        gifView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)
//        
//        YLGIFImage.setPrefetchNum(5)
//        let path = NSBundle.mainBundle().URLForResource("Radar", withExtension: "gif")?.absoluteString as String!
//        gifView.image = YLGIFImage(contentsOfFile: path)
        
        //setupButtons
        setupButtons()
        
        // add location observer
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "locationChanged:",
            name: LocationNotiName,
            object: nil)
    
        // config buttons
        menuButton.setImage(UIImage(named: "btn_menu"), forState: UIControlState.Normal)
        randomButton.setImage(UIImage(named: "btn_radar_random"), forState: UIControlState.Normal)
        menuButton.addTarget(self, action: "menuButtonAction", forControlEvents: UIControlEvents.TouchUpInside)
        randomButton.addTarget(self, action: "randomButtonAction", forControlEvents: UIControlEvents.TouchUpInside)
        
        let distanceY = CGRectGetMinY(menuButton.frame) - 80
        distance = GTSlider(frame: CGRectMake(45,distanceY,SCREEN_WIDTH - 90,24))
        distance.minimumValue = 0
        distance.maximumValue = 3
        
        distance.addTarget(self, action: "distanceChange", forControlEvents: UIControlEvents.ValueChanged)
        let minus = UIButton(frame: CGRectMake(10,distanceY,24,24))
        let plus = UIButton(frame: CGRectMake(SCREEN_WIDTH - 34,distanceY,24,24))
        minus.setImage(UIImage(named: "btn_radar_minus"), forState: .Normal)
        plus.setImage(UIImage(named: "btn_radar_plus"), forState: .Normal)
        
        minus.addTarget(self, action: "minusClicked", forControlEvents: .TouchUpInside)
        plus.addTarget(self, action: "plusClicked", forControlEvents: .TouchUpInside)
        let refreshBtn = UIButton(frame: CGRectMake(0,0,22.5,21))
        refreshBtn.center = CGPointMake(SCREEN_WIDTH/2,menuButton.center.y)
        refreshBtn.setImage(UIImage(named: "btn_radar_refresh"), forState: .Normal)
        refreshBtn.addTarget(self, action: "refreshBtnClicked", forControlEvents: .TouchUpInside)
        
//        self.view.addSubview(bg)
//        self.view.addSubview(gifView)
        self.view.addSubview(menuButton)
        self.view.addSubview(randomButton)
        self.view.addSubview(distance)
        self.view.addSubview(minus)
        self.view.addSubview(plus)
        self.view.addSubview(refreshBtn)
        self.view.addSubview(distanceLabel)
        distanceChange()
    }
    
    func minusClicked(){
        if(index > 0){
            index -= 1
            distance.setValue(Float(index), animated: true)
            distanceLabel.text = "\(distances[index]) km"
        }
    }
    
    func plusClicked(){
//        distance.value = distance.value + 200
        if(index < 3){
            index += 1
            distance.setValue(Float(index), animated: true)
            distanceLabel.text = "\(distances[index]) km"
        }
    }
    
    func distanceChange(){
        index = Int(distance.value+0.5)
        distance.setValue(Float(index), animated: true)
        distanceLabel.text = "\(distances[index]) km"
    }
    
    func refreshBtnClicked(){
        print("refresh")
    }
    
    
    func setupButtons(){
        
        var btnArray = [lvoneBtn,lvtwoBtn,lvthreeBtn,lvfourBtn,lvfiveBtn,lvsixBtn,lvsevenBtn,lveightBtn,lvnineBtn,lvtenBtn]
        
        let marginw:CGFloat = 30
        let marginh:CGFloat = 20
        let iconw:CGFloat = 58
        let iconh:CGFloat = 67
        let x = (SCREEN_WIDTH - iconw*3 - marginw*2)/2
        let y:CGFloat = 90
        
        for i in 0...btnArray.count-2{
            let row = i/3
            let col = i%3
            btnArray[i] = LevelButton(frame: CGRectMake(x + CGFloat(col)*(marginw+iconw), y + CGFloat(row)*(marginh+iconh), iconw, iconh))
            btnArray[i].level = "\(i+1)"
            btnArray[i].setImage(UIImage(named: "btn_l\(i+1)_unlock"), forState: UIControlState.Normal)
            btnArray[i].addTarget(self, action: "levelSelect:", forControlEvents: UIControlEvents.TouchUpInside)
            self.circularMenuVC.view.addSubview(btnArray[i])
//            btnArray[i].hidden = true
            btns.append(btnArray[i])
        }
        
        lvtenBtn = LevelButton(frame: CGRectMake(x+marginw+iconw, y + 3*(marginh+iconh), iconw, iconh))
        lvtenBtn.setImage(UIImage(named: "btn_l10_lock"), forState: UIControlState.Normal)
        lvtenBtn.level = "10"
        lvtenBtn.addTarget(self, action: "levelSelect:", forControlEvents: UIControlEvents.TouchUpInside)
        self.circularMenuVC.view.addSubview(lvtenBtn)
//        lvtenBtn.hidden = true
        btns.append(lvtenBtn)
        
    }
    
    // button actions
    func levelSelect(sender:LevelButton){
        self.navigationController?.navigationBar.hidden = false
        let lVC = LevelUserController()
        lVC.level = sender.level
        self.navigationController?.pushViewController(lVC, animated: true)
    }
    
    func menuButtonAction() {
        self.view.addSubview(self.circularMenuVC.view)
        self.circularMenuVC.view.backgroundColor = BG_COLOR
        circularMenuVC.show()
    }
    func randomButtonAction() {
        self.navigationController?.navigationBar.hidden = false
        let rVC = RandomUserController()
        self.navigationController?.pushViewController(rVC, animated: true)
    }
    
    
    func circularMenuClickedButtonAtIndex(buttonIndex: Int32) {
        // did select subMenu
        
        print("selected: \(buttonIndex)")
        
        //TODO: add more pos to different pages
        
        switch buttonIndex {
        case 0:
            self.navigationController?.navigationBar.hidden = false
            let rpVC = RegistProfileViewController()
            self.navigationController?.pushViewController(rpVC, animated: true)

        case 1:
            self.navigationController?.navigationBar.hidden = false
            let wVC = WelcomeController()
            self.navigationController?.pushViewController(wVC, animated: true)
        
        case 2:
            self.navigationController?.navigationBar.hidden = false
            let eVC = EditProfileController()
            self.navigationController?.pushViewController(eVC, animated: true)

        case 3:
            self.navigationController?.navigationBar.backgroundColor = UIColor.blackColor()
            self.navigationController?.navigationBar.hidden = false
            let pVC = ProfileViewController()
            self.navigationController?.pushViewController(pVC, animated: true)
        
        case 4:
            self.navigationController?.navigationBar.backgroundColor = UIColor.blackColor()
            self.navigationController?.navigationBar.hidden = false
            let cVC = ChatViewController()
            self.navigationController?.pushViewController(cVC, animated: true)
            
        case 5:
            self.navigationController?.navigationBar.backgroundColor = UIColor.blackColor()
            self.navigationController?.navigationBar.hidden = false
            let nVC = NotificationViewController()
            self.navigationController?.pushViewController(nVC, animated: true)
            
        case 6:
            self.navigationController?.navigationBar.backgroundColor = UIColor.blackColor()
            self.navigationController?.navigationBar.hidden = false
            let sVC = SettingsViewController()
            self.navigationController?.pushViewController(sVC, animated: true)
            
        default:
            print("Not Implemented yet!")
        }

    }
    
    // Location Manager
    @IBAction func updateLocation(sender: AnyObject) {
        
        if(sharedManager.authorization_status == 1){
            sharedManager.startUpdatingLocation()
            NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: Selector("sharedManagerStopUpdatingLocation"), userInfo: nil, repeats: false)
        }
    }
    
    @objc func locationChanged(notification: NSNotification){
        if(sharedManager.is_ready == 1){
            let lati = sharedManager.currentLocation!.coordinate.latitude
            let longi = sharedManager.currentLocation!.coordinate.longitude
            
            print("New Location: \(lati) \(longi)")
            
            // ToDo: post location to the server
            
            // self.postLocationToServer(longi.description, lati: lati.description)
        }
        
    }
    
    func sharedManagerStopUpdatingLocation(){
        sharedManager.stopUpdatingLocation()
    }
    
    
    func postLocationToServer(longi:NSString, lati: NSString){
        
        // Post Location to Server
        let parameters = ["id":"1","latitude" : lati,"longitude" : longi]
        
        ALAMO_MANAGER.request(.POST, UpdateLocationByIdURL, parameters: parameters, encoding: .JSON) .responseJSON {
            response in
            if response.result.isSuccess {
                print(response.request)
                print(response.response)
                print(response.result)
                
                let responseStr = String(data: response.data!, encoding: NSUTF8StringEncoding)
                print(responseStr)
            }
            else {
                print("Something is Wrong.")
                
            }
            
        }
        
    }
}
