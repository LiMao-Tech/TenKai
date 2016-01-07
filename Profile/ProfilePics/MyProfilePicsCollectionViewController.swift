//
//  MyProfilePicsCollectionViewController.swift
//  Ten
//
//  Created by Yumen Cao on 1/6/16.
//  Copyright © 2016 LiMao Tech. All rights reserved.
//

import UIKit

class MyProfilePicsCollectionViewController: ProfilePicsCollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // add Image Button
        let addImageBtn = UIBarButtonItem(title: "新增", style: .Plain, target: self, action: "addImage")
        
        self.navigationItem.rightBarButtonItem = addImageBtn;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func addImage() ->Void {
        
    }

}
