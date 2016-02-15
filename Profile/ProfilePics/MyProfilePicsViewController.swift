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
    case First = 1, Second, Third
}


class MyProfilePicsViewController: ProfilePicsViewController,
                                    LMCollectionViewLayoutDelegate,
                                    UICollectionViewDataSource,
                                    UINavigationControllerDelegate,
                                    UIImagePickerControllerDelegate
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

    let transmitController = UIAlertController(title: "设置中", message: "请稍后。", preferredStyle: .Alert)

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

    var image1JSON: JSON?
    var image2JSON: JSON?
    var image3JSON: JSON?

    
    override func viewDidLoad() {
        super.viewDidLoad()


        // image options
        picOptionsController.addAction(setPic1)
        picOptionsController.addAction(setPic2)
        picOptionsController.addAction(setPic3)

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
        SHARED_PICKER.picker.delegate = self
        
        // add buttons
        let addImageBtn = UIBarButtonItem(title: "新增", style: .Plain, target: self, action: "addImage")
        self.navigationItem.rightBarButtonItem = addImageBtn
        
        // labels
        nameLabel.text = SHARED_USER.UserName
        ageLabel.text = String(TenTimeManager.SharedInstance.getAge(NSDate(timeIntervalSince1970:SHARED_USER.Birthday)))
        
        // level colors
        var avg = Int(ceil((Double(SHARED_USER.OuterScore) + Double(SHARED_USER.InnerScore))/2))
        if avg == 0 {
            avg = 1
        }
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
        let selectedCell = lmCollectionView.cellForItemAtIndexPath(indexPath) as? ProfilePicCollectionViewCell
        let imageJSON = JSON(imagesJSON[indexPath.row] as! [String: AnyObject])
        let id = imageJSON["ID"].intValue

        if MyProfilePicsViewController.optionMode > 0 {
            presentViewController(transmitController, animated: true, completion: nil)
            setProfileImage(ProfilePic(rawValue: MyProfilePicsViewController.optionMode)!, id: id)

        }
        else if lockMode {
            postLockStatus(selectedCell!, id: id, status: true)
        }

        else if unlockMode {
            postLockStatus(selectedCell!, id: id, status: false)
        }
        else if deleteMode {
            deleteImage(id)
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
        let cell = self.lmCollectionView.dequeueReusableCellWithReuseIdentifier(self.ProfilePicCellIdentifier, forIndexPath: indexPath) as! ProfilePicCollectionViewCell
        
        let obj = self.imagesJSON[indexPath.row]
        let imageJSON = JSON(obj as! [String: AnyObject])
        
        let imageName = imageJSON["FileName"].stringValue
        let cachedImage = SHARED_IMAGE_CACHE.imageWithIdentifier(imageName)


        if let retrivedImage = cachedImage {
            cell.imageView.image = retrivedImage
            if imageJSON["IsLocked"].boolValue == true {
                setLockStatus(cell, status: true)
            }
        }
        else {
            let imageIndex = imageJSON["ID"].stringValue
            let targetUrl = Url_Image + imageIndex
            
            ALAMO_MANAGER.request(.GET, targetUrl) .responseImage { response in
                if let image = response.result.value {
                    cell.imageView.image = image
                    SHARED_IMAGE_CACHE.addImage(image, withIdentifier: imageName)
                    if imageJSON["IsLocked"].boolValue == true {
                        self.setLockStatus(cell, status: true)
                    }
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
        
        let selectedCell = lmCollectionView.cellForItemAtIndexPath(indexPath) as? ProfilePicCollectionViewCell
        let cellImage = selectedCell?.imageView.image
        
        self.lmCollectionView.performBatchUpdates({() in
            self.dims.removeAtIndex(indexPath.row)
            self.lmCollectionView?.deleteItemsAtIndexPaths([indexPath])
            
            self.dims.insert(BlockDim.L, atIndex: indexPath.row)
            self.lmCollectionView?.insertItemsAtIndexPaths([indexPath])
        },
        completion: {(done) in
            let novaCell = self.lmCollectionView.cellForItemAtIndexPath(indexPath) as? ProfilePicCollectionViewCell
            novaCell?.imageView.image = cellImage
            self.isProcessing = false
        })
        
    }
    
    // image picker
    
    func addImage() -> Void {
        SHARED_PICKER.toImagePicker(self)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage

        let imageRepre = UIImageJPEGRepresentation(image, 0.75)
        let params: [String: AnyObject] = ["id": SHARED_USER.UserIndex]

        if let imageData = imageRepre {

            AFImageManager.SharedInstance.postUserImage(imageData, parameters: params, success: {(task, response) -> Void in
                    TenImagesJSONManager.SharedInstance.getJSONUpdating(self)

                },failure: { (task, error) -> Void in
                    print(error.localizedDescription)
            })
        }
    }


    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
        }
    }

    private func postProfilePicChange(params: [String: AnyObject]) {
        ALAMO_MANAGER.request(.POST, Url_SetImage, parameters: params, encoding: .JSON) .responseJSON {
            response in
            if response.result.isSuccess {
                self.transmitController.dismissViewControllerAnimated(true, completion: nil)
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

    private func postLockStatus(cell: ProfilePicCollectionViewCell, id: Int, status: Bool ) {
        let params: [String : AnyObject] = [
            "ID": id,
            "IsLocked": status
        ]

        presentViewController(transmitController, animated: true, completion: nil)

        ALAMO_MANAGER.request(.POST, Url_Lock, parameters: params, encoding: .JSON, headers: nil) .responseJSON { response in
            if response.result.isSuccess {
                self.setLockStatus(cell, status: status)
                self.transmitController.dismissViewControllerAnimated(true, completion: nil)
            }
            else {
                print("Failed to lock!")
            }
        }
    }

    private func setLockStatus(cell: ProfilePicCollectionViewCell, status: Bool) {
        if status {
            cell.imageView.alpha = 0.3
        }
        else {
            cell.imageView.alpha = 1.0
        }

        cell.lockImageView.hidden = !status
    }

    private func deleteImage(id: Int) {
        let params = [
            "id": id
        ]
        presentViewController(transmitController, animated: true, completion: nil)
        ALAMO_MANAGER.request(.DELETE, Url_DeletePic, parameters: params, encoding: .JSON) .responseJSON{
            response in
            self.transmitController.dismissViewControllerAnimated(true, completion: nil)

        }
    }
}
