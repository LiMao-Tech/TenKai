//
//  PCoinPurchaseCell.swift
//  Ten
//
//  Created by gt on 15/10/17.
//  Copyright © 2015年 LiMao Tech. All rights reserved.
//

import UIKit

protocol GTCoinPuschaseDelegate : class {
    func buyButtonDidClickeds(cell:PCoinPurchaseCell)
}

class PCoinPurchaseCell: UITableViewCell {
    var pcoinImage:UIImageView!
    var pcoinLabel:UILabel!
    var priceLabel:UILabel!
    var buyButton:UIButton!
    var splitLine:UIView!
    var index = 0
    var delegate:GTCoinPuschaseDelegate?
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //pcoinImage
        pcoinImage = UIImageView(frame: CGRectMake(10, 10, 44, 44))
        pcoinImage.image = UIImage(named: "icon_pcoin_88")
        //pcoinLabel
        pcoinLabel = UILabel(frame: CGRectMake(60, 10, 120, 20))
        pcoinLabel.textColor = UIColor.orangeColor()
        pcoinLabel.font = UIFont.systemFontOfSize(17)
        //priceLabel
        priceLabel = UILabel(frame: CGRectMake(60, 34, 120, 20))
        priceLabel.font = UIFont.systemFontOfSize(15)
        priceLabel.textColor = UIColor.whiteColor()
        //buyButton
        buyButton = UIButton(frame: CGRectMake(SCREEN_WIDTH-60, 0, 60, 64))
        buyButton.setTitle("购买", forState: .Normal)
        buyButton.titleLabel?.textColor = UIColor.whiteColor()
        buyButton.titleLabel?.font = UIFont.systemFontOfSize(17)
        buyButton.addTarget(self, action: #selector(PCoinPurchaseCell.buyButtonClicked), forControlEvents: .TouchUpInside)
        //splitLine
        splitLine = UIView(frame:CGRectMake(54, 63, SCREEN_WIDTH-54, 1))
        splitLine.backgroundColor = UIColor.whiteColor()
        
        self.addSubview(pcoinImage)
        self.addSubview(pcoinLabel)
        self.addSubview(priceLabel)
        self.addSubview(buyButton)
        self.addSubview(splitLine)
        
        self.backgroundColor = UIColor.clearColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func buyButtonClicked(){
        if((self.delegate) != nil){
            self.delegate!.buyButtonDidClickeds(self)
        }

    }
    

}
