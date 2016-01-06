//
//  LevelButton.swift
//  Ten
//
//  Created by gt on 15/10/17.
//  Copyright © 2015年 LiMao Tech. All rights reserved.
//

import UIKit

enum lockType:Int{
    case Lock=0,UnLock
}

class LevelButton: UIButton {
    var level = 0{
        didSet{
            lockImage = UIImage(named: "btn_l\(level)_lock")
            unlockImage = UIImage(named: "btn_l\(level)_unlock")
            self.setImage(lockImage, forState: .Normal)
        }
    }
    var lockState = lockType.Lock{
        didSet{
            if(lockState == .Lock){
                self.setImage(lockImage, forState: .Normal)
                self.userInteractionEnabled = false
            }else{
                self.setImage(unlockImage, forState: .Normal)
                self.userInteractionEnabled = true
            }
        }
    }
    var lockImage:UIImage!
    var unlockImage:UIImage!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
