//
//  RegistProfileViewController.swift
//  Ten
//
//  Created by gt on 15/10/22.
//  Copyright © 2015年 LiMao Tech. All rights reserved.
//

import UIKit
import Alamofire


class RegistProfileViewController: UIViewController,
                                    UIAlertViewDelegate,
                                    UINavigationControllerDelegate,
                                    UIImagePickerControllerDelegate,
                                    UITextViewDelegate,
                                    UITextFieldDelegate
{
    let lineLength:CGFloat = SCREEN_WIDTH*0.6

    //property
    var password:String!
    var email:String!
    var tenLogin:TenLogin?
    var gender:Int = -1
    var marriage:Int = -1
    
    // Image Picker Variables
    var chosenImage : UIImage = UIImage()
    var imageUrl : String?
    var counter : Int?

    // scrollView Variables
    var scrollView: UIScrollView!
    
    var username:UITextField!
    var birthDate:UITextField!
    
    var buttonProfile : UIButton!
    
    var maleBtn:SettingButton!
    var feMaleBtn:SettingButton!
    
    var singleBtn:SettingButton!
    var marriedBtn:SettingButton!
    
    var emailAddr:UILabel!
    
    var hobby: UITextField!
    
    var statusDetail:UITextView!
    var placeHolder:UILabel!
    
    var innerBar:GTSlider!
    var innerValue:UILabel!
    
    var outerBar:GTSlider!
    var outerValue:UILabel!
    
    var energyBar:GTSlider!
    var energyValue:UILabel!
    
    var button:UIButton!
    
    var indicator: UIActivityIndicatorView!

    var kbSize: CGSize?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SHARED_PICKER.picker.delegate = self
        SHARED_PICKER.picker.allowsEditing = true
        self.view.backgroundColor = COLOR_BG
        self.title = ProfileTitle
        
        let titleView = UIView(frame: CGRectMake(0,0,SCREEN_WIDTH,63))
        self.view.addSubview(titleView)
        let titleLabel = UILabel(frame:CGRectMake(0,20,SCREEN_WIDTH,43))
        titleLabel.text = "个人页面"
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont(name: FONTNAME_NORMAL, size: 20)
        titleLabel.textAlignment = .Center
        titleView.addSubview(titleLabel)
        
        let splitLine = UIView(frame: CGRectMake(0,63,SCREEN_WIDTH,1))
        splitLine.backgroundColor = UIColor.whiteColor()
        splitLine.alpha = 0.7
        self.view.addSubview(splitLine)
        
        scrollView = UIScrollView(frame: CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64))
        scrollView!.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT*1.3+30)
        scrollView!.bounces = false
        
        
        button = UIButton(frame: CGRectMake(SCREEN_WIDTH-80,20,80,43))
        button.setTitle("完成", forState: .Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(15)
        button.addTarget(self, action: "toRadarPage", forControlEvents: .TouchUpInside)
        
        let backBtn = UIButton(frame: CGRectMake(0,20,80,43))
        backBtn.setTitle("返回", forState: .Normal)
        backBtn.titleLabel?.font = UIFont.systemFontOfSize(15)
        backBtn.addTarget(self, action: "viewBack", forControlEvents: .TouchUpInside)
        
        // init buttons
        buttonProfile = initButton(posX: SCREEN_WIDTH/2, posY: 70, btnWidth: 140/3*2, btnHeight: 140/3*2, imageName: "user_pic_radar_140", targetAction: "toImagePicker")
        buttonProfile.layer.masksToBounds = true
        buttonProfile.layer.cornerRadius = buttonProfile.bounds.width*0.5
        
        
        let marginX:CGFloat = 15
        
        let labelLen:CGFloat = 70
        // init labels
        let userNameLabel = initLabel(posX: marginX, posY: SCREEN_HEIGHT*3/12, labelWidth: labelLen, labelHeight: 100, labelText: "用户名＊")
        let textX = CGRectGetMaxX(userNameLabel.frame) + 20
        
        username = UITextField(frame: CGRectMake(textX,SCREEN_HEIGHT*3/12+40, lineLength, 20))
        username.textColor = UIColor.whiteColor()
        username.font = UIFont(name: FONTNAME_NORMAL, size: 15)
        
        let userLine = UIView(frame: CGRectMake(textX, CGRectGetMaxY(username.frame)+2, lineLength, 1))
        userLine.backgroundColor = UIColor.whiteColor()
        
        let dateOfBirthLabel = initLabel(posX: marginX, posY: SCREEN_HEIGHT*4/12, labelWidth: labelLen, labelHeight: 100, labelText: "生日＊")

        birthDate = UITextField(frame: CGRectMake(textX, SCREEN_HEIGHT*4/12+40, lineLength, 20))
        birthDate.textColor = UIColor.whiteColor()
        birthDate.font = UIFont(name: FONTNAME_NORMAL, size: 15)
        
        let picker = UIDatePicker()
        picker.datePickerMode = .Date
        picker.addTarget(self, action: "dataDidChange:", forControlEvents: .ValueChanged)
        birthDate.inputView = picker
        
        let accessoryView = UIToolbar(frame: CGRectMake(0, 0, SCREEN_WIDTH, 35))
        let doneBtn = UIBarButtonItem(title: "完成", style: .Done, target: self, action: "doneClicked")
        let space = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        accessoryView.setItems([space,doneBtn], animated: true)
        birthDate.inputAccessoryView = accessoryView
        let birthLine = UIView(frame: CGRectMake(textX, CGRectGetMaxY(birthDate.frame)+2, lineLength, 1))
        birthLine.backgroundColor = UIColor.whiteColor()
        let sexLabel = initLabel(posX: marginX, posY: SCREEN_HEIGHT*5/12, labelWidth: labelLen, labelHeight: 100, labelText: "性别＊")
        
        feMaleBtn = initChooseBtn(CGRectMake(textX, SCREEN_HEIGHT*5/12+40, 60, 20), selectedImage: UIImage(named: "icon_checkbox")!, normalImage: UIImage(named: "icon_checkcircle")!, title: "    女    ", action: "sexBtnClicked:")
        maleBtn = initChooseBtn(CGRectMake(textX+100, SCREEN_HEIGHT*5/12+40, 60, 20), selectedImage: UIImage(named: "icon_checkbox")!, normalImage: UIImage(named: "icon_checkcircle")!, title: "    男    ", action: "sexBtnClicked:")
        
        let marriageLabel = initLabel(posX: marginX, posY: SCREEN_HEIGHT*6/12, labelWidth: labelLen, labelHeight: 100, labelText: "婚姻＊")
        singleBtn = initChooseBtn(CGRectMake(textX, SCREEN_HEIGHT*6/12+40, 60, 20), selectedImage: UIImage(named: "icon_checkbox")!, normalImage: UIImage(named: "icon_checkcircle")!, title: "  单身  ", action: "marriageBtnClicked:")
        marriedBtn = initChooseBtn(CGRectMake(textX+100, SCREEN_HEIGHT*6/12+40, 60, 20), selectedImage: UIImage(named: "icon_checkbox")!, normalImage: UIImage(named: "icon_checkcircle")!, title: "  已婚  ", action: "marriageBtnClicked:")
        
        // Email Label
        let emailLabel = initLabel(posX: marginX, posY: SCREEN_HEIGHT*7/12, labelWidth: labelLen, labelHeight: 100, labelText: "邮箱")
        emailAddr = UILabel(frame: CGRectMake(textX, SCREEN_HEIGHT*7/12+40, lineLength, 20))
        emailAddr.textColor = UIColor(red: 137.0/255.0, green: 142.0/255.0, blue: 153.0/255.0, alpha: 1.0)
        emailAddr.font = UIFont(name: FONTNAME_NORMAL, size: 15)
        emailAddr.text = email
        
        // Hobby Label
        let hobbyLabel = initLabel(posX: marginX, posY: SCREEN_HEIGHT*8/12, labelWidth: labelLen, labelHeight: 100, labelText: "兴趣")
        hobby = UITextField(frame: CGRectMake(textX, SCREEN_HEIGHT*8/12+40, lineLength, 20))
        hobby.delegate = self
        hobby.textColor = UIColor.whiteColor()
        hobby.font = UIFont(name: FONTNAME_NORMAL, size: 15)
        hobby.placeholder = "例如：音乐"
        hobby.setValue(COLOR_WHITEGRAY, forKeyPath: "_placeholderLabel.textColor")

        let hobbyLine = UIView(frame: CGRectMake(textX, CGRectGetMaxY(hobby.frame)+2, lineLength, 1))
        hobbyLine.backgroundColor = UIColor.whiteColor()
        
        // Status Label
        let statusLabel = initLabel(posX: marginX, posY: SCREEN_HEIGHT*9/12, labelWidth: labelLen, labelHeight: 100, labelText: "状态")
        statusDetail = UITextView(frame: CGRectMake(textX, SCREEN_HEIGHT*9/12+40, lineLength, SCREEN_HEIGHT*2/12-10))
        statusDetail.backgroundColor = UIColor.blackColor()
        statusDetail.textColor = UIColor.whiteColor()
        statusDetail.bounces = false
        statusDetail.font = UIFont.systemFontOfSize(15)
        statusDetail.delegate = self

        placeHolder = UILabel(frame: CGRectMake(5, 5, lineLength-5, 20))
        placeHolder.text = "有很多要说。。。"
        placeHolder.textColor = COLOR_WHITEGRAY
        placeHolder.font = UIFont.systemFontOfSize(15)

        statusDetail.addSubview(placeHolder)
        
        // Inner Label
        let InnerLabel = initLabel(posX: marginX, posY: SCREEN_HEIGHT*12/12, labelWidth: labelLen, labelHeight: 100, labelText: "内在")
        innerBar = GTSlider(frame: CGRectMake(textX, SCREEN_HEIGHT*12/12+40, lineLength-30, 20))
        innerBar.minimumValue = 0
        innerBar.maximumValue = 10
        innerBar.addTarget(self, action: "barChanged", forControlEvents: UIControlEvents.ValueChanged)
        innerValue = UILabel(frame: CGRectMake(CGRectGetMaxX(innerBar.frame)+10, SCREEN_HEIGHT*12/12+40, 20, 20))
        innerValue.text = "0"
        innerValue.textColor = UIColor.whiteColor()
        
        let OuterLabel = initLabel(posX: marginX, posY: SCREEN_HEIGHT*13/12, labelWidth: labelLen, labelHeight: 100, labelText: "外在")
        outerBar = GTSlider(frame: CGRectMake(textX, SCREEN_HEIGHT*13/12+40, lineLength-30, 20))
        outerBar.minimumValue = 0
        outerBar.maximumValue = 10
        outerBar.addTarget(self, action: "barChanged", forControlEvents: UIControlEvents.ValueChanged)
        outerValue = UILabel(frame: CGRectMake(CGRectGetMaxX(outerBar.frame)+10, SCREEN_HEIGHT*13/12+40, 20, 20))
        outerValue.text = "0"
        outerValue.textColor = UIColor.whiteColor()
        
        let EnergyLabel = initLabel(posX: marginX, posY: SCREEN_HEIGHT*14/12, labelWidth: 200, labelHeight: 100, labelText: "能量")
        energyBar = GTSlider(frame: CGRectMake(textX, SCREEN_HEIGHT*14/12+40, lineLength-30, 20))
        energyBar.minimumValue = 0
        energyBar.maximumValue = 10
        energyBar.addTarget(self, action: "barChanged", forControlEvents: UIControlEvents.ValueChanged)
        energyValue = UILabel(frame: CGRectMake(CGRectGetMaxX(energyBar.frame)+10, SCREEN_HEIGHT*14/12+40, 20, 20))
        energyValue.text = "0"
        energyValue.textColor = UIColor.whiteColor()
        
        indicator = UIActivityIndicatorView(frame: CGRectMake(0,0,30,30))
        indicator.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)
        indicator.activityIndicatorViewStyle = .White
        
        self.view.addSubview(indicator)
        

        self.scrollView!.addSubview(buttonProfile!)
        self.scrollView!.addSubview(userNameLabel)
        self.scrollView!.addSubview(dateOfBirthLabel)
        self.scrollView!.addSubview(sexLabel)
        self.scrollView!.addSubview(marriageLabel)
        self.scrollView!.addSubview(emailLabel)
        self.scrollView!.addSubview(hobbyLabel)
        self.scrollView!.addSubview(hobbyLabel)

        self.scrollView!.addSubview(statusLabel)
        self.scrollView!.addSubview(InnerLabel)
        self.scrollView!.addSubview(OuterLabel)
        self.scrollView!.addSubview(EnergyLabel)
        self.scrollView!.addSubview(username)
        self.scrollView!.addSubview(userLine)
        self.scrollView!.addSubview(birthDate)
        self.scrollView!.addSubview(birthLine)
        self.scrollView!.addSubview(feMaleBtn)
        self.scrollView!.addSubview(maleBtn)
        self.scrollView!.addSubview(singleBtn)
        self.scrollView!.addSubview(marriedBtn)
        self.scrollView!.addSubview(emailAddr)
        self.scrollView!.addSubview(hobby)
        self.scrollView!.addSubview(hobbyLine)
        self.scrollView!.addSubview(statusDetail)
        self.scrollView!.addSubview(innerBar)
        self.scrollView!.addSubview(innerValue)
        self.scrollView!.addSubview(outerBar)
        self.scrollView!.addSubview(outerValue)
        self.scrollView!.addSubview(energyBar)
        self.scrollView!.addSubview(energyValue)
        
        self.view.addSubview(button)
        self.view.addSubview(backBtn)
        self.view.addSubview(self.scrollView!)
        
        /*----------- ELCImagePicker Edition -----------*/
        
    }
    
    //textview delegate
    func textViewDidChange(textView: UITextView) {
        if textView.text.isEmpty {
            placeHolder.hidden = false
        }
        else {
            placeHolder.hidden = true
        }
    }
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }

    // text field delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func sexBtnClicked(sender:SettingButton){
        sender.enabled = false
        if(sender.currentTitle == "    女    "){
            feMaleBtn.setImage(feMaleBtn.seletedImage, forState: .Normal)
            feMaleBtn.titleLabel?.alpha = 0.4
            maleBtn.setImage(maleBtn.normalImage, forState: .Normal)
            maleBtn.enabled = true
            maleBtn.titleLabel?.alpha = 1
            gender = 1
        }
        else{
            feMaleBtn.setImage(feMaleBtn.normalImage, forState: .Normal)
            feMaleBtn.titleLabel?.alpha = 1
            maleBtn.setImage(maleBtn.seletedImage, forState: .Normal)
            maleBtn.titleLabel?.alpha = 0.4
            feMaleBtn.enabled = true
            gender = 0
        }
        
    }
    
    func marriageBtnClicked(sender:SettingButton){
        sender.enabled = false
        if(sender.currentTitle == "  单身  "){
            singleBtn.setImage(singleBtn.seletedImage, forState: .Normal)
            singleBtn.titleLabel?.alpha = 0.4
            marriedBtn.setImage(marriedBtn.normalImage, forState: .Normal)
            marriedBtn.enabled = true
            marriedBtn.titleLabel?.alpha = 1
            marriage = 0
        }
        else{
            singleBtn.setImage(singleBtn.normalImage, forState: .Normal)
            singleBtn.titleLabel?.alpha = 1
            marriedBtn.setImage(marriedBtn.seletedImage, forState: .Normal)
            marriedBtn.titleLabel?.alpha = 0.4
            singleBtn.enabled = true
            marriage = 1
        }
    }
    
    func barChanged(){
        innerValue.text = "\(Int(innerBar.value))"
        outerValue.text = "\(Int(outerBar.value))"
        energyValue.text = "\(Int(energyBar.value))"
    }
    
    func initChooseBtn(frame:CGRect,selectedImage:UIImage,normalImage:UIImage,title:String?,action:Selector) -> SettingButton{
        let chooseBtn = SettingButton(frame: frame)
        chooseBtn.seletedImage = selectedImage
        chooseBtn.normalImage = normalImage
        chooseBtn.setImage(chooseBtn.normalImage, forState: .Normal)
        chooseBtn.setTitle(title, forState: .Normal)
        chooseBtn.titleLabel?.font = UIFont.systemFontOfSize(13)
        chooseBtn.addTarget(self, action: action, forControlEvents: .TouchUpInside)
        chooseBtn.adjustsImageWhenDisabled = false
        return chooseBtn
    }
    
    func doneClicked(){
        birthDate.resignFirstResponder()
    }
    
    func dataDidChange(picker : UIDatePicker){
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        birthDate.text = formatter.stringFromDate(picker.date)
    }
    
    // UI Helper Functions
    func initButton(posX posX: CGFloat, posY: CGFloat, btnWidth: CGFloat, btnHeight: CGFloat, imageName: String, targetAction: Selector) -> UIButton{
        
        let result = UIButton(frame: CGRectMake(0, 0, btnWidth, btnHeight))
        result.center = CGPointMake(posX, posY)
        result.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        result.addTarget(self, action: targetAction, forControlEvents: UIControlEvents.TouchUpInside)
        
        return result
    }
    
    func initLabel(posX posX:CGFloat, posY: CGFloat, labelWidth: CGFloat, labelHeight: CGFloat, labelText: String) -> UILabel{
        let resultLabel = UILabel(frame: CGRectMake(posX, posY, labelWidth, labelHeight))
        resultLabel.text = labelText
        resultLabel.font = UIFont(name: FONTNAME_BOLD, size: 16)
        resultLabel.textColor = COLOR_ORANGE
        resultLabel.numberOfLines = 1

        return resultLabel
    }
    
    func initTextFiled(posX posX:CGFloat, posY: CGFloat, width: CGFloat, height: CGFloat)->UITextField{
        let resultTextField = UITextField(frame: CGRectMake(posX, posY, width, height))
        resultTextField.font = UIFont(name: FONTNAME_NORMAL, size: 15)
        return resultTextField
    }
    
    // Resign Active
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func viewBack(){
        self.dismissViewControllerAnimated(true) { () -> Void in
        }
    }
    
    func toRadarPage() {
        
        let sex = maleBtn.enabled || feMaleBtn.enabled
        let marriage = singleBtn.enabled || marriedBtn.enabled
        
        if(username.text!.isEmpty || birthDate.text!.isEmpty || !sex || !marriage) {
            let cancelAction = UIAlertAction(title: "确定", style: .Cancel) { action -> Void in
                self.scrollView.scrollRectToVisible(CGRectMake(0, 0, 100, 100), animated: true)
            }
            
            let emptyAlertController = UIAlertController(title: "请输入必要的信息及头像。", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            self.presentViewController(emptyAlertController, animated: true, completion: nil)
            emptyAlertController.addAction(cancelAction)
            
            return
        }
        
        button.enabled = false
        indicator.startAnimating()
//        let time = NSDate()
//        let format = NSDateFormatter()
//        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        let timeStamp = format.stringFromDate(time)
        let timeStamp = Tools.getSinceTime(NSDate())
        let stringHash = "\(email)\(password)\(UUID)\(timeStamp)\(DEVICE_TOKEN!)\(COMPANYCODE)"
        
        let hashResult = stringHash.sha256()
        let params = [
            "UserID":email,
            "UserPWD":password,
            "DeviceUUID":UUID,
            "lastLogin":timeStamp,
            "DeviceToken":DEVICE_TOKEN!,
            "HashValue":hashResult
        ]
        
        AFJSONManager.SharedInstance.postMethod(Url_Login, parameters: params as! [String : AnyObject], success: { (task, response) -> Void in
            let dict = response as! [String : AnyObject]
            print(dict)
            self.tenLogin = TenLogin(loginDict: dict)
            self.postUser()
            },failure: { (task, error) -> Void in
                print("login Failed")
                print(error.localizedDescription)
        })
    }
    
    func postUser() {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = NSLocale.systemLocale()
        
        let birthday = dateFormatter.dateFromString(birthDate.text!)
        let joinTime = Tools.getSinceTime(NSDate())
        
        let params = [
            "UserName" : username.text!,
            "PhoneType" : 0,
            "Gender" : gender,
            "Marrige" : marriage,
            "Birthday" : birthday!.timeIntervalSince1970,
            "JoinedDate" : joinTime,
            "PCoin" : 0,
            "OuterScore" : Int(outerBar.value),
            "InnerScore" : Int(innerBar.value),
            "Energy" : Int(energyBar.value),
            "Hobby" : hobby.text!,
            "Quote" : statusDetail.text!,
            "Lati" : 0,
            "Longi" : 0
        ]
        
        AFJSONManager.SharedInstance.postMethod(Url_User, parameters: params as! [String : AnyObject], success: { (task, response) -> Void in
            print("postUser")
            print(response)
            let dict = response as! NSDictionary
            SharedUser.changeValue(dict as! [String : AnyObject])
            self.postImage()
            },failure: { (task, error) -> Void in
                print("Post User Failed")
                print(error.localizedDescription)
        })
    }
    
    func postImage() {

        let image = UIImageJPEGRepresentation(chosenImage, 0.75)
//        let image = UIImagePNGRepresentation(chosenImage!)
        if image != nil {
            SHARED_USER.Portrait = image!
            let params : NSDictionary = ["id": SHARED_USER.UserIndex]
            
            AFImageManager.SharedInstance.postHeadImage(Url_UploadHeadImage, image: image!, parameters: params as! [String : AnyObject], success: { (task, response) -> Void in
                print("post Image")
                print(response)
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.putUserIndex()
                })
                },failure: { (task, error) -> Void in
                    print("Post Portrait Failed")
                    print(error.localizedDescription)
            })
        }
    }
    
    
    func putUserIndex(){
        let params = [
            "LoginIndex": tenLogin!.LoginIndex,
            "UserIndex": SHARED_USER.UserIndex,
            "UserID": tenLogin!.UserID,
            "UserPWD": tenLogin!.UserPWD,
            "LastLogin": tenLogin!.LastLogin,
            "DeviceUUID": tenLogin!.DeviceUUID,
            "DeviceToken": tenLogin!.DeviceToken,
            "HashValue": tenLogin!.HashValue
        ]
        
        let putUrl = Url_Login+"/\(tenLogin!.LoginIndex)"
        AFJSONManager.SharedInstance.putMethod(putUrl, parameters: params as! [String : AnyObject], success: { (task, response) -> Void in
            print(response)
            let dict = response as! NSDictionary
            SharedUser.changeValue(dict as! [String : AnyObject])
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                self.button.enabled = true
                self.indicator.stopAnimating()
                NSUserDefaults.standardUserDefaults().setValue(SHARED_USER.UserIndex, forKey: "Logined")
                UserCacheTool().addUserInfoByUser()
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                    let nVC = storyBoard.instantiateViewControllerWithIdentifier("NavController") as! UINavigationController
                    self.presentViewController(nVC, animated: true, completion: { () -> Void in
                    })

                })            })
            },failure:  { (task, error) -> Void in
                print(error.localizedDescription)
        })
    }
    
    func toImagePicker() -> Void {
        SHARED_PICKER.toImagePicker(self)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // TODO: add image into profile
        // chosenImages
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        chosenImage = image
        self.buttonProfile?.setImage(Tools.toCirclurImage(image), forState: UIControlState.Normal)
        self.buttonProfile.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
} // end of the class
