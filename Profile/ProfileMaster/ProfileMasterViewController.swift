//
//  ProfileMasterViewController.swift
//  Ten
//
//  Created by Yumen Cao on 2/27/16.
//  Copyright © 2016 LiMao Tech. All rights reserved.
//

import UIKit


class ProfileMasterViewController: UIViewController,
                                    UIScrollViewDelegate
{

    @IBOutlet weak var profileSV: UIScrollView!

    

    var userID: Int!
    var imagesJSON: [AnyObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileSV.delegate = self

        let activeFrameHeight = SCREEN_HEIGHT-STATUSBAR_HEIGHT-(self.navigationController?.navigationBar.frame.height)!

        profileSV.contentSize = CGSizeMake(SCREEN_WIDTH, activeFrameHeight*2)

    }

    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.hidden = false

    }

    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBar.translucent = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}
