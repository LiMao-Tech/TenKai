//
//  LMCollectionViewController.h
//  Swapp
//
//  Created by Yumen Cao on 7/26/15.
//  Copyright (c) 2015 Limao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMCollectionViewLayout.h"

#import "AFNetworking/AFNetworking.h"
#import "AFNetworking/AFHTTPSessionManager.h"
#import "AFNetworking/AFURLSessionManager.h"

@interface ProfilePicsCollectionViewController : UIViewController <LMCollectionViewLayoutDelegate> {
    BOOL isAnimating;
    
    CGFloat SCREEN_WIDTH;
    CGFloat SCREEN_HEIGHT;
    CGFloat TOOL_BAR_HEIGHT;
}

@property (nonatomic) NSInteger numberOfPics;
@property (nonatomic) CGFloat BLOCK_DIM;
@property (nonatomic) NSUInteger num;

@property (strong, nonatomic) UICollectionView * lmCollectionView;
@property (strong, nonatomic) AFHTTPSessionManager * afHttpManager;

@property (nonatomic) NSMutableArray* numbers;
@property (nonatomic) NSMutableArray* numberWidths;
@property (nonatomic) NSMutableArray* numberHeights;

- (id) initWithHeight:(CGFloat) height Width: (CGFloat)width ToolbarHeight: (CGFloat) toolbarHeight;

@end
