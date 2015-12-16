//
//  ADCircularMenuViewController.h
//  iOSCircularMenu
//
//  Created by Aditya Deshmane on 19/10/14.
//  Copyright (c) 2014 Aditya Deshmane. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ADCircularMenuDelegate<NSObject>

@optional

//callback provides button index
- (void)circularMenuClickedButtonAtIndex:(int) buttonIndex;

@end


@interface ADCircularMenuViewController : UIViewController

@property(nonatomic) id <ADCircularMenuDelegate> circularMenuDelegate;

-(id)initWithFrame:(CGRect) frame;

//shows menus
-(void)show;

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 