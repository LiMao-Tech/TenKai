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

    let addImageBtn = UIBarButtonItem()
    let toAlbumBtn = UIBarButtonItem()
    let toSettingsBtn = UIBarButtonItem()
    let toProfileBtn = UIBarButtonItem()
    let chatBtn = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileSV.delegate = self

        let activeFrameHeight = SCREEN_HEIGHT-STATUSBAR_HEIGHT-(self.navigationController?.navigationBar.frame.height)!

        profileSV.contentSize = CGSizeMake(SCREEN_WIDTH, activeFrameHeight*2)

        // navigation
        addImageBtn.image = UIImage(named: "plussign")
        addImageBtn.style = .Plain
        addImageBtn.target = self


        toAlbumBtn.image = UIImage(named: "album")
        toAlbumBtn.style = .Plain
        toAlbumBtn.target = self

        toSettingsBtn.image = UIImage(named: "gear")
        toSettingsBtn.style = .Plain
        toSettingsBtn.target = self

        toProfileBtn.image = UIImage(named: "navBar_profile")
        toProfileBtn.style = .Plain
        toProfileBtn.target = self

        chatBtn.image = UIImage(named: "btn_navBarIcon_chat_normal")
        chatBtn.style = .Plain
        chatBtn.target = self

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
