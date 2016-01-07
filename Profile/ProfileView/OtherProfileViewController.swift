//
//  OtherProfileViewController.swift
//  Ten
//
//  Created by Yumen Cao on 1/4/16.
//  Copyright © 2016 LiMao Tech. All rights reserved.
//

import UIKit

class OtherProfileViewController: ProfileViewController {
    
    var outerBar:GTSlider!
    var outerValue:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        outerBar = GTSlider(frame: CGRectMake(SCREEN_WIDTH/5, SCREEN_HEIGHT*11/12, SCREEN_WIDTH/2, SCREEN_HEIGHT/12))
        
        outerBar.minimumValue = MinBarValue
        outerBar.maximumValue = MaxBarValue
        
        outerBar.addTarget(self, action: "outerBarChanged", forControlEvents: UIControlEvents.ValueChanged)
        
        outerValue = UILabel(frame: CGRectMake(SCREEN_WIDTH*4/5, SCREEN_HEIGHT*11/12, SCREEN_WIDTH/2, SCREEN_HEIGHT/12))
        outerValue.text = "0"
        outerValue.textColor = UIColor.whiteColor()
        
        let chatBtn = UIBarButtonItem(image: UIImage(named: "btn_navBarIcon_chat_normal"), style: .Plain, target: self, action: "pushChatView")
        self.navigationItem.rightBarButtonItem = chatBtn;

        self.view.addSubview(outerBar)
        self.view.addSubview(outerValue)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func pushChatView() -> Void {
        let singleChatVC = SingleChatController()
        self.navigationController?.presentViewController(singleChatVC, animated: true, completion: nil)
    }
    
    func outerBarChanged(){
        outerValue.text = "\(Int(outerBar.value))"
    }
    
    
    override func pushPictureCollectionView() {
        let pPCVC = MyProfilePicsCollectionViewController(height: SCREEN_HEIGHT, width: SCREEN_WIDTH, toolbarHeight: TOOL_BAR_HEIGHT)

        self.navigationController?.pushViewController(pPCVC, animated: true)
        print("Pushed")
    }
}
