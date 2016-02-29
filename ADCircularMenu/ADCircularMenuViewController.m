//
//  ADCircularMenuViewController.m
//  iOSCircularMenu
//
//  Created by Aditya Deshmane on 19/10/14.
//  Copyright (c) 2014 Aditya Deshmane. All rights reserved.
//

#import "ADCircularMenuViewController.h"

#define BUTTON_DENO 15

@interface ADCircularMenuViewController ()<UIGestureRecognizerDelegate>
{
    float _fButtonSize;
    float _fInnerRadius;
    
    NSUInteger _iNumberOfButtons;
    NSMutableArray *_arrButtons;
    NSArray *_arrButtonImageName;
    UIButton *_buttonCorner;

    CGRect _screenFrame;
    CGPoint _startingPoint;
    
    UIGestureRecognizer *_gestureRecognizerTap;
}

//Private Methods
-(void)setupData;
-(void)setTapGesture;
-(void)setupButtons;

-(void)showButtons;
-(void)setButtonFrames;

- (void)removeViewWithAnimation;

//IBActions
- (IBAction)hideMenu:(id)sender;

@end

@implementation ADCircularMenuViewController


-(id)initWithFrame:(CGRect)frame {
    self = [super init];
    _screenFrame = frame;
    _startingPoint= CGPointMake(BUTTON_DENO, _screenFrame.size.height*(BUTTON_DENO-1)/BUTTON_DENO);
    NSArray * names = [[NSArray alloc] initWithObjects: @"btn_menu_search_female", @"btn_menu_search_male", @"btn_menu_search_all", @"btn_menu_profile", @"btn_menu_radar", @"btn_menu_chat_normal", @"btn_menu_notification_normal", @"btn_menu_setting", nil];
    if (self)
    {
        _iNumberOfButtons = names.count;
        _arrButtonImageName = names;
        
        [self setupData];
        [self setTapGesture];
        [self setupButtons];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Initialization methods

-(void)setupData
{
    _fButtonSize = 20;//circular button width/height
    _fInnerRadius = 75;//1st circle boundary
}

-(void)setTapGesture
{
    _gestureRecognizerTap = [[UITapGestureRecognizer alloc]
              initWithTarget:self action:@selector(handleSingleTap:)];
    _gestureRecognizerTap.cancelsTouchesInView = NO;
    _gestureRecognizerTap.delegate = self;
    [self.view addGestureRecognizer:_gestureRecognizerTap];
}


- (void)setupButtons
{
    //Corner button
    _buttonCorner = [UIButton buttonWithType:UIButtonTypeCustom];
    [_buttonCorner addTarget:self action:@selector(hideMenu:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonCorner setFrame:CGRectMake(0, _screenFrame.size.height*(BUTTON_DENO-1)/BUTTON_DENO, BUTTON_DENO*3, BUTTON_DENO*3)];
    [_buttonCorner setImage:[UIImage imageNamed:@"btn_menu"] forState:UIControlStateNormal];
    //Circular menu buttons
    _arrButtons = [[NSMutableArray alloc] init];

    for (int i = 0; i < _iNumberOfButtons; i++)
    {
         UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTag:i];
        [button addTarget:self action:@selector(hideMenu:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:[_arrButtonImageName objectAtIndex:i]] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(0, _screenFrame.size.height*(BUTTON_DENO-1)/BUTTON_DENO, BUTTON_DENO*3, BUTTON_DENO*3)];
        [_arrButtons addObject:button];
    }
}

#pragma mark - Show menu

-(void)show
{
    [self showButtons];
}

- (void)showButtons
{
    [self.view addSubview:_buttonCorner];
    
    for (int index = 0; index < _iNumberOfButtons; index++)
    {
         UIButton *button = [_arrButtons objectAtIndex:index];
        button.center = _startingPoint;
        [self.view addSubview:button];
    }
    
    [self.view layoutIfNeeded]; // Ensures that all pending layout operations have been completed
    
    [UIView animateWithDuration:0.3 animations:
     ^{
         [self setButtonFrames];
         [self.view layoutIfNeeded]; // Forces the layout of the subtree animation block and then captures all of the frame changes
     }];
}

- (void)setButtonFrames
{
    CGPoint circleCenter = _startingPoint;
    
    //1st circle initialization
    float incAngle = ( 117/3 )*M_PI/180.0 ;
    float curAngle = -1.4; //more value more to left;
    float circleRadius = _fInnerRadius;
    
    for (int i = 0; i < _iNumberOfButtons; i++)
    {
        if(i == 3)//2nd circle
        {
            curAngle = -1.4;
            incAngle = ( 100/5 )*M_PI/180.0;
            circleRadius = _fInnerRadius + 60;
        }

        CGPoint buttonCenter;
        buttonCenter.x = circleCenter.x + cos(curAngle)*circleRadius;
        buttonCenter.y = circleCenter.y + sin(curAngle)*circleRadius;
        UIButton *button = [_arrButtons objectAtIndex:i];
        button.center = buttonCenter;
        curAngle += incAngle;
    }
}


#pragma mark - Remove menu

- (IBAction)hideMenu:(id)sender
{
    if (sender &&
        sender != _buttonCorner &&
        _circularMenuDelegate &&
        [_circularMenuDelegate respondsToSelector:@selector(circularMenuClickedButtonAtIndex:)])
    {
        UIButton *button = (UIButton*)sender;
        [_circularMenuDelegate circularMenuClickedButtonAtIndex:(int)button.tag];
    }
    
    [self removeViewWithAnimation];
}


- (void)removeViewWithAnimation
{
    [self.view layoutIfNeeded];
    
    [UIView animateWithDuration:0.1
                     animations:
     ^{
         for (int index = 0; index < _iNumberOfButtons; index++)
         {
             UIButton *button = [_arrButtons objectAtIndex:index];
             button.center = _startingPoint;
         }
     }
                     completion:^(BOOL finished)
     {
         [self.view removeFromSuperview];
         [self willMoveToParentViewController:nil];
         [self removeFromParentViewController];
     }];
}


#pragma mark - Tap gesture handling

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    //ingore touch for button at top left corner, let its touch up inside handler method handle that
    if ((touch.view == _buttonCorner))
    return NO;
    
    //ingore touch gesture for all menu button, let their touch up inside handler method handle that
    for (int index = 0; index < _iNumberOfButtons; index++)
    {
        UIButton *button = [_arrButtons objectAtIndex:index];
        
        if ((touch.view == button))
        return NO;
    }
    
    return YES;
}

- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    //view was touched at point other than buttons
    [self removeViewWithAnimation];
}

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
