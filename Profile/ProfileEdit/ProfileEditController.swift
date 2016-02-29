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
    
    let lineLength:CGFloat = SCREEN_HEIGHT == 568 ? 150 : 200
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = COLOR_BG
        self.title = ProfileTitle
        chosenImage = UIImage()
        buttonProfile = initButton(posX: SCREEN_WIDTH/2, posY: 104, btnWidth: 140/3*2, btnHeight: 140/3*2, imageName: "user_pic_radar_140", targetAction: "toImagePicker")
        var y = CGRectGetMaxY(buttonProfile.frame)+10
        userName = UILabel(frame: CGRectMake(0,y,SCREEN_WIDTH,20))
        userName.font = UIFont(name: FONTNAME_NORMAL, size: 17)
        userName.textColor = UIColor.whiteColor()
        userName.textAlignment = .Center
        userName.text = "username"
        let margin:CGFloat = 25
        y = CGRectGetMaxY(userName.frame)+50
        
        scroll = UIScrollView(frame: CGRectMake(0,y,SCREEN_WIDTH,SCREEN_HEIGHT - y))
        scroll.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 100)
        scroll.bounces = false
        
        let textX:CGFloat = 145
        
        let birthLabel = initLabel(posX: 15, posY: 5, labelWidth: 100, labelHeight: 20, labelText: "Date of birth")
        birthDate = UILabel(frame:CGRectMake(textX,5,lineLength,20))
        birthDate = initTextLabel(frame: CGRectMake(textX, 5, lineLength, 20),labelText: "4 July 1997 18 Cancer")
        y = CGRectGetMaxY(birthLabel.frame)+margin
        let sexLabel = initLabel(posX: 15, posY: y, labelWidth: 100, labelHeight: 20, labelText: "Sex")
        sex = initTextLabel(frame: CGRectMake(textX, y, lineLength, 20),labelText: "Female")
        y = CGRectGetMaxY(sexLabel.frame)+margin
        let marriageLabel = initLabel(posX: 15, posY: y, labelWidth: 100, labelHeight: 20, labelText: "Marriage")
        singleBtn = initChooseBtn(CGRectMake(textX, y, 55, 20), selectedImage: UIImage(named: "icon_checkbox")!, normalImage: UIImage(named: "icon_checkcircle")!, title: "  Single")
        singleBtn.setImage(singleBtn.seletedImage, forState: .Normal)
        marriedBtn = initChooseBtn(CGRectMake(textX+80, y, 65, 20), selectedImage: UIImage(named: "icon_checkbox")!, normalImage: UIImage(named: "icon_checkcircle")!, title: "  Married")
        y = CGRectGetMaxY(marriageLabel.frame)+margin
        let emailLabel = initLabel(posX: 15, posY: y, labelWidth: 100, labelHeight: 20, labelText: "E-mail")
        emailAddr = initTextLabel(frame: CGRectMake(textX, y, lineLength, 20),labelText: "example@example.com")
        y = CGRectGetMaxY(emailLabel.frame)+margin
        let statusLabel = initLabel(posX: 15, posY: y, labelWidth: 100, labelHeight: 20, labelText: "Status")
        statusDetail = UITextView(frame: CGRectMake(textX, y+5, lineLength, SCREEN_HEIGHT*2/12-10))
        statusDetail.backgroundColor = UIColor(red: 63.0/255.0, green: 63.0/255.0, blue: 64.0/255.0, alpha: 1)
        statusDetail.textColor = UIColor.whiteColor()
        statusDetail.bounces = false
        statusDetail.font = UIFont.systemFontOfSize(15)
        statusDetail.text = "There is so much to.."
        y = CGRectGetMaxY(statusDetail.frame)+margin
        let InnerLabel = initLabel(posX: 15, posY: y, labelWidth: 100, labelHeight: 20, labelText: "Inner")
        InnerValue = initTextLabel(frame: CGRectMake(textX, y, lineLength, 20),labelText: "6")
        y = CGRectGetMaxY(InnerLabel.frame)+margin
        let OuterLabel = initLabel(posX: 15, posY: y, labelWidth: 100, labelHeight: 20, labelText: "Outer")
        OuterValue = initTextLabel(frame: CGRectMake(textX, y, lineLength, 20),labelText: "7")
        y = CGRectGetMaxY(OuterLabel.frame)+margin
        let energyLabel = initLabel(posX: 15, posY: y, labelWidth: 100, labelHeight: 20, labelText: "Energy")
        energyBar = TenSlider(frame: CGRectMake(textX, y, lineLength-30, 20))
        energyBar.minimumValue = 0
        energyBar.maximumValue = 10
        energyBar.addTarget(self, action: "barChanged", forControlEvents: UIControlEvents.ValueChanged)
        energyValue = UILabel(frame: CGRectMake(CGRectGetMaxX(energyBar.frame)+10, y, 20, 20))
        energyValue.text = "0"
        energyValue.textColor = UIColor.whiteColor()
        
        let button = UIButton(frame: CGRectMake(SCREEN_WIDTH-80,20,80,43))
        button.setTitle("完成", forState: .Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(15)
        button.addTarget(self, action: "editDone", forControlEvents: .TouchUpInside)
        
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
        self.scroll.addSubview(button)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {

    }
    
    func editDone(){
        // TODO: what is this?
        print("done")
    }
    
    func barChanged(){
        let value = Int(energyBar.value+1)-1
        energyValue.text = "\(value)"
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
        if(sender.currentTitle == "  Single"){
            singleBtn.setImage(singleBtn.seletedImage, forState: .Normal)
            singleBtn.titleLabel?.alpha = 0.4
            marriedBtn.setImage(marriedBtn.normalImage, forState: .Normal)
            marriedBtn.enabled = true
            marriedBtn.titleLabel?.alpha = 1
        }
        else{
            singleBtn.setImage(singleBtn.normalImage, forState: .Normal)
            singleBtn.titleLabel?.alpha = 1
            marriedBtn.setImage(marriedBtn.seletedImage, forState: .Normal)
            marriedBtn.titleLabel?.alpha = 0.4
            singleBtn.enabled = true
        }
    }
    
    
}
