//
//  SettingsViewController.swift
//  Ten
//
//  Created by gt on 15/10/12.
//  Copyright © 2015年 LiMao Tech. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var settingList:UITableView!
    var logoutBtn:UIButton!
    let itemNames = ["Passcode","Change PIN","PCoin","","Term of Service","Privacy Policy"]
    var remainingPinEntries = 3
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = SettingTitle
        self.view.backgroundColor = BG_COLOR
        settingList = UITableView(frame: CGRectMake(30, 0, SCREEN_WIDTH - 60, 324))
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
        logoutBtn.addTarget(self, action: "logout", forControlEvents: .TouchUpInside)
        
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
        if(indexPath.row != 3){
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
        if(indexPath.row == 3){
            return 60
        }
        return 40
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.row == 0){
            let pcVC = PasscodeController()
            self.navigationController?.pushViewController(pcVC, animated: true)
            settingList.deselectRowAtIndexPath(indexPath, animated: true)
        }
        if (indexPath.row == 1){
            
        }
        if(indexPath.row == 2){
            let pvc = PCoinViewController()
            self.navigationController?.pushViewController(pvc, animated: true)
            settingList.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    
    func logout(){
        UserCacheTool().deleteUserInfo()
        NSUserDefaults.standardUserDefaults().removeObjectForKey("Logined")
        let wVC = WelcomeController()
        self.presentViewController(wVC, animated: true, completion: nil)
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