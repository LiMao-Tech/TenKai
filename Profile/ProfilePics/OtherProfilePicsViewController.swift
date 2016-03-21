//
//  OtherProfilePicsCollectionViewController.swift
//  Ten
//
//  Created by Yumen Cao on 1/6/16.
//  Copyright © 2016 LiMao Tech. All rights reserved.
//

import UIKit
import SwiftyJSON

private let ProfilePicCellIdentifier = "OtherProPicCell"
private let ProfilePicCellNibName = "OtherProfilePicCollectionViewCell"

private let picUnlockCost: Double = 50

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

    let unlockAlert = UIAlertController(title: "相片解锁", message: "您需要花费 \(picUnlockCost) P币来解锁该等级", preferredStyle: UIAlertControllerStyle.Alert)
    let unlockingAlert = UIAlertController(title: "解锁中", message: "请稍后", preferredStyle: UIAlertControllerStyle.Alert)
    let loadingAlert = UIAlertController(title: "载入中", message: "请稍后", preferredStyle: UIAlertControllerStyle.Alert)

    var unlockId = 0
    var selectedCellIndexPath: NSIndexPath?

    var userId: Int!
    var tenUser: TenUser!

    var pVC: OtherProfileViewController!

    var unlocksJSON = [AnyObject]()


    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.presentViewController(loadingAlert, animated: true, completion: nil)

        let targetUrl = Url_Unlocker + "?owner=\(userId)&unlocker=\(SHARED_USER.UserIndex)"

        ALAMO_MANAGER.request(.GET, targetUrl) .responseJSON {response in

            if let values = response.result.value {

                self.unlocksJSON = (values as? [AnyObject])!
                self.lmCollectionView.reloadData()
                self.loadingAlert.dismissViewControllerAnimated(true, completion: nil)
            }
        }

        let ok = UIAlertAction(title: "解锁", style: UIAlertActionStyle.Destructive, handler: { (ac) -> Void in

            if SHARED_USER.PCoin < picUnlockCost {
                let insufficientAlert = UIAlertController(title: "解锁失败", message: "P币数量不足，请充值后解锁", preferredStyle: .Alert)
                let pay = UIAlertAction(title: "充值", style: .Destructive, handler: { (ac) -> Void in
                    let pVC = PCoinViewController()
                    self.navigationController?.navigationBar.hidden = false
                    self.navigationController?.pushViewController(pVC, animated: true)
                })
                let cancel = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
                insufficientAlert.addAction(pay)
                insufficientAlert.addAction(cancel)
                self.presentViewController(insufficientAlert, animated: true, completion: nil)
            }
            else {
                self.navigationController?.presentViewController(self.unlockingAlert, animated: true, completion: nil)
                let params: [String : AnyObject] =
                [
                    "TenImageID": self.unlockId,
                    "Owner": self.userId,
                    "Unlocker": SHARED_USER.UserIndex,
                    "Pcoin": picUnlockCost,
                    "UnlockTime": NSDate().timeIntervalSince1970
                ]

                ALAMO_MANAGER.request(.POST, Url_Unlocker, parameters: params, encoding: .JSON, headers: nil) .responseJSON {
                    response in



                    if response.result.isSuccess {
                        self.unlocksJSON.append(response.result.value!)
                        SHARED_USER.PCoin -= picUnlockCost
                        let cell = self.lmCollectionView.cellForItemAtIndexPath(self.selectedCellIndexPath!) as! OtherProfilePicCollectionViewCell
                        self.setLockStatus(cell, status: false)
                        self.unlockingAlert.dismissViewControllerAnimated(true, completion: nil)
                    }
                }
            }
        })

        let cancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        unlockAlert.addAction(cancel)
        unlockAlert.addAction(ok)

        //

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
        selectedCellIndexPath = indexPath
        magnifyCellAtIndexPath(indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let jsons = self.imagesJSON {
            return jsons.count
        }
        else {
            return 0
        }
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.lmCollectionView.dequeueReusableCellWithReuseIdentifier(ProfilePicCellIdentifier, forIndexPath: indexPath) as! OtherProfilePicCollectionViewCell

        let obj = self.imagesJSON[indexPath.row]
        let imageJSON = JSON(obj as! [String: AnyObject])

        let imageName = imageJSON["FileName"].stringValue
        let cachedImage = SHARED_IMAGE_CACHE.imageWithIdentifier(imageName)

        unlockId = imageJSON["ID"].intValue

        var unlockedByUser = false
        
        for item in self.unlocksJSON {
            let unlockJSON = JSON(item)
            if unlockJSON["TenImageID"].intValue == self.unlockId {
                unlockedByUser = true
            }

        }

        if let retrivedImage = cachedImage {
            cell.picIV.image = retrivedImage

            if imageJSON["IsLocked"].boolValue == true && !unlockedByUser {
                setLockStatus(cell, status: true)
            }
            else {
                setLockStatus(cell, status: false)
            }
        }
        else {

            let imageIndex = imageJSON["ID"].stringValue
            let targetUrl = Url_Image + imageIndex + "&thumbnail=true"

            ALAMO_MANAGER.request(.GET, targetUrl) .responseImage { response in
                if let image = response.result.value {
                    cell.picIV.image = image

                    SHARED_IMAGE_CACHE.addImage(image, withIdentifier: imageName)
                    if imageJSON["IsLocked"].boolValue == true && !unlockedByUser {
                        self.setLockStatus(cell, status: true)
                    }
                    else {
                        self.setLockStatus(cell, status: false)
                    }
                }
            }
        }

        return cell

    }

    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, blockSizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
        let dim = self.dims[indexPath.row].rawValue
        return CGSizeMake(dim, dim)
    }

    private func magnifyCellAtIndexPath(indexPath: NSIndexPath) {
        if indexPath.row > self.dims.count || self.isProcessing {
            return
        }

        self.isProcessing = true

        var unlockedByUser = false

        let obj = self.imagesJSON[indexPath.row]
        let imageJSON = JSON(obj as! [String: AnyObject])

        unlockId = imageJSON["ID"].intValue

        for item in self.unlocksJSON {
            let unlockJSON = JSON(item)
            if unlockJSON["TenImageID"].intValue == unlockId {
                unlockedByUser = true
            }

        }

        if imageJSON["IsLocked"] == true && !unlockedByUser {
            self.navigationController?.presentViewController(unlockAlert, animated: true, completion: nil)
            self.isProcessing = false
        }
        else {
            let selectedCell = lmCollectionView.cellForItemAtIndexPath(indexPath) as? OtherProfilePicCollectionViewCell
            let cellImage = selectedCell?.picIV.image

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
                    let novaCell = self.lmCollectionView.cellForItemAtIndexPath(indexPath) as? OtherProfilePicCollectionViewCell
                    novaCell?.picIV.image = cellImage
                    self.isProcessing = false
            })
        }
    }

    private func setLockStatus(cell: OtherProfilePicCollectionViewCell, status: Bool) {
        if status {
            cell.picIV.alpha = 0.05
        }
        else {
            cell.picIV.alpha = 1.0
        }

        cell.lockIV.hidden = !status
    }
}
