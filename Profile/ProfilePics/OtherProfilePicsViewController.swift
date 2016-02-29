//
//  OtherProfilePicsCollectionViewController.swift
//  Ten
//
//  Created by Yumen Cao on 1/6/16.
//  Copyright © 2016 LiMao Tech. All rights reserved.
//

import UIKit
import SwiftyJSON

class OtherProfilePicsViewController: ProfilePicsViewController,
                                        LMCollectionViewLayoutDelegate,
                                        UICollectionViewDataSource
{

    @IBOutlet weak var topSeparator: UIImageView!
    @IBOutlet weak var verticalSeparator: UIImageView!

    @IBOutlet weak var levelBarImageView: UIImageView!
    @IBOutlet weak var levelCircleImageView: UIImageView!

    @IBOutlet weak var lmCollectionView: UICollectionView!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!


    let rateAlert = UIAlertView(title: "评分", message: "看过用户的首页。你帮他／她的外表评几分呢？", delegate: nil, cancelButtonTitle: "取消")
    let slider = TenSlider(frame: CGRectMake(20,10,200,20))

    var tenUser: TenUser!

    var pVC: OtherProfileViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // rating
        slider.minimumValue = 1
        slider.maximumValue = 10
        rateAlert.addSubview(slider)
        rateAlert.show()

        lmCollectionView.reloadData()

        
        // register nib
        let cellNib = UINib(nibName: ProfilePicCellNibName, bundle: nil)
        lmCollectionView.registerNib(cellNib, forCellWithReuseIdentifier: ProfilePicCellIdentifier)

        // set delegates
        self.setUpCollectionView(lmCollectionView)
        lmCollectionView.delegate = self
        lmCollectionView.dataSource = self
        let lmLayout = lmCollectionView.collectionViewLayout as? LMCollectionViewLayout
        lmLayout?.delegate = self

        
        
        
        // labels
        nameLabel.text = tenUser.UserName
        ageLabel.text = String(TenTimeManager.SharedInstance.getAge(NSDate(timeIntervalSince1970: tenUser.Birthday)))

        // level colors
        var avg = (tenUser.OuterScore + tenUser.InnerScore)/2
        if avg == 0 {
            avg = 1
        }
        self.levelCircleImageView.image = UIImage(named: "icon_profile_circle_l\(avg)")
        self.levelBarImageView.backgroundColor = LEVEL_COLORS[avg-1]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    // lm collection view
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        magnifyCellAtIndexPath(indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dims.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.lmCollectionView.dequeueReusableCellWithReuseIdentifier(self.ProfilePicCellIdentifier, forIndexPath: indexPath) as! ProfilePicCollectionViewCell

        let obj = self.imagesJSON[indexPath.row]
        let imageJSON = JSON(obj as! [String: AnyObject])

        let imageName = imageJSON["FileName"].stringValue
        let cachedImage = SHARED_IMAGE_CACHE.imageWithIdentifier(imageName)

        if let retrivedImage = cachedImage {
            cell.imageView.image = retrivedImage
        }
        else {
            let imageIndex = imageJSON["ID"].stringValue
            let targetUrl = Url_Image + imageIndex

            ALAMO_MANAGER.request(.GET, targetUrl) .responseImage { response in
                if let image = response.result.value {
                    cell.imageView.image = image
                    SHARED_IMAGE_CACHE.addImage(image, withIdentifier: imageName)
                }
                else {
                    cell.backgroundColor = COLOR_BG
                }
            }
        }

        return cell

    }

    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, blockSizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
        let dim = self.dims[indexPath.row].rawValue
        return CGSizeMake(dim, dim)
    }

    func magnifyCellAtIndexPath(indexPath: NSIndexPath) {
        if indexPath.row > self.dims.count || self.isProcessing {
            return
        }

        self.isProcessing = true

        let selectedCell = lmCollectionView.cellForItemAtIndexPath(indexPath) as? ProfilePicCollectionViewCell
        let cellImage = selectedCell?.imageView.image

        self.lmCollectionView.performBatchUpdates({() in
            if self.dims[indexPath.row] == BlockDim.Std {
                self.dims.removeAtIndex(indexPath.row)
                self.lmCollectionView?.deleteItemsAtIndexPaths([indexPath])

                self.dims.insert(BlockDim.L, atIndex: indexPath.row)
                self.lmCollectionView?.insertItemsAtIndexPaths([indexPath])
            }
            else {
                self.dims.removeAtIndex(indexPath.row)
                self.lmCollectionView?.deleteItemsAtIndexPaths([indexPath])

                self.dims.insert(BlockDim.Std, atIndex: indexPath.row)
                self.lmCollectionView?.insertItemsAtIndexPaths([indexPath])
            }
            },
            completion: {(done) in
                let novaCell = self.lmCollectionView.cellForItemAtIndexPath(indexPath) as? ProfilePicCollectionViewCell
                novaCell?.imageView.image = cellImage
                self.isProcessing = false
        })
    }
}
