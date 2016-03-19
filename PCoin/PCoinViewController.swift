//
//  PCoinViewController.swift
//  Ten
//
//  Created by gt on 15/10/17.
//  Copyright © 2015年 LiMao Tech. All rights reserved.
//

import UIKit

enum pcoinModelType{
    case Pcoin,History,Transfer,Unlocked
}

class PCoinViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,GTCoinPuschaseDelegate {
    var topView : UIView!
    var pcoinItemList : UITableView!
    var pcoinPurchaseHistory = [PCoinHistoryModel]()
    var pcoinPurchaseLevelHistory = [PCoinHistoryModel]()
    var pcoinTransHistory = [PCoinTransModel]()
    var modelType : pcoinModelType = .Pcoin
    let pcoinValue = [10,20,50,100]
    var item0:SettingButton!
    var item1:SettingButton!
    var item2:SettingButton!
    var item3:SettingButton!
    var selectedBtn:SettingButton!
    let pcoinNum = [10,20,50,100]
    var purchaseIndex = 0
    var transIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named:"navBar_pcoin"), forBarMetrics: .Default)
        self.title = PcoinTitle
        self.view.backgroundColor = COLOR_BG
        //topview
        topView = UIView(frame: CGRectMake(0, 64, SCREEN_WIDTH, TAP_BAR_HEIGHT))
        let len = SCREEN_WIDTH/4
        item0 = SettingButton(frame: CGRectMake(0, 0, len, TAP_BAR_HEIGHT))
        item1 = SettingButton(frame: CGRectMake(len, 0, len, TAP_BAR_HEIGHT))
        item2 = SettingButton(frame: CGRectMake(2*len, 0, len, TAP_BAR_HEIGHT))
        item3 = SettingButton(frame: CGRectMake(3*len, 0, len, TAP_BAR_HEIGHT))
        item0.normalImage = UIImage(named: "tab_pcoin_purchase_normal")
        item0.seletedImage = UIImage(named: "tab_pcoin_purchase_highlight")
        item1.normalImage = UIImage(named: "tab_pcoin_history_normal")
        item1.seletedImage = UIImage(named: "tab_pcoin_history_highlight")
        item2.normalImage = UIImage(named: "tab_pcoin_transfer_normal")
        item2.seletedImage = UIImage(named: "tab_pcoin_transfer_highlight")
        item3.normalImage = UIImage(named: "tab_pcoin_unlock_normal")
        item3.seletedImage = UIImage(named: "tab_pcoin_unlock_highlight")
        item0.setImage(item0.seletedImage, forState: .Normal)
        item1.setImage(item1.normalImage, forState: .Normal)
        item2.setImage(item2.normalImage, forState: .Normal)
        item3.setImage(item3.normalImage, forState: .Normal)
        item0.addTarget(self, action: "changeModel:", forControlEvents: .TouchUpInside)
        item1.addTarget(self, action: "changeModel:", forControlEvents: .TouchUpInside)
        item2.addTarget(self, action: "changeModel:", forControlEvents: .TouchUpInside)
        item3.addTarget(self, action: "changeModel:", forControlEvents: .TouchUpInside)
        item0.model = .Pcoin
        item1.model = .History
        item2.model = .Transfer
        item3.model = .Unlocked
        topView.addSubview(item0)
        topView.addSubview(item1)
        topView.addSubview(item2)
        topView.addSubview(item3)
        //tableview
        pcoinItemList = UITableView(frame: CGRectMake(0, CGRectGetMaxY(topView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(topView.frame)))
        pcoinItemList.delegate = self
        pcoinItemList.dataSource = self
        pcoinItemList.backgroundColor = UIColor.clearColor()
        pcoinItemList.separatorStyle = .None
        pcoinItemList.allowsSelection = false

        self.view.addSubview(topView)
        self.view.addSubview(pcoinItemList)
        selectedBtn = item0
        initialData()
        refreshControl()
        // Do any additional setup after loading the view.
    }
    
    func initialData(){
        let results = PcoinPurchaseHistoryCache().getPurchaseHistoryInfo()
        if(!results.isEmpty){
            purchaseIndex = (results.infos.last?.ID)!
            for info in results.infos{
                if (info.PurchaseType == 0){
                    pcoinPurchaseHistory.append(info)
                }else{
                    pcoinPurchaseLevelHistory.append(info)
                }
            }
        }
        pcoinItemList.reloadData()
    }
    
    func refreshControl(){
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: "refreshStateChange:", forControlEvents: .ValueChanged)
        self.pcoinItemList.addSubview(refresh)
        refreshStateChange(refresh)
    }
    
    func refreshStateChange(refresh:UIRefreshControl){
        getPcoinHistory(refresh)
    }
    
    func getPcoinHistory(refresh:UIRefreshControl){
        print("get history")
        AFJSONManager.SharedInstance.getMethodWithParams(Url_Purchase, parameters: ["userIndex":SHARED_USER.UserIndex,"purchaseIndex":purchaseIndex], success: { (task, response) -> Void in
            print("purchase history done")
            print(response)
            let historyArray = response as! NSArray
            if(historyArray.count > 0){
                for info in historyArray{
                    let history = PCoinHistoryModel(dict: info as! NSDictionary)
                    self.purchaseIndex = history.ID
                    PcoinPurchaseHistoryCache().addPurchaseHistoryInfo(history)
                    if(history.PurchaseType == 0){
                    self.pcoinPurchaseHistory.append(history)
                    }else{
                    self.pcoinPurchaseLevelHistory.append(history)
                    }
                }
                self.pcoinItemList.reloadData()
            }
            refresh.endRefreshing()
            },failure:  { (task,error) -> Void in
                print("getPurchaseHistory Failed")
                print(error.localizedDescription)
                refresh.endRefreshing()
        })
        
        AFJSONManager.SharedInstance.getMethodWithParams(Url_Msg, parameters: ["userIndex":SHARED_USER.UserIndex,"msgType":2,"currentIndex":transIndex], success: { (task, response) -> Void in
            print("purchase level history done")
            print(response)
            let historyArray = response as! NSArray
            if(historyArray.count > 0){
                for info in historyArray{
                    let history = PCoinTransModel(dict: info as! NSDictionary)
                    self.transIndex = history.MsgIndex
                    self.pcoinTransHistory.append(history)
                }
            }
            self.pcoinItemList.reloadData()
            refresh.endRefreshing()
            },failure:  { (task,error) -> Void in
                print("getPurchaseLevelHistory Failed")
                print(error.localizedDescription)
                refresh.endRefreshing()
        })
    }
    
    func changeModel(sender:SettingButton){
        selectedBtn.setImage(selectedBtn.normalImage, forState: .Normal)
        selectedBtn = sender
        sender.setImage(sender.seletedImage, forState: .Normal)
        modelType = sender.model
        pcoinItemList.reloadData()
    }

    func buyButtonDidClickeds(cell: PCoinPurchaseCell) {
        cell.buyButton.enabled = false
        let amount = pcoinNum[cell.index]
        let successAlert = UIAlertController(title: "购买 \(amount) P币", message: nil, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Destructive) { (ac) -> Void in
            cell.buyButton.enabled = false
//            let params = ["id":SHARED_USER.UserIndex,"pcoin":amount,"note":"花费了\(amount/10)元"]
            let url = Url_User + "/\(SHARED_USER.UserIndex)?pcoin=\(amount)&note=花费了\(amount/10)元"
//            let urlComplete = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
            let charSet = NSCharacterSet(charactersInString: url)
            let urlNew = url.stringByAddingPercentEncodingWithAllowedCharacters(charSet)
            AFJSONManager.SharedInstance.putMethod(urlNew!, success: { (task, response) -> Void in
                let successAlert = UIAlertController(title: "购买成功", message: nil, preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "确定", style: .Cancel, handler: nil)
                self.presentViewController(successAlert, animated: true, completion: nil)
                SHARED_USER.PCoin += Double(amount)
                UserCacheTool().upDateUserPCoin()
                cell.buyButton.enabled = true
                successAlert.addAction(okAction)
                },failure: { (task, error) -> Void in
                    let successAlert = UIAlertController(title: "购买失败", message: nil, preferredStyle: .Alert)
                    let okAction = UIAlertAction(title: "确定", style: .Cancel, handler: nil)
                    successAlert.addAction(okAction)
                    self.presentViewController(successAlert, animated: true, completion: nil)
                    cell.buyButton.enabled = true
                    print("pcoin purchase failed")
                    print(error.localizedDescription)
            })
        }
        successAlert.addAction(cancelAction)
        successAlert.addAction(okAction)
        self.presentViewController(successAlert, animated: true, completion: nil)
            }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(modelType == .History){
            var cell = pcoinItemList.dequeueReusableCellWithIdentifier("historyCell") as? PCoinHistoryCell
            if(cell == nil){
                cell = PCoinHistoryCell.init(style: .Default, reuseIdentifier: "historyCell")
            }
            cell?.pcoinHistoryModel = pcoinPurchaseHistory.reverse()[indexPath.row]
            return cell!
        }
        if(modelType == .Transfer){
            var cell = pcoinItemList.dequeueReusableCellWithIdentifier("transferCell") as? PCoinTransferCell
            if(cell == nil){
                cell = PCoinTransferCell.init(style: .Default, reuseIdentifier: "transferCell")
            }
            cell?.transfer = pcoinTransHistory[indexPath.row]
            return cell!
        }
        if(modelType == .Unlocked){
            var cell = pcoinItemList.dequeueReusableCellWithIdentifier("unlockedCell") as? PCoinUnlockedCell
            if(cell == nil){
                cell = PCoinUnlockedCell.init(style: .Default, reuseIdentifier: "unlockedCell")
            }
            cell?.pcoinHistoryModel = pcoinPurchaseLevelHistory.reverse()[indexPath.row]
            return cell!
        }
        
        var cell = pcoinItemList.dequeueReusableCellWithIdentifier("purchaseCell") as? PCoinPurchaseCell
        if(cell == nil){
            cell = PCoinPurchaseCell.init(style: .Default, reuseIdentifier: "purchaseCell")
        }
        cell?.pcoinLabel.text = "\(pcoinValue[indexPath.row]) P币"
        cell?.priceLabel.text = "Price:\(pcoinValue[indexPath.row]/10) 元"
        cell?.index = indexPath.row
        cell?.delegate = self
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(modelType == .History){
            return pcoinPurchaseHistory.count
        }
        if(modelType == .Transfer){
            return pcoinTransHistory.count
        }
        if(modelType == .Unlocked){
            return pcoinPurchaseLevelHistory.count
        }
        return 4
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if(modelType == .History){
            return 64
        }
        if(modelType == .Transfer){
            return 75
        }
        if(modelType == .Unlocked){
            return 65
        }
        
        return 64
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
