//
//  LockView.m
//  LockDemoOC
//
//  Created by gt on 15/11/24.
//  Copyright © 2015年 gt. All rights reserved.
//

#import "LockView.h"


@interface LockView()

@property(nonatomic,strong) NSMutableArray *selectedBtns;
@property(nonatomic,assign) CGPoint currentPos;
@property(nonatomic,assign) CGFloat iconLen;

@end

@implementation LockView

-(NSMutableArray *)selectedBtns{
    if (_selectedBtns == nil) {
        _selectedBtns = [NSMutableArray array];
    }
    return _selectedBtns;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (CGPoint)pointWithTouches:(NSSet *)touches
{
    UITouch *touch = [touches anyObject];
    return [touch locationInView:touch.view];
}


- (UIButton *)buttonWithPoint:(CGPoint)point
{
    for (UIButton *btn in self.subviews) {
        if (CGRectContainsPoint(btn.frame, point)) {
            return btn;
        }
    }
    
    return nil;
}
-(void)setup{
    self.backgroundColor = [UIColor clearColor];
    int array[11][3] = {{0,-3,1},{2,-2,2},{-2,-2,3},{1,-1,4},{-1,-1,5},{0,0,6},{1,1,7},{-1,1,8},{2,2,9},{-2,2,10},{0,3,11}};
    for (int i=0; i<11; i++) {
        UIButton *btn = [self buttonWithPosX:array[i][0] posY:array[i][1] tag:array[i][2]];
        [self addSubview:btn];
    }
    
}
-(UIButton *)buttonWithPosX:(int)posX posY:(int)posY tag:(int)tag{
    self.iconLen = 22;
    CGFloat x = [UIScreen mainScreen].bounds.size.width/2;
    CGFloat y = self.bounds.size.height/2;
    CGFloat lenX = (x*2- 80)/6;
    CGFloat lenY = lenX+10;
    CGFloat centerX = x+posY*lenX;
    CGFloat centerY = y+posX*lenY;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, self.iconLen, self.iconLen);
    btn.center = CGPointMake(centerX, centerY);
    btn.userInteractionEnabled = NO;
    [btn setBackgroundImage:[UIImage imageNamed:@"icon_passcode_circle"] forState:UIControlStateNormal];
    btn.tag = tag;
    return btn;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.currentPos = CGPointZero;
    
    CGPoint pos = [self pointWithTouches:touches];
    UIButton *btn = [self buttonWithPoint:pos];
    if (btn && btn.selected == NO) {
        btn.selected = YES;
        [btn setBackgroundImage:[UIImage imageNamed:@"icon_checkcircle"] forState:UIControlStateNormal];
        [self.selectedBtns addObject:btn];
    }
    [self setNeedsDisplay];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    CGPoint pos = [self pointWithTouches:touches];
    
    UIButton *btn = [self buttonWithPoint:pos];
    
    if (btn && btn.selected == NO) {
        btn.selected = YES;
        [btn setBackgroundImage:[UIImage imageNamed:@"icon_checkcircle"] forState:UIControlStateNormal];
        [self.selectedBtns addObject:btn];
    } else {
        self.currentPos = pos;
    }
    
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSMutableString * temp= [[NSMutableString alloc] init];
    for (UIButton *btn in self.selectedBtns) {
        [btn setSelected:NO];
        [btn setBackgroundImage:[UIImage imageNamed:@"icon_passcode_circle"] forState:UIControlStateNormal];
        [temp appendString:[NSString stringWithFormat:@"%ld",(long)btn.tag]];
    }
    NSString *path = temp;
    if (self.selectedBtns.count > 0 && self.delegate) {
        [self.delegate lockView:self didFinish:path];
        [self.selectedBtns removeAllObjects];
        [self setNeedsDisplay];
    }
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self touchesEnded:touches withEvent:event];
}

-(void)drawRect:(CGRect)rect{
    if (self.selectedBtns.count == 0) return;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    for (int index = 0; index<self.selectedBtns.count; index++) {
        UIButton *btn = self.selectedBtns[index];
        
        if (index == 0) {
            [path moveToPoint:btn.center];
        } else {
            [path addLineToPoint:btn.center];
        }
    }
    
    // 连接
    if (CGPointEqualToPoint(self.currentPos, CGPointZero) == NO) {
        [path addLineToPoint:self.currentPos];
    }
    
    // 绘图
    path.lineWidth = 5;
    path.lineJoinStyle = kCGLineJoinBevel;
    CGFloat lineDash[3] = {20,8};
    [path setLineDash:lineDash count:2 phase:0];
    [[UIColor colorWithRed:255.0/255.0 green:90.0/255.0 blue:85.0/255.0 alpha:1] set];
    [path stroke];

}

@end
