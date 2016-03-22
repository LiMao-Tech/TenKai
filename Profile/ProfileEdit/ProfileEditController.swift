//
//  EditProfileController.swift
//  Ten
//
//  Created by gt on 15/11/9.
//  Copyright © 2015年 LiMao Tech. All rights reserved.
//

import UIKit

class EditProfileController : UIViewController,
                            UIAlertViewDelegate,
                            UINavigationControllerDelegate,
                            UIImagePickerControllerDelegate
{
    var chosenImage : UIImage?
    var counter : Int?
    var buttonProfile : UIButton!
    var picker : UIImagePickerController? = UIImagePickerController()
    
    var scroll:UIScrollView!
    var userName:UILabel!
    var birthDate:UILabel!
    var sex:UILabel!
    var emailAddr:UILabel!
    var singleBtn:SettingButton!
    var marriedBtn:SettingButton!
    var statusDetail:UITextView!
    var InnerValue:UILabel!
    var OuterValue:UILabel!
    var energyBar:TenSlider!
    var energyValue:UILabel!
    var button:UIBarButtonItem!
    
    var loading:TenLoadingView?
    
    var changePortarit = false
    
    let lineLength:CGFloat = SCREEN_HEIGHT == 568 ? 150 : 200
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("marriage")
        print(SHARED_USER.Marriage)
        self.view.backgroundColor = COLOR_BG
        self.title = ProfileTitle
        button = UIBarButtonItem(title: "完成", style: .Done, target: self, action: "editDone")
        self.navigationItem.rightBarButtonItem = button
        
        chosenImage = UIImage()
        buttonProfile = initButton(posX: SCREEN_WIDTH/2, posY: 104, btnWidth: 70, btnHeight: 70, imageName: "user_pic_radar", targetAction: "toImagePicker")
        buttonProfile.setImage(Tools.toCirclurImage(SHARED_USER.PortraitImage!), forState: .Normal)
        var y = CGRectGetMaxY(buttonProfile.frame)+10
        userName = UILabel(frame: CGRectMake(0,y,SCREEN_WIDTH,20))
        userName.font = UIFont(name: FONTNAME_NORMAL, size: 17)
        userName.textColor = UIColor.whiteColor()
        userName.textAlignment = .Center
        userName.text = String(SHARED_USER.UserName)
        let margin:CGFloat = 25
        y = CGRectGetMaxY(userName.frame)+50
        
        scroll = UIScrollView(frame: CGRectMake(0,y,SCREEN_WIDTH,SCREEN_HEIGHT - y))
        scroll.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 100)
        scroll.bounces = false
        
        let textX:CGFloat = 145
        
        let birthLabel = initLabel(posX: 15, posY: 5, labelWidth: 100, labelHeight: 20, labelText: "生日")
        birthDate = UILabel(frame:CGRectMake(textX,5,lineLength,20))
        birthDate = initTextLabel(frame: CGRectMake(textX, 5, lineLength, 20),labelText: Tools.toBitrhDate(SHARED_USER.Birthday))
        y = CGRectGetMaxY(birthLabel.frame)+margin
        let sexLabel = initLabel(posX: 15, posY: y, labelWidth: 100, labelHeight: 20, labelText: "性别")
        sex = initTextLabel(frame: CGRectMake(textX, y, lineLength, 20),labelText: SHARED_USER.Gender == 0 ? "男" : "女")
        y = CGRectGetMaxY(sexLabel.frame)+margin
        let marriageLabel = initLabel(posX: 15, posY: y, labelWidth: 100, labelHeight: 20, labelText: "Marriage")
        singleBtn = initChooseBtn(CGRectMake(textX, y, 55, 20), selectedImage: UIImage(named: "icon_checkbox")!, normalImage: UIImage(named: "icon_checkcircle")!, title: "  单身")
        singleBtn.addTarget(self, action: "marriageBtnClicked:", forControlEvents: .TouchUpInside)
        marriedBtn = initChooseBtn(CGRectMake(textX+80, y, 65, 20), selectedImage: UIImage(named: "icon_checkbox")!, normalImage: UIImage(named: "icon_checkcircle")!, title: "  已婚")
        marriedBtn.addTarget(self, action: "marriageBtnClicked:", forControlEvents: .TouchUpInside)
        if(SHARED_USER.Marriage == 0){
            singleBtn.setImage(singleBtn.seletedImage, forState: .Normal)
        }else{
            marriedBtn.setImage(marriedBtn.seletedImage, forState: .Normal)
        }
        y = CGRectGetMaxY(marriageLabel.frame)+margin
        let emailLabel = initLabel(posX: 15, posY: y, labelWidth: 100, labelHeight: 20, labelText: "E-mail")
        let loginEmail = NSUserDefaults.standardUserDefaults().valueForKey("LoginEmail") as! String
        emailAddr = initTextLabel(frame: CGRectMake(textX, y, lineLength, 20),labelText: loginEmail)
        y = CGRectGetMaxY(emailLabel.frame)+margin
        let statusLabel = initLabel(posX: 15, posY: y, labelWidth: 100, labelHeight: 20, labelText: "状态")
        statusDetail = UITextView(frame: CGRectMake(textX, y+5, lineLength, SCREEN_HEIGHT*2/12-10))
        statusDetail.backgroundColor = UIColor(red: 63.0/255.0, green: 63.0/255.0, blue: 64.0/255.0, alpha: 1)
        statusDetail.textColor = UIColor.whiteColor()
        statusDetail.bounces = false
        statusDetail.font = UIFont.systemFontOfSize(15)
        statusDetail.text = SHARED_USER.Quote
        y = CGRectGetMaxY(statusDetail.frame)+margin
        let InnerLabel = initLabel(posX: 15, posY: y, labelWidth: 100, labelHeight: 20, labelText: "内在")
        InnerValue = initTextLabel(frame: CGRectMake(textX, y, lineLength, 20),labelText: String(SHARED_USER.InnerScore))
        y = CGRectGetMaxY(InnerLabel.frame)+margin
        let OuterLabel = initLabel(posX: 15, posY: y, labelWidth: 100, labelHeight: 20, labelText: "外在")
        OuterValue = initTextLabel(frame: CGRectMake(textX, y, lineLength, 20),labelText: String(SHARED_USER.OuterScore))
        y = CGRectGetMaxY(OuterLabel.frame)+margin
        let energyLabel = initLabel(posX: 15, posY: y, labelWidth: 100, labelHeight: 20, labelText: "能量")
        energyBar = TenSlider(frame: CGRectMake(textX, y, lineLength-30, 20))
        energyBar.minimumValue = 1
        energyBar.maximumValue = 10
        energyBar.setValue(Float(SHARED_USER.Energy), animated: false)
        energyBar.addTarget(self, action: "barChanged", forControlEvents: UIControlEvents.ValueChanged)
        energyValue = UILabel(frame: CGRectMake(CGRectGetMaxX(energyBar.frame)+10, y, 20, 20))
        energyValue.text = String(SHARED_USER.Energy)
        energyValue.textColor = UIColor.whiteColor()
        
        
        self.view.addSubview(buttonProfile)
        self.view.addSubview(userName)
        self.view.addSubview(scroll)
        self.scroll.addSubview(birthLabel)
        self.scroll.addSubview(birthDate)
        self.scroll.addSubview(sexLabel)
        self.scroll.addSubview(sex)
        self.scroll.addSubview(emailLabel)
        self.scroll.addSubview(emailAddr)
        self.scroll.addSubview(marriageLabel)
        self.scroll.addSubview(singleBtn)
        self.scroll.addSubview(marriedBtn)
        self.scroll.addSubview(statusLabel)
        self.scroll.addSubview(statusDetail)
        self.scroll.addSubview(InnerLabel)
        self.scroll.addSubview(OuterLabel)
        self.scroll.addSubview(InnerValue)
        self.scroll.addSubview(OuterValue)
        self.scroll.addSubview(energyLabel)
        self.scroll.addSubview(energyBar)
        self.scroll.addSubview(energyValue)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {

    }
    
    func editDone(){
        // TODO: what is this?
        print("done")
        putSharedUserInfo()
    }
    
    func barChanged(){
        let value = Int(energyBar.value+1)-1
        energyValue.text = "\(value)"
        SHARED_USER.Energy = value
    }
    
    func initButton(posX posX: CGFloat, posY: CGFloat, btnWidth: CGFloat, btnHeight: CGFloat, imageName: String, targetAction: Selector) -> UIButton{
        
        let result = UIButton(frame: CGRectMake(0, 0, btnWidth, btnHeight))
        result.center = CGPointMake(posX, posY)
        result.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        result.addTarget(self, action: targetAction, forControlEvents: UIControlEvents.TouchUpInside)
        
        return result
    }
    func toImagePicker(){
        //
        print("going to do imagepicker here")
        
        
        
        let alert:UIAlertController=UIAlertController(title: "选择图片", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let cameraAction = UIAlertAction(title: "相机", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                self.openCamera()
                
        }
        let gallaryAction = UIAlertAction(title: "相册", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel)
            {
                UIAlertAction in
                
        }
        
        picker?.delegate = self
        
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        
        // Present the controller
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else
        {
            print("Please use an IPhone for this action")
        }
    }
    
    func openCamera()
    {
        
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
        {
            picker!.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(picker!, animated: true, completion: nil)
            
        }
        else
        {
            openGallary()
        }
    }
    func openGallary()
    {
        picker!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            self.presentViewController(picker!, animated: true, completion: nil)
            
        }
        else
        {
            print("Please use an IPhone for this action")
        }
    }
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // TODO: add image into profile
        
        // chosenImages
        picker .dismissViewControllerAnimated(true, completion: nil)
        let image=info[UIImagePickerControllerOriginalImage] as? UIImage
        chosenImage = image
        self.buttonProfile?.setImage(Tools.toCirclurImage(image!), forState: UIControlState.Normal)
        changePortarit = true
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func initLabel(posX posX:CGFloat, posY: CGFloat, labelWidth: CGFloat, labelHeight: CGFloat, labelText: String) -> UILabel{
        
        let resultLabel = UILabel(frame: CGRectMake(posX, posY, labelWidth, labelHeight))
        resultLabel.text = labelText
        resultLabel.font = UIFont(name: FONTNAME_BOLD, size: 16)
        resultLabel.textColor = COLOR_ORANGE
        resultLabel.numberOfLines = 1;
        return resultLabel
    }
    
    func initTextLabel(frame frame:CGRect,labelText: String) -> UILabel{
        let resultLabel = UILabel(frame:frame)
        resultLabel.text = labelText
        resultLabel.font = UIFont(name: FONTNAME_NORMAL, size: 16)
        resultLabel.textColor = UIColor(red: 136.0/255.0, green: 142.0/255.0, blue: 152.0/255.0, alpha: 1.0)
        resultLabel.numberOfLines = 1;
        return resultLabel
    }
    
    func initChooseBtn(frame:CGRect,selectedImage:UIImage,normalImage:UIImage,title:String?) -> SettingButton{
        let chooseBtn = SettingButton(frame: frame)
        chooseBtn.seletedImage = selectedImage
        chooseBtn.normalImage = normalImage
        chooseBtn.setImage(chooseBtn.normalImage, forState: .Normal)
        chooseBtn.setTitle(title, forState: .Normal)
        chooseBtn.titleLabel?.font = UIFont.systemFontOfSize(13)
        chooseBtn.adjustsImageWhenDisabled = false
        return chooseBtn
    }
    
    func marriageBtnClicked(sender:SettingButton){
        sender.enabled = false
        if(sender.currentTitle == "  单身"){
            singleBtn.setImage(singleBtn.seletedImage, forState: .Normal)
            singleBtn.titleLabel?.alpha = 0.4
            marriedBtn.setImage(marriedBtn.normalImage, forState: .Normal)
            marriedBtn.titleLabel?.alpha = 1
            marriedBtn.enabled = true
            SHARED_USER.Marriage = 0
        }
        else{
            singleBtn.setImage(singleBtn.normalImage, forState: .Normal)
            singleBtn.titleLabel?.alpha = 1
            marriedBtn.setImage(marriedBtn.seletedImage, forState: .Normal)
            marriedBtn.titleLabel?.alpha = 0.4
            singleBtn.enabled = true
            SHARED_USER.Marriage = 1
        }
    }
    
    func putSharedUserInfo(){
        button.enabled = false
        
        if(loading == nil){
            loading = TenLoadingView()
            loading?.loadingTitle = "更新中..."
        }
        self.view.addSubview(loading!)
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
            "Quote" : statusDetail.text,
            "Expire":SHARED_USER.Expire,
            "AVG":SHARED_USER.AVG,
            "Lati" : SHARED_USER.Lati,
            "Longi" : SHARED_USER.Longi
        ]
        
        let targetUrl = Url_User + String(SHARED_USER.UserIndex)
        
        ALAMO_MANAGER.request(.PUT, targetUrl, parameters: params as? [String : AnyObject], encoding: .JSON) .responseJSON{
            response in
            if response.result.isSuccess{
                print("update shareduser info")
                print(response.result.value)
                self.button.enabled = true
                SHARED_USER.Quote = self.statusDetail.text
                UserCacheTool().updateUserInfo()
                if(self.changePortarit){
                    self.updatePortrait()
                    self.changePortarit = false
                }else{
                    self.delayMiss()
                }
            }else{
                self.button.enabled = true
                let alert = UIAlertController(title: "更新个人信息失败,请重新尝试", message: nil, preferredStyle: .Alert)
                let cancel = UIAlertAction(title: "确定", style: .Cancel, handler: nil)
                alert.addAction(cancel)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    func updatePortrait(){
        let image = UIImageJPEGRepresentation(chosenImage!, 0.75)
        if image != nil {
            let params : NSDictionary = ["id": SHARED_USER.UserIndex]
            
            AFImageManager.SharedInstance.postHeadImage(Url_UploadHeadImage, image: image!, parameters: params as! [String : AnyObject], success: { (task, response) -> Void in
                print("post Image")
                print(response)
                SHARED_USER.Portrait = image!
                self.button.enabled = true
                UserCacheTool().upDateUserPortrait()
                self.delayMiss()
                },failure: { (task, error) -> Void in
                    self.button.enabled = true
                    self.loading?.removeFromSuperview()
                    print("change Portrait Failed")
                    print(error.localizedDescription)
                    let alert = UIAlertController(title: "更新个人信息失败,请重新尝试", message: nil, preferredStyle: .Alert)
                    let cancel = UIAlertAction(title: "确定", style: .Cancel, handler: nil)
                    alert.addAction(cancel)
                    self.presentViewController(alert, animated: true, completion: nil)
            })
        }

    }
    private func delayMiss(){
        let time: NSTimeInterval = 1
        let delay = dispatch_time(DISPATCH_TIME_NOW,Int64(time * Double(NSEC_PER_SEC)))
        loading?.loadingTitle = "更新成功"
        loading?.acIndicator.hidden = true
        dispatch_after(delay, dispatch_get_main_queue()) {
            self.loading?.removeFromSuperview()
//            self.loading?.acIndicator.hidden = false
        }
    }
    
}
