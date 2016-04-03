//
//  MyProfilePicsCollectionViewController.swift
//  Ten
//
//  Created by Yumen Cao on 1/6/16.
//  Copyright © 2016 LiMao Tech. All rights reserved.
//

import UIKit
import SwiftyJSON

private enum ProfilePic: Int {
    case First = 1, Second, Third, Fourth
}


private let ProfilePicCellIdentifier = "MyProPicCell"
private let ProfilePicCellNibName = "MyProfilePicCollectionViewCell"


class MyProfilePicsViewController: ProfilePicsViewController,
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
    
    @IBOutlet weak var optionBarBtn: UIBarButtonItem!
    @IBOutlet weak var unlockBarBtn: UIBarButtonItem!
    @IBOutlet weak var lockBarBtn: UIBarButtonItem!
    @IBOutlet weak var deleteBarBtn: UIBarButtonItem!
    
    
    
    @IBAction func optionBarBtn(sender: AnyObject) {
        self.unlockBarBtn.enabled = false
        self.lockBarBtn.enabled = false
        self.deleteBarBtn.enabled = false

        self.lmCollectionView.alpha = 0.5

        presentViewController(picOptionsController, animated: true, completion: nil)
    }

    @IBAction func unlockBarBtn(sender: AnyObject) {
        self.unlockMode = true
        
        self.optionBarBtn.enabled = false
        self.lockBarBtn.enabled = false
        self.deleteBarBtn.enabled = false

        self.lmCollectionView.alpha = 0.5
        
    }
    
    @IBAction func lockBarBtn(sender: AnyObject) {
        self.lockMode = true
        
        self.optionBarBtn.enabled = false
        self.unlockBarBtn.enabled = false
        self.deleteBarBtn.enabled = false
        
        self.lmCollectionView.alpha = 0.5
    }
    
    @IBAction func deleteBarBtn(sender: AnyObject) {
        self.deleteMode = true

        self.optionBarBtn.enabled = false
        self.unlockBarBtn.enabled = false
        self.lockBarBtn.enabled = false

        self.lmCollectionView.alpha = 0.5
    }

    var pVC: MyProfileViewController!

    let transmitController = UIAlertController(title: "设置中", message: "请稍后。", preferredStyle: .Alert)

    let deleteFirstPicErrorController = UIAlertController(title: "不可删除首封面", message: "请先将首封面设为其它图片再尝试", preferredStyle: .Alert)
    let deleteSecondPicErrorController = UIAlertController(title: "不可删除次封面", message: "请先删除第三封面再尝试", preferredStyle: .Alert)
    let setSecondPicErrorController = UIAlertController(title: "不可设置第三封面", message: "请先设置第二封面再尝试", preferredStyle: .Alert)

    let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: { action in
        optionMode = 4
    })

    let picOptionsController = UIAlertController(title: "相册设置", message: "", preferredStyle: .ActionSheet)
    
    let setPic1  = UIAlertAction(title: "选择首封面", style: .Default, handler: { action in
        optionMode = 1
    })

    let setPic2 = UIAlertAction(title: "选择次封面", style: .Default, handler: { action in
        optionMode = 2
    })

    let setPic3  = UIAlertAction(title: "选择第三封面", style: .Default, handler: { action in
        optionMode = 3
    })

    static var optionMode: Int = 0
    var lockMode: Bool = false
    var unlockMode: Bool = false
    var deleteMode: Bool = false
    

    override func viewDidLoad() {
        super.viewDidLoad()


        // image options
        picOptionsController.addAction(setPic1)
        picOptionsController.addAction(setPic2)
        picOptionsController.addAction(setPic3)
//        picOptionsController.addAction(cancelAction)

        deleteFirstPicErrorController.addAction(cancelAction)
        deleteSecondPicErrorController.addAction(cancelAction)
        setSecondPicErrorController.addAction(cancelAction)

        // data initialization
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
        nameLabel.text = SHARED_USER.UserName
        ageLabel.text = String(TenTimeManager.SharedInstance.getAge(NSDate(timeIntervalSince1970:SHARED_USER.Birthday)))
        
        // level colors
        let avg = SHARED_USER.Average
        self.levelCircleImageView.image = UIImage(named: "icon_profile_circle_l\(avg)")
        self.levelBarImageView.backgroundColor = LEVEL_COLORS[avg-1]
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // collection view
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedCell = lmCollectionView.cellForItemAtIndexPath(indexPath) as? MyProfilePicCollectionViewCell
        let imageJSON = JSON(imagesJSON[indexPath.row] as! [String: AnyObject])
        let id = imageJSON["ID"].intValue

        if MyProfilePicsViewController.optionMode > 0 {
            if MyProfilePicsViewController.optionMode < 4 {

                if MyProfilePicsViewController.optionMode == 3 && pVC.image2JSON == nil {
                    presentViewController(setSecondPicErrorController, animated: true, completion: nil)
                }
                else {
                    presentViewController(transmitController, animated: true, completion: nil)
                    setProfileImage(ProfilePic(rawValue: MyProfilePicsViewController.optionMode)!, id: id)
                }
            }
        }
        else if lockMode {
            postLockStatus(selectedCell!, id: id, status: true)
        }

        else if unlockMode {
            postLockStatus(selectedCell!, id: id, status: false)
        }
        else if deleteMode {
            if imageJSON["ImageType"].intValue == 0 {
                presentViewController(deleteFirstPicErrorController, animated: true, completion: nil)
            }
            else if imageJSON["ImageType"].intValue == 3 && self.pVC.image3JSON != nil {
                presentViewController(deleteSecondPicErrorController, animated: true, completion: nil)

            }
            else{
                deleteImage(id, oldJSON: imageJSON)
            }
        }

        else {
            magnifyCellAtIndexPath(indexPath)
        }

        recoverOptionState()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dims.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.lmCollectionView.dequeueReusableCellWithReuseIdentifier(ProfilePicCellIdentifier, forIndexPath: indexPath) as! MyProfilePicCollectionViewCell
        
        let obj = self.imagesJSON[indexPath.row]
        let imageJSON = JSON(obj as! [String: AnyObject])
        
        let imageName = imageJSON["FileName"].stringValue
        let cachedImage = SHARED_IMAGE_CACHE.imageWithIdentifier(imageName)


        if let retrivedImage = cachedImage {
            cell.picIV.image = retrivedImage
            if imageJSON["IsLocked"].boolValue == true {
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

                    if imageJSON["IsLocked"].boolValue == true {
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
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, insetsForItemAtIndexPath indexPath: NSIndexPath!) -> UIEdgeInsets {
        return UIEdgeInsetsMake(1,1,1,1)
    }
    
    func insertAtIndexPath(indexPath: NSIndexPath) {
        if indexPath.row > self.dims.count || self.isProcessing {
            return
        }
        self.isProcessing = true
        
        self.lmCollectionView.performBatchUpdates({() in
            self.numOfPics += 1
            self.dims.insert(BlockDim.Std, atIndex: indexPath.row)
            
            },
            completion: {(done) in
                self.isProcessing = false
        })
    }
    
    func magnifyCellAtIndexPath(indexPath: NSIndexPath) {
        if indexPath.row > self.dims.count || self.isProcessing {
            return
        }
        
        self.isProcessing = true
        
        let selectedCell = lmCollectionView.cellForItemAtIndexPath(indexPath) as? MyProfilePicCollectionViewCell
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
            }        },
        completion: {(done) in
            let novaCell = self.lmCollectionView.cellForItemAtIndexPath(indexPath) as? MyProfilePicCollectionViewCell
            novaCell?.picIV.image = cellImage
            self.isProcessing = false
        })
        
    }
    

    // private helpers

    private func setProfileImage(which: ProfilePic, id: Int) {


        switch which {
        case .First:
            let params = [
                "ID": id,
                "ImageType": 0
            ]
            postProfilePicChange(params)
            break


        case .Second:

            let params = [
                "ID": id,
                "ImageType": 3
            ]
            postProfilePicChange(params)
            break


        case .Third:
            let params = [
                "ID": id,
                "ImageType": 4
            ]
            postProfilePicChange(params)
            break

        default:
            break
        }
    }

    private func postProfilePicChange(params: [String: AnyObject]) {
        ALAMO_MANAGER.request(.POST, Url_SetImage, parameters: params, encoding: .JSON) .responseJSON {
            response in
            if let values = response.result.value {
                self.transmitController.dismissViewControllerAnimated(true, completion: nil)
                let imagesJSON = (values as? [AnyObject])!
                self.imagesJSON = imagesJSON

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

            }
        }
    }

    private func recoverOptionState() {
        MyProfilePicsViewController.optionMode = 0
        unlockMode = false
        lockMode = false
        deleteMode = false
        lmCollectionView.alpha = 1.0


        optionBarBtn.enabled = true
        unlockBarBtn.enabled = true
        lockBarBtn.enabled = true
        deleteBarBtn.enabled = true
    }

    private func postLockStatus(cell: MyProfilePicCollectionViewCell, id: Int, status: Bool ) {
        let params: [String : AnyObject] = [
            "ID": id,
            "IsLocked": status
        ]

        presentViewController(transmitController, animated: true, completion: nil)

        ALAMO_MANAGER.request(.POST, Url_Lock, parameters: params, encoding: .JSON, headers: nil) .responseJSON { response in
            if let values = response.result.value {
                self.setLockStatus(cell, status: status)
                self.transmitController.dismissViewControllerAnimated(true, completion: nil)
                let imagesJSON = (values as? [AnyObject])!
                self.imagesJSON = imagesJSON

            }
            else {
                print("Failed to lock!")
            }
        }
    }

    private func setLockStatus(cell: MyProfilePicCollectionViewCell, status: Bool) {
        if status {
            cell.picIV.alpha = 0.8
        }
        else {
            cell.picIV.alpha = 1.0
        }

        cell.lockIV.hidden = !status
    }

    private func deleteImage(id: Int, oldJSON: JSON) {
        let params = [
            "id": id
        ]
        presentViewController(transmitController, animated: true, completion: nil)
        ALAMO_MANAGER.request(.DELETE, Url_DeletePic, parameters: params, encoding: .JSON) .responseJSON{
            response in

            if let values = response.result.value {

                if oldJSON["ImageType"].intValue == 3 {
                    self.pVC.image2JSON = nil
                }
                else if oldJSON["ImageType"].intValue == 4 {
                    self.pVC.image3JSON = nil
                }

                let imagesJSON = (values as? [AnyObject])!
                self.imagesJSON = imagesJSON
                self.dataInit()
                self.lmCollectionView.reloadData()

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
                self.transmitController.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
}
