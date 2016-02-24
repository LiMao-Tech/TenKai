//
//  PCoinHistoryCell.swift
//  Ten
//
//  Created by gt on 15/10/17.
//  Copyright © 2015年 LiMao Tech. All rights reserved.
//

import UIKit

class PCoinHistoryCell: UITableViewCell {
    var pcoinImage:UIImageView!
    var pcoinLabel:UILabel!
    var priceLabel:UILabel!
    var timeLabel:UILabel!
    var splitLine:UIView!
    var pcoinHistoryModel:PCoinHistoryModel!{
        didSet{
            timeLabel.text = "\(pcoinHistoryModel.PurchaseDate)"
            pcoinLabel.text = "\(pcoinHistoryModel.Content)"
            priceLabel.text = "\(pcoinHistoryModel.Content/10)"
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //pcoinImage
        pcoinImage = UIImageView(frame: CGRectMake(10, 10, 44, 44))
        pcoinImage.image = UIImage(named: "icon_pcoin_88")
        //pcoinLabel
        pcoinLabel = UILabel(frame: CGRectMake(60, 10, 200, 20))
        pcoinLabel.textColor = UIColor.orangeColor()
        pcoinLabel.font = UIFont.systemFontOfSize(17)
        //priceLabel
        priceLabel = UILabel(frame: CGRectMake(60, 34, 120, 20))
        priceLabel.font = UIFont.systemFontOfSize(15)
        priceLabel.textColor = UIColor.whiteColor()
        //buyButton
        timeLabel = UILabel(frame: CGRectMake(SCREEN_WIDTH-110, 10, 100, 20))
        timeLabel.font = UIFont.systemFontOfSize(13)
        timeLabel.textColor = UIColor.whiteColor()
        timeLabel.textAlignment = .Right
        //splitLine
        splitLine = UIView(frame:CGRectMake(54, 63, SCREEN_WIDTH-54, 1))
        splitLine.backgroundColor = UIColor.whiteColor()
        
        self.addSubview(pcoinImage)
        self.addSubview(pcoinLabel)
        self.addSubview(priceLabel)
        self.addSubview(timeLabel)
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

}
