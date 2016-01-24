//
//  ProfilePicsViewController.swift
//  Ten
//
//  Created by Yumen Cao on 1/23/16.
//  Copyright © 2016 LiMao Tech. All rights reserved.
//

import UIKit

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
    
    var imagesJSON = [AnyObject]()
    
    var lockMode: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "相簿"
        layout.blockPixels = CGSizeMake(BLOCK_DIM, BLOCK_DIM)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController!.navigationBar.translucent = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController!.navigationBar.translucent = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dataInit() -> Void {
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
