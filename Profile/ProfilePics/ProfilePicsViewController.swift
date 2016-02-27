//
//  ProfilePicsViewController.swift
//  Ten
//
//  Created by Yumen Cao on 1/23/16.
//  Copyright © 2016 LiMao Tech. All rights reserved.
//

import UIKit

import SwiftyJSON

enum BlockDim: CGFloat {
    case Std = 1, L
}

class ProfilePicsViewController: UIViewController {
    
    let ProfilePicCellIdentifier = "ProPicCell"
    let ProfilePicCellNibName = "ProfilePicCollectionViewCell"
    
    let layout = LMCollectionViewLayout()
    
    var isProcessing: Bool = false
    
    var numOfPics: Int = 0
    var dims: [BlockDim] = [BlockDim]()
    
    var imagesJSON: [AnyObject]!


    var image1JSON: JSON?
    var image2JSON: JSON?
    var image3JSON: JSON?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "相簿"
        layout.blockPixels = CGSizeMake(BLOCK_DIM, BLOCK_DIM)
    }
    
    override func viewWillAppear(animated: Bool) {

    }
    
    override func viewWillDisappear(animated: Bool) {

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dataInit() -> Void {
        dims.removeAll()
        numOfPics = imagesJSON.count
        for _ in 0 ..< numOfPics {
            dims.append(BlockDim.Std)
        }
    }
    
    func setUpCollectionView(lmCollectionView: UICollectionView) {
        lmCollectionView.collectionViewLayout = layout
        lmCollectionView.autoresizingMask = .FlexibleHeight
        lmCollectionView.backgroundColor = COLOR_BG
        lmCollectionView.bounces = true
        lmCollectionView.alwaysBounceVertical = true
    }
}
