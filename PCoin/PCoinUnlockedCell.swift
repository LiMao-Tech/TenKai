//
//  PCoinUnlockedCell.swift
//  Ten
//
//  Created by gt on 15/10/18.
//  Copyright © 2015年 LiMao Tech. All rights reserved.
//

import UIKit

class PCoinUnlockedCell: UITableViewCell {
    var unlockedLabel:UILabel!
    var timeLabel:UILabel!
    var splitLine:UIView!
    var pcoinHistoryModel:PCoinHistoryModel!{
        didSet{
            if(pcoinHistoryModel.PurchaseType == 1){
                unlockedLabel.text = "您花费了 \(pcoinHistoryModel.Content) P币解锁等级\(Int(pcoinHistoryModel.Content)!/10)"
            }else{
                unlockedLabel.text = pcoinHistoryModel.Content
            }
            
            timeLabel.text = "\(Tools.toDisplayTime(pcoinHistoryModel.PurchaseDate))"
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        unlockedLabel = UILabel(frame: CGRectMake(10, 10, SCREEN_WIDTH-20, 20))
        unlockedLabel.font = UIFont.systemFontOfSize(17)
        unlockedLabel.textColor = UIColor.orangeColor()
        timeLabel = UILabel(frame: CGRectMake(10, CGRectGetMaxY(unlockedLabel.frame)+5, 200, 15))
        timeLabel.font = UIFont.systemFontOfSize(13)
        timeLabel.textColor = UIColor.whiteColor()
        splitLine = UIView(frame: CGRectMake(0, CGRectGetMaxY(timeLabel.frame)+14, SCREEN_WIDTH, 1))
        splitLine.backgroundColor = UIColor.whiteColor()
        self.addSubview(unlockedLabel)
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
