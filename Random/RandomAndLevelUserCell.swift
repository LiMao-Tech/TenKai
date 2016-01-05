//
//  RandomAndLevelUserCell.swift
//  Ten
//
//  Created by gt on 15/10/12.
//  Copyright © 2015年 LiMao Tech. All rights reserved.
//

import UIKit

class RandomAndLevelUserCell: UITableViewCell {
    
    var headImage : UIButton!
    var nameLabel : UILabel!
    
    var innerLabel : UILabel!
    var outerLabel : UILabel!
    var energyLabel : UILabel!
    var avgLabel : UILabel!
    
    var distanceLabel : UILabel!
    
    var splitLine : UIView!
    
    var RALuser:RandomAndLevelUser!{
        didSet{
            nameLabel.text = "\(RALuser.UserName)"
            innerLabel.text = "inner \(RALuser.InnerScore)"
            outerLabel.text = "outer \(RALuser.OuterScore)"
            avgLabel.text = "AVG \(RALuser.Average)"
            energyLabel.text = "energy \(RALuser.Energy)"
            distanceLabel.text = "\(RALuser.distance) km"
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        headImage = UIButton(frame: CGRectMake(10, 10, 55, 55))
        headImage.setImage(UIImage(named: "user_pic_110"), forState: UIControlState.Normal)
        
        //nameLabel
        let namex = CGRectGetMaxX(headImage.frame) + 5
        let lableText:NSString = "userName"
        let w = SCREEN_WIDTH - 190
        let attr = [NSFontAttributeName:UIFont.systemFontOfSize(17)]
        let size = lableText.boundingRectWithSize(CGSizeMake(w, 21), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attr, context: nil)
        
        nameLabel = UILabel(frame: CGRectMake(namex, 10, size.width, size.height))
        nameLabel.textColor = UIColor.orangeColor()
        nameLabel.font = UIFont.systemFontOfSize(17)
        
        let innerx = nameLabel.frame.origin.x
        let innery = CGRectGetMaxY(headImage.frame) - 20
        let innerh:CGFloat = 20
        let afont = UIFont.systemFontOfSize(15)
        let len = (SCREEN_WIDTH - innerx - 5)/4
        
        //inner outter avg energylabe
        innerLabel = UILabel(frame: CGRectMake(innerx, innery, len, innerh))
        self.innerLabel.textColor = UIColor.whiteColor()
        self.innerLabel.font = afont
        
        outerLabel = UILabel(frame: CGRectMake(innerx+len, innery, len, innerh))
        self.outerLabel.textColor = UIColor.whiteColor()
        self.outerLabel.font = afont
        
        avgLabel = UILabel(frame: CGRectMake(innerx + 2*len, innery, len, innerh))
        self.avgLabel.textColor = UIColor.orangeColor()
        self.avgLabel.font = afont
        
        energyLabel = UILabel(frame: CGRectMake(innerx + 3*len, innery, len, innerh))
        self.energyLabel.textColor = UIColor.whiteColor()
        self.energyLabel.font = afont
        
        //distanceLabel
        let distancew:CGFloat = 60
        distanceLabel = UILabel(frame: CGRectMake(SCREEN_WIDTH - 65, 10, distancew, innerh))
        distanceLabel.textAlignment = .Right
        distanceLabel.font = UIFont.systemFontOfSize(13)
        distanceLabel.textColor = UIColor.whiteColor()
        
        //splitline
        splitLine = UIView(frame: CGRectMake(CGRectGetMaxX(headImage.frame), CGRectGetMaxY(headImage.frame) + 1, SCREEN_WIDTH - 70, 1))
        splitLine.backgroundColor = UIColor.whiteColor()
        splitLine.alpha = 0.6
        
        //addsubviews
        self.addSubview(headImage)
        self.addSubview(nameLabel)
        self.addSubview(innerLabel)
        self.addSubview(outerLabel)
        self.addSubview(avgLabel)
        self.addSubview(energyLabel)
        self.addSubview(distanceLabel)
        self.addSubview(splitLine)
        self.backgroundColor = UIColor.clearColor()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        //headImage
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
