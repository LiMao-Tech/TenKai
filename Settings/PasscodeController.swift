//
//  PasscodeController.swift
//  Ten
//
//  Created by gt on 15/12/4.
//  Copyright © 2015年 LiMao Tech. All rights reserved.
//

import UIKit
enum passcodeType : Int{
    case Set,Reset
}

class PasscodeController: UIViewController,LockViewDelegate {
    
    var times  = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    
    func setup(){
        let lock = LockView(frame: CGRectMake(0,64,SCREEN_WIDTH,SCREEN_HEIGHT-64))
        lock.delegate = self
        self.view.addSubview(lock)
        self.view.backgroundColor = COLOR_BG
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func lockView(lockView: LockView!, didFinish path: String!) {
        print(path)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
