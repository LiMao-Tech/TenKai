//
//  OtherProfileViewController.swift
//  Ten
//
//  Created by Yumen Cao on 1/4/16.
//  Copyright © 2016 LiMao Tech. All rights reserved.
//

import UIKit

class OtherProfileViewController: ProfileViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
self.navigationController?.navigationBar.hidden = false
        
        let chatBtn = UIBarButtonItem(image: UIImage(named: "btn_navBarIcon_chat_normal"), style: .Plain, target: self, action: "pushChatView")
        self.navigationItem.rightBarButtonItem = chatBtn;

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func pushChatView() -> Void {
        let singleChatVC = SingleChatController()
        self.navigationController?.presentViewController(singleChatVC, animated: true, completion: nil)
    }

}
