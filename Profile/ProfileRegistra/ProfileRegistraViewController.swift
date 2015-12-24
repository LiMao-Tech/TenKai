//
//  RegistProfileViewController.swift
//  Ten
//
//  Created by gt on 15/10/22.
//  Copyright © 2015年 LiMao Tech. All rights reserved.
//

import UIKit
import Alamofire

class RegistProfileViewController: UIViewController,UIAlertViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate{
    
    //property
    var password:String!
    var email:String!
    var tenLogin:TenLogin!
    var tenUser:TenUser!
    var gender:Int?
    var marriage:Int?
    
    // Image Picker Variables
    var chosenImage : UIImage?
    var imageUrl : String?
    var counter : Int?
    
    var picker : UIImagePickerController? = UIImagePickerController()
    
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
    
    var hobby:UITextField!
    
    var statusDetail:UITextView!
    var placeHolder:UILabel!
    
    var innerBar:GTSlider!
    var innerValue:UILabel!
    
    var outerBar:GTSlider!
    var outerValue:UILabel!
    
    var energyBar:GTSlider!
    var energyValue:UILabel!
    
    let lineLength:CGFloat = SCREEN_WIDTH*0.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = BG_COLOR
        self.title = ProfileTitle
        chosenImage = UIImage()
        
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
        
        
        let button = UIButton(frame: CGRectMake(SCREEN_WIDTH-80,20,80,43))
        button.setTitle("完成", forState: .Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(15)
        button.addTarget(self, action: "toRadarPage", forControlEvents: .TouchUpInside)
        
        let backBtn = UIButton(frame: CGRectMake(0,20,80,43))
        backBtn.setTitle("返回", forState: .Normal)
        backBtn.titleLabel?.font = UIFont.systemFontOfSize(15)
        backBtn.addTarget(self, action: "viewBack", forControlEvents: .TouchUpInside)
        
        // init buttons
        buttonProfile = initButton(posX: SCREEN_WIDTH/2, posY: 70, btnWidth: 140/3*2, btnHeight: 140/3*2, imageName: "user_pic_radar_140", targetAction: "toImagePicker")
        let marginX:CGFloat = 35
        
        // init labels
        let basicInfoLabel = initLabel(posX: 15, posY: SCREEN_HEIGHT*2/12, labelWidth: 100, labelHeight: 100, labelText: "Basic Info")
        let userNameLabel = initLabel(posX: marginX, posY: SCREEN_HEIGHT*3/12, labelWidth: 100, labelHeight: 100, labelText: "Username")
        let textX = CGRectGetMaxX(userNameLabel.frame) + 20
        
        username = UITextField(frame: CGRectMake(textX,SCREEN_HEIGHT*3/12+40, lineLength, 20))
        username.textColor = UIColor.whiteColor()
        username.font = UIFont(name: FONTNAME_NORMAL, size: 15)
        
        let userLine = UIView(frame: CGRectMake(textX, CGRectGetMaxY(username.frame)+2, lineLength, 1))
        userLine.backgroundColor = UIColor.whiteColor()
        
        let dateOfBirthLabel = initLabel(posX: marginX, posY: SCREEN_HEIGHT*4/12, labelWidth: 100, labelHeight: 100, labelText: "Date of Birth*")
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
        let sexLabel = initLabel(posX: marginX, posY: SCREEN_HEIGHT*5/12, labelWidth: 200, labelHeight: 100, labelText: "Sex*")
        
        feMaleBtn = initChooseBtn(CGRectMake(textX, SCREEN_HEIGHT*5/12+40, 62, 20), selectedImage: UIImage(named: "icon_checkbox")!, normalImage: UIImage(named: "icon_checkcircle")!, title: "  Female", action: "sexBtnClicked:")
        maleBtn = initChooseBtn(CGRectMake(textX+80, SCREEN_HEIGHT*5/12+40, 50, 20), selectedImage: UIImage(named: "icon_checkbox")!, normalImage: UIImage(named: "icon_checkcircle")!, title: "  Male", action: "sexBtnClicked:")
        let marriageLabel = initLabel(posX: marginX, posY: SCREEN_HEIGHT*6/12, labelWidth: 200, labelHeight: 100, labelText: "Marriage")
        singleBtn = initChooseBtn(CGRectMake(textX, SCREEN_HEIGHT*6/12+40, 55, 20), selectedImage: UIImage(named: "icon_checkbox")!, normalImage: UIImage(named: "icon_checkcircle")!, title: "  Single", action: "marriageBtnClicked:")
        marriedBtn = initChooseBtn(CGRectMake(textX+80, SCREEN_HEIGHT*6/12+40, 65, 20), selectedImage: UIImage(named: "icon_checkbox")!, normalImage: UIImage(named: "icon_checkcircle")!, title: "  Married", action: "marriageBtnClicked:")
        
        // Email Label
        let emailLabel = initLabel(posX: marginX, posY: SCREEN_HEIGHT*7/12, labelWidth: 200, labelHeight: 100, labelText: "Email")
        emailAddr = UILabel(frame: CGRectMake(textX, SCREEN_HEIGHT*7/12+40, lineLength, 20))
        emailAddr.textColor = UIColor(red: 137.0/255.0, green: 142.0/255.0, blue: 153.0/255.0, alpha: 1.0)
        emailAddr.font = UIFont(name: FONTNAME_NORMAL, size: 15)
        emailAddr.text = email
        
        // Hobby Label
        let hobbyLabel = initLabel(posX: marginX, posY: SCREEN_HEIGHT*8/12, labelWidth: 200, labelHeight: 100, labelText: "Hobby")
        hobby = UITextField(frame: CGRectMake(textX, SCREEN_HEIGHT*8/12+40, lineLength, 20))
        hobby.textColor = UIColor.whiteColor()
        hobby.font = UIFont(name: FONTNAME_NORMAL, size: 15)
        hobby.placeholder = "e.g. Music"
        hobby.setValue(WHITEGRAY_COLOR, forKeyPath: "_placeholderLabel.textColor")

        let hobbyLine = UIView(frame: CGRectMake(textX, CGRectGetMaxY(hobby.frame)+2, lineLength, 1))
        hobbyLine.backgroundColor = UIColor.whiteColor()
        let moreDetailLabel = initLabel(posX: 15, posY: SCREEN_HEIGHT*9/12, labelWidth: 200, labelHeight: 100, labelText: "More Details")
        
        // Status Label
        let statusLabel = initLabel(posX: marginX, posY: SCREEN_HEIGHT*10/12, labelWidth: 200, labelHeight: 100, labelText: "Status")
        statusDetail = UITextView(frame: CGRectMake(textX, SCREEN_HEIGHT*10/12+40, lineLength, SCREEN_HEIGHT*2/12-10))
        statusDetail.backgroundColor = UIColor.blackColor()
        statusDetail.textColor = UIColor.whiteColor()
        statusDetail.bounces = false
        statusDetail.font = UIFont.systemFontOfSize(15)
        statusDetail.delegate = self
        placeHolder = UILabel(frame: CGRectMake(5, 5, lineLength-5, 20))
        placeHolder.text = "There is so much to.."
        placeHolder.textColor = WHITEGRAY_COLOR
        placeHolder.font = UIFont.systemFontOfSize(15)
        self.statusDetail.addSubview(placeHolder)
        
        // Inner Label
        let InnerLabel = initLabel(posX: marginX, posY: SCREEN_HEIGHT*12/12, labelWidth: 200, labelHeight: 100, labelText: "Inner")
        innerBar = GTSlider(frame: CGRectMake(textX, SCREEN_HEIGHT*12/12+40, lineLength-30, 20))
        innerBar.minimumValue = 0
        innerBar.maximumValue = 10
        innerBar.addTarget(self, action: "barChanged", forControlEvents: UIControlEvents.ValueChanged)
        innerValue = UILabel(frame: CGRectMake(CGRectGetMaxX(innerBar.frame)+10, SCREEN_HEIGHT*12/12+40, 20, 20))
        innerValue.text = "0"
        innerValue.textColor = UIColor.whiteColor()
        
        let OuterLabel = initLabel(posX: marginX, posY: SCREEN_HEIGHT*13/12, labelWidth: 200, labelHeight: 100, labelText: "Outer")
        outerBar = GTSlider(frame: CGRectMake(textX, SCREEN_HEIGHT*13/12+40, lineLength-30, 20))
        outerBar.minimumValue = 0
        outerBar.maximumValue = 10
        outerBar.addTarget(self, action: "barChanged", forControlEvents: UIControlEvents.ValueChanged)
        outerValue = UILabel(frame: CGRectMake(CGRectGetMaxX(outerBar.frame)+10, SCREEN_HEIGHT*13/12+40, 20, 20))
        outerValue.text = "0"
        outerValue.textColor = UIColor.whiteColor()
        
        let EnergyLabel = initLabel(posX: marginX, posY: SCREEN_HEIGHT*14/12, labelWidth: 200, labelHeight: 100, labelText: "Energy")
        energyBar = GTSlider(frame: CGRectMake(textX, SCREEN_HEIGHT*14/12+40, lineLength-30, 20))
        energyBar.minimumValue = 0
        energyBar.maximumValue = 10
        energyBar.addTarget(self, action: "barChanged", forControlEvents: UIControlEvents.ValueChanged)
        energyValue = UILabel(frame: CGRectMake(CGRectGetMaxX(energyBar.frame)+10, SCREEN_HEIGHT*14/12+40, 20, 20))
        energyValue.text = "0"
        energyValue.textColor = UIColor.whiteColor()

        self.scrollView!.addSubview(buttonProfile!)
        self.scrollView!.addSubview(basicInfoLabel)
        self.scrollView!.addSubview(userNameLabel)
        self.scrollView!.addSubview(dateOfBirthLabel)
        self.scrollView!.addSubview(sexLabel)
        self.scrollView!.addSubview(marriageLabel)
        self.scrollView!.addSubview(emailLabel)
        self.scrollView!.addSubview(hobbyLabel)
        self.scrollView!.addSubview(hobbyLabel)
        self.scrollView!.addSubview(moreDetailLabel)
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
    
    //textviewdelegate
    func textViewDidChange(textView: UITextView) {
        if(textView.text.isEmpty){
            placeHolder.hidden = false
        }else{
            placeHolder.hidden = true
        }
    }
    
    func sexBtnClicked(sender:SettingButton){
        sender.enabled = false
        if(sender.currentTitle == "  Female"){
            feMaleBtn.setImage(feMaleBtn.seletedImage, forState: .Normal)
            feMaleBtn.titleLabel?.alpha = 0.4
            maleBtn.setImage(maleBtn.normalImage, forState: .Normal)
            maleBtn.enabled = true
            maleBtn.titleLabel?.alpha = 1
            gender = 0
        }
        else{
            feMaleBtn.setImage(feMaleBtn.normalImage, forState: .Normal)
            feMaleBtn.titleLabel?.alpha = 1
            maleBtn.setImage(maleBtn.seletedImage, forState: .Normal)
            maleBtn.titleLabel?.alpha = 0.4
            feMaleBtn.enabled = true
            gender = 1
        }
        
    }
    
    func marriageBtnClicked(sender:SettingButton){
        sender.enabled = false
        if(sender.currentTitle == "  Single"){
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
        
        /*UIButton(frame: CGRectMake(0, 0, 110, 110))
        buttonProfile.center = CGPointMake(self.scrollView!.frame.width/2, self.scrollView!.frame.height/5)
        buttonProfile.setImage(UIImage(named: "user_pic_110"), forState: UIControlState.Normal)
        buttonProfile.addTarget(self, action: "toImagePicker", forControlEvents: UIControlEvents.TouchUpInside)*/
        
        let result = UIButton(frame: CGRectMake(0, 0, btnWidth, btnHeight))
        result.center = CGPointMake(posX, posY)
        result.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        result.addTarget(self, action: targetAction, forControlEvents: UIControlEvents.TouchUpInside)
        
        return result
    }
    
    func initLabel(posX posX:CGFloat, posY: CGFloat, labelWidth: CGFloat, labelHeight: CGFloat, labelText: String) -> UILabel{
        
        /*
        UILabel(frame: CGRectMake(scrowViewWidth/10, scrowViewHeight*3/10, 200, 100))
        basicInfoLabel.text = "Basic Info"
        basicInfoLabel.font = UIFont(name: "Arial-Bold", size: 20)
        basicInfoLabel.textColor = UIColor.redColor()
        basicInfoLabel.numberOfLines = 1;
        //print("\(scrowViewWidth/8) and \(scrowViewHeight*3/10)")*/
        
        let resultLabel = UILabel(frame: CGRectMake(posX, posY, labelWidth, labelHeight))
        resultLabel.text = labelText
        resultLabel.font = UIFont(name: FONTNAME_BOLD, size: 16)
        resultLabel.textColor = ORANGE_COLOR
        resultLabel.numberOfLines = 1;
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
    
    func toRadarPage(){

        let time = NSDate()
        let format = NSDateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timeStamp = format.stringFromDate(time)
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
        
        ALAMO_MANAGER.request(.POST, LoginUrl, parameters: params, encoding: .JSON) .responseJSON {
            response in
            if response.result.isSuccess {

                print("To radar Page")
                print(response.result.value)
                
                let dict = response.result.value as! [String : AnyObject]
                self.tenLogin = TenLogin(loginDict: dict)
                self.postUser()
            }
            else {
                print("Registration Failed.")
            }
        }
    }
    
    func postUser(){
        
        let birthday = birthDate.text!
        let joinTime = Tools.getNormalTime(NSDate())
        
        let params = [
            "UserName" : username.text!,
            "PhoneType" : 0,
            "Gender" : gender!,
            "Marrige" : "0",
            "Birthday" : birthday,
            "JoinedDate" : joinTime,
            "PCoin" : "0",
            "OuterScore" : Int(outerBar.value),
            "InnerScore" : Int(innerBar.value),
            "Energy" : Int(energyBar.value),
            "Hobby" : hobby.text!,
            "Quote" : statusDetail.text!,
            "Lati" : 0,
            "Longi" : 0
        ]
        
        ALAMO_MANAGER.request(.POST, UserUrl, parameters: (params as! [String : AnyObject]), encoding: .JSON) .responseJSON {
            response in
            if response.result.isSuccess {

                print("postUser")
                print(response.result.value)
                
                let dict = response.result.value as! [String : AnyObject]
                self.tenUser = TenUser(loginDict: dict)
                self.postImage()
            }
            else {
                print("Post User Failed")
            }
        }
    }
    
    func postImage() {

//        let image = UIImageJPEGRepresentation(chosenImage!, 0.3)
        let image = UIImagePNGRepresentation(chosenImage!)
        
        // How did you know it is jpeg?
        let picName = Tools.getFileNameTime(NSDate())+".png"
        let params : NSDictionary = ["id": tenUser.UserIndex]
        
        
        ALAMO_MANAGER.upload(.POST, HeadImageUrl,headers: nil, multipartFormData: {multipartFormData -> Void in
                multipartFormData.appendBodyPart(data: image!, name: "upload", fileName: picName, mimeType: "image/png")
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(request: let upload, _, _):
                    upload.response {
                        response in
                        print("postImage")
                        print(response.1)
                        
//                        self.putUserIndex()
                    }
                    
                case .Failure(let encodingError):
                    print("Failed to post Image")
                    print(encodingError)
                }
        })
    }
    
    
    func putUserIndex(){
        let params : [String : String] = [
            "LoginIndex": String(tenLogin.LoginIndex),
            "UserIndex": String(tenUser.UserIndex),
            "UserID": tenLogin.UserID,
            "UserPWD": tenLogin.UserPWD,
            "LastLogin": tenLogin.LastLogin,
            "DeviceUUID": tenLogin.DeviceUUID,
            "DeviceToken": tenLogin.DeviceToken,
            "HashValue": tenLogin.HashValue
        ]
        
        let putUrl = LoginUrl+"/\(tenLogin.LoginIndex)"

        Alamofire.request(.PUT, putUrl, parameters: params) .responseJSON {
            response in
            
            print("postUserIndex")
            print(response.result.value)
            
            let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let nVC = storyBoard.instantiateViewControllerWithIdentifier("NavController")
            self.presentViewController(nVC, animated: true, completion: { () -> Void in
            })
        }
    }
    
    // MARK: Entering the image picker
    func toImagePicker(){
        //
        print("going to do imagepicker here")
        
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                self.openCamera()
                
        }
        let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel)
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
        self.buttonProfile?.setImage(image, forState: UIControlState.Normal)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
} // end of the class
