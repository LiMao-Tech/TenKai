//
//  RegistProfileViewController.swift
//  Ten
//
//  Created by gt on 15/10/22.
//  Copyright © 2015年 LiMao Tech. All rights reserved.
//

import UIKit
import AFNetworking
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
    
    //var ELCpicker : ELCImagePickerController? = ELCImagePickerController()
    var picker : UIImagePickerController? = UIImagePickerController()
    
    // scrollView Variables
    var scrollView: UIScrollView!
    
    var username:UITextField!
    
    var birthData:UITextField!
    
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
        birthData = UITextField(frame: CGRectMake(textX, SCREEN_HEIGHT*4/12+40, lineLength, 20))
        birthData.textColor = UIColor.whiteColor()
        birthData.font = UIFont(name: FONTNAME_NORMAL, size: 15)
        
        let picker = UIDatePicker()
        picker.datePickerMode = .Date
        picker.addTarget(self, action: "dataDidChange:", forControlEvents: .ValueChanged)
        birthData.inputView = picker
        
        let accessoryView = UIToolbar(frame: CGRectMake(0, 0, SCREEN_WIDTH, 35))
        let doneBtn = UIBarButtonItem(title: "完成", style: .Done, target: self, action: "doneClicked")
        let space = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        accessoryView.setItems([space,doneBtn], animated: true)
        birthData.inputAccessoryView = accessoryView
        let birthLine = UIView(frame: CGRectMake(textX, CGRectGetMaxY(birthData.frame)+2, lineLength, 1))
        birthLine.backgroundColor = UIColor.whiteColor()
        let sexLabel = initLabel(posX: marginX, posY: SCREEN_HEIGHT*5/12, labelWidth: 200, labelHeight: 100, labelText: "Sex*")
        feMaleBtn = initChooseBtn(CGRectMake(textX, SCREEN_HEIGHT*5/12+40, 62, 20), selectedImage: UIImage(named: "icon_checkbox")!, normalImage: UIImage(named: "icon_checkcircle")!, title: "  Female", action: "sexBtnClicked:")
        maleBtn = initChooseBtn(CGRectMake(textX+80, SCREEN_HEIGHT*5/12+40, 50, 20), selectedImage: UIImage(named: "icon_checkbox")!, normalImage: UIImage(named: "icon_checkcircle")!, title: "  Male", action: "sexBtnClicked:")
        let marriageLabel = initLabel(posX: marginX, posY: SCREEN_HEIGHT*6/12, labelWidth: 200, labelHeight: 100, labelText: "Marriage")
        singleBtn = initChooseBtn(CGRectMake(textX, SCREEN_HEIGHT*6/12+40, 55, 20), selectedImage: UIImage(named: "icon_checkbox")!, normalImage: UIImage(named: "icon_checkcircle")!, title: "  Single", action: "marriageBtnClicked:")
        marriedBtn = initChooseBtn(CGRectMake(textX+80, SCREEN_HEIGHT*6/12+40, 65, 20), selectedImage: UIImage(named: "icon_checkbox")!, normalImage: UIImage(named: "icon_checkcircle")!, title: "  Married", action: "marriageBtnClicked:")
        let emailLabel = initLabel(posX: marginX, posY: SCREEN_HEIGHT*7/12, labelWidth: 200, labelHeight: 100, labelText: "Email")
        emailAddr = UILabel(frame: CGRectMake(textX, SCREEN_HEIGHT*7/12+40, lineLength, 20))
        emailAddr.textColor = UIColor(red: 137.0/255.0, green: 142.0/255.0, blue: 153.0/255.0, alpha: 1.0)
        emailAddr.font = UIFont(name: FONTNAME_NORMAL, size: 15)
        emailAddr.text = email
        let hobbyLabel = initLabel(posX: marginX, posY: SCREEN_HEIGHT*8/12, labelWidth: 200, labelHeight: 100, labelText: "Hobby")
        hobby = UITextField(frame: CGRectMake(textX, SCREEN_HEIGHT*8/12+40, lineLength, 20))
        hobby.textColor = UIColor.whiteColor()
        hobby.font = UIFont(name: FONTNAME_NORMAL, size: 15)
        hobby.placeholder = "e.g. Music"
        hobby.setValue(WHITEGRAY_COLOR, forKeyPath: "_placeholderLabel.textColor")
        let hobbyLine = UIView(frame: CGRectMake(textX, CGRectGetMaxY(hobby.frame)+2, lineLength, 1))
        hobbyLine.backgroundColor = UIColor.whiteColor()
        let moreDetailLabel = initLabel(posX: 15, posY: SCREEN_HEIGHT*9/12, labelWidth: 200, labelHeight: 100, labelText: "More Details")
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
        self.scrollView!.addSubview(birthData)
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
    
    override func viewWillAppear(animated: Bool) {
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named:"navBar_profile"), forBarMetrics: .Default)
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
        birthData.resignFirstResponder()
    }
    
    func dataDidChange(sender:UIDatePicker){
        birthData.text = sender.date.description
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
        
        /*UILabel(frame: CGRectMake(scrowViewWidth/10, scrowViewHeight*3/10, 200, 100))
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewBack(){
        self.dismissViewControllerAnimated(true) { () -> Void in
        }
    }
    
    func toRadarPage(){
        let manager = AFHTTPRequestOperationManager()
        let time = NSDate()
        let format = NSDateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timeStamp = format.stringFromDate(time)
        let stringHash = "\(email)\(password)\(UUID)\(timeStamp)\(DEVICE_TOKEN!)\(COMPANYCODE)"
        let hashResult = stringHash.sha256()
        let params = ["UserID":email,"UserPWD":password,"DeviceUUID":UUID,"lastLogin":timeStamp,"DeviceToken":DEVICE_TOKEN!,"HashValue":hashResult]
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        
        manager.POST( LoginUrl,
            parameters: params,
            success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                let dict = responseObject as! [String : AnyObject]
                self.tenLogin = TenLogin(loginDict: dict)
                print(self.tenLogin.LoginIndex)
                print("loginpostSuccess")
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.postUsers()
                })
            },
            failure: { (operation,error) in
                print("Error: " + error.localizedDescription)
                let data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as! NSData
                print(NSString(data: data, encoding: NSUTF8StringEncoding))
                
        })
    }
    func postUsers(){
        let manager = AFHTTPRequestOperationManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        
        let birthday = Tools.formatStringTime(birthData.text!)
        let joinTime = Tools.getNormalTime(NSDate())
        
        let params = ["UserName":username.text!,"Gender":gender!,"Birthday":birthday,"JoinedDate":joinTime,"PCoin":0,"OuterScore":Int(outerBar.value),"InnerScore":Int(innerBar.value),"Energy":Int(energyBar.value),"Hobby":hobby.text!,"Quote":statusDetail.text!,"Lati":0,"Longi":0]
//        print("userParams:\(params)")
        manager.POST(UserUrl, parameters: params, success: { (operation, responseObject) -> Void in
            print(responseObject)
            let dict = responseObject as! [String : AnyObject]
            self.tenUser = TenUser.init(loginDict: dict)
            print (self.tenUser.Birthday)
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                self.postImage()
            })
            },
            failure: { (operation, error) -> Void in
                print("postUserError:"+error.localizedDescription)
        })
    }
    
    func postImage(){
        let manager = AFHTTPRequestOperationManager()
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        
        let image = UIImageJPEGRepresentation(chosenImage!, 0.5)
        let picName = Tools.getFileNameTime(NSDate())+".jpeg"
        let params = ["id":tenUser.UserIndex]
        
        manager.POST(HeadImageUrl, parameters: params, constructingBodyWithBlock: { (data: AFMultipartFormData!) -> Void in
            data.appendPartWithFileData(image!, name: "upload", fileName: picName, mimeType: "image/jpeg")
            }, success: { (operation, responseObject) -> Void in
            let str = NSString(data: responseObject as! NSData, encoding: NSUTF8StringEncoding)
            print(str)
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                self.putUserIndex()
                //push note
            })
            },
                failure: { (operation, error) -> Void in
                print("imageUpLoadError:"+error.localizedDescription)
            })
        }

    func putUserIndex(){
        Alamofire.request(.PUT, LoginUrl+"/\(tenLogin.LoginIndex)", parameters: ["LoginIndex": tenLogin.LoginIndex,"UserIndex": tenUser.UserIndex,"UserID": tenLogin.UserID,"UserPWD": tenLogin.UserPWD,"LastLogin": tenLogin.LastLogin,"DeviceUUID": tenLogin.DeviceUUID,"DeviceToken": tenLogin.DeviceToken,"HashValue": tenLogin.HashValue]).response { (response) -> Void in
            let data = NSString(data: response.2!, encoding: NSUTF8StringEncoding)
            print(data)
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
        
        // Add the actions
        
        //ELCpicker?.imagePickerDelegate = self
        //ELCpicker?.maximumImagesCount = 1 //TODO: Tuantuan, this is where you can change the number of image you want to select
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
    
    
}// end of the class
