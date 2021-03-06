//
//  OtherProfileMasterViewController.swift
//  Ten
//
//  Created by Yumen Cao on 2/27/16.
//  Copyright © 2016 LiMao Tech. All rights reserved.
//

import UIKit
import SwiftyJSON

class OtherProfileMasterViewController: ProfileMasterViewController,
                                        ScoreViewDelegate
{
    let pVC = OtherProfileViewController(nibName: "ProfileViewController", bundle: nil)
    let pPCVC = OtherProfilePicsViewController(nibName: "OtherProfilePicsViewController", bundle: nil)

    
    var tenUser: TenUser!
    
    var pushVCType = 0
    
    var scoreView: ScoreView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatBtn.action = #selector(OtherProfileMasterViewController.pushChatView)
        toAlbumBtn.action = #selector(OtherProfileMasterViewController.toAlbum)
        toProfileBtn.action = #selector(OtherProfileMasterViewController.toProfile)
        
        self.navigationItem.rightBarButtonItem = chatBtn;

        let activeFrameHeight = SCREEN_HEIGHT-STATUSBAR_HEIGHT-(self.navigationController?.navigationBar.frame.height)!
        
        // child controller
        pVC.tenUser = tenUser
        pPCVC.tenUser = tenUser
        pPCVC.userId = userID

        pVC.view.frame = CGRectMake(0, 0, profileSV.frame.width, profileSV.frame.height)
        pPCVC.view.frame = CGRectMake(0, activeFrameHeight, profileSV.frame.width, profileSV.frame.height)
        
        pPCVC.pVC = pVC

        addChildViewController(pVC)
        addChildViewController(pPCVC)

        profileSV.addSubview(pVC.view)
        profileSV.addSubview(pPCVC.view)

        getImagesJSON()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // scrollview

    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y < scrollView.contentSize.height/2 {
            self.navigationItem.rightBarButtonItems = [chatBtn, toAlbumBtn]
        }
        else {
            self.navigationItem.rightBarButtonItems = [chatBtn, toProfileBtn]
        }
    }
    

    private func getImagesJSON() {
        let targetUrl = Url_ImagesJSON + String(userID)

        ALAMO_MANAGER.request(.GET, targetUrl) .responseJSON {
            response in
            
            if let values = response.result.value {

                let imagesJSON = (values as? [AnyObject])!
                self.imagesJSON = imagesJSON
                self.pPCVC.imagesJSON = imagesJSON
                self.pPCVC.lmCollectionView.reloadData()

                for obj in self.imagesJSON! {
                    let imageJSON = JSON(obj)

                    if imageJSON["ImageType"].intValue == 0 {
                        self.pVC.image1JSON = imageJSON
                    }

                    if imageJSON["ImageType"].intValue == 3 {
                        self.pVC.numProfilePics = 2
                        self.pVC.image2JSON = imageJSON
                    }

                    if imageJSON["ImageType"].intValue == 4 {
                        self.pVC.numProfilePics = 3
                        self.pVC.image3JSON = imageJSON
                    }
                }

                self.pVC.setScrollView()
                self.pVC.getProfileImages()
                self.pPCVC.dataInit()
            }
        }
    }

    // TODO: tuantuan
    func pushChatView() -> Void {
        if(SHARED_CHATS.outerRaterIndex.contains(tenUser.UserIndex)){
            if(pushVCType == 0){
                let singleChatC = SingleChatController()
                singleChatC.tenUser = tenUser
                self.navigationController?.pushViewController(singleChatC, animated: true)
            }else{
                self.navigationController?.popViewControllerAnimated(true)
            }
            
        }else{
            if(scoreView == nil){
                scoreView = ScoreView()
            }
            scoreView!.tenUser = tenUser
            scoreView!.delegate = self
            self.view.addSubview(scoreView!)
        }
    }
    
    //delegete funcs for scoreView
    func scoreViewOkBtnClicked() {
        let score = Int((scoreView?.scoreSlider.value)!)
        //post new score of the other person
        let params = ["RaterIndex": SHARED_USER.UserIndex,
            "UserIndex": tenUser.UserIndex,
            "OuterScore": score,
            "InnerScore": -1,
            "Energy": -1,
            "Active": false]
        AFJSONManager.SharedInstance.postMethod(Url_Rater, parameters: params as? [String : AnyObject], success: { (task, response) -> Void in
            SHARED_CHATS.outerRaterIndex.append(self.tenUser.UserIndex)
            UserRaterCache().addUserRater(self.tenUser.UserIndex,type: 1)
            self.scoreView!.removeFromSuperview()
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                if(self.pushVCType == 0){
                    let singleChatC = SingleChatController()
                    singleChatC.tenUser = self.tenUser
                    self.navigationController?.pushViewController(singleChatC, animated: true)
                }else{
                    self.navigationController?.popViewControllerAnimated(true)
                }
            })
            },failure: { (task, error) -> Void in
                print("post rater error:")
                print(error.localizedDescription)
                let scoreFailed = UIAlertController(title: "评分失败", message: "请重新尝试评分", preferredStyle: .Alert)
                let failAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Destructive, handler: nil)
                scoreFailed.addAction(failAction)
                self.presentViewController(scoreFailed, animated: true, completion: nil)
        })
    }
    
    func scoreViewCancelBtnClicked() {
        scoreView!.removeFromSuperview()
    }
    
    func scoreViewScoreChange() {
        scoreView!.scoreLabel.text = "\(Int(scoreView!.scoreSlider.value))"
    }

    func toAlbum() {
        self.navigationItem.rightBarButtonItems = [addImageBtn, toProfileBtn]
        self.profileSV.contentOffset = CGPointMake(0, pPCVC.view.frame.origin.y)
    }

    func toProfile() {
        self.navigationItem.rightBarButtonItems = [toSettingsBtn, toAlbumBtn]
        self.profileSV.contentOffset = CGPointMake(0, pVC.view.frame.origin.y)
    }

}
