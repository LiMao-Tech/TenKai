//
//  OtherProfilePicsCollectionViewController.swift
//  Ten
//
//  Created by Yumen Cao on 1/6/16.
//  Copyright © 2016 LiMao Tech. All rights reserved.
//

import UIKit

class OtherProfilePicsViewController: ProfilePicsViewController {

    var userID: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let chatBtn = UIBarButtonItem(image: UIImage(named: "btn_navBarIcon_chat_normal"), style: .Plain, target: self, action: "pushChatView")
        self.navigationItem.rightBarButtonItem = chatBtn;
        


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // TODO: tuantuan 
    func pushChatView() -> Void {
    
    }
    

}
