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
#import "AFNetworking/AFImageDownloader.h"

@interface ProfilePicsCollectionViewController : UIViewController <LMCollectionViewLayoutDelegate> {
    BOOL isAnimating;
    
    NSInteger UserID;
    NSInteger NumberOfPics;
    NSInteger Num;
    
    CGFloat SCREEN_WIDTH;
    CGFloat SCREEN_HEIGHT;
    CGFloat TOOL_BAR_HEIGHT;
    CGFloat BLOCK_DIM;
}




@property (strong, nonatomic) UICollectionView * lmCollectionView;
@property (strong, nonatomic) AFHTTPSessionManager * afHttpManager;
@property (strong, nonatomic) AFURLSessionManager * afUrlManager;
@property (strong, nonatomic) AFImageDownloader * afImageDowloader;

@property (nonatomic) NSMutableArray* numbers;
@property (nonatomic) NSMutableArray* numberWidths;
@property (nonatomic) NSMutableArray* numberHeights;

- (id) initWithHeight:(CGFloat) height Width: (CGFloat)width ToolbarHeight: (CGFloat) toolbarHeight UserId: (NSInteger) userId;

@end
