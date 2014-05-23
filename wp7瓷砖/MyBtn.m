//
//  MyBtn.m
//  wp7瓷砖
//
//  Created by 张伟凯 on 14-5-23.
//  Copyright (c) 2014年 张伟凯. All rights reserved.
//

#import "MyBtn.h"

@implementation MyBtn

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        [self setBackgroundImage:[UIImage imageNamed:@"表情.png"] forState:UIControlStateNormal];
    }
    return self;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super   touchesBegan:touches withEvent:event];
    if (self.viewStatus == 1) {
        self.select = 1;
        if ([self.delegate respondsToSelector:@selector(btnMoveStartWith:)]) {
            [self.delegate btnMoveStartWith:self];
        }
    }
    
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [super   touchesMoved:touches withEvent:event];
    if (self.select == 1) {
        CGPoint oldc = self.center;
        UITouch *touch = [touches anyObject];
        CGPoint current = [touch locationInView:touch.view];
        CGPoint pre = [touch previousLocationInView:touch.view];
        oldc.x += (current.x - pre.x);
        oldc.y += (current.y - pre.y);
        self.center =oldc;
        
        if ([self.delegate respondsToSelector:@selector(btnMovingWith:)]) {
            [self.delegate btnMovingWith:self];
        }
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super   touchesEnded:touches withEvent:event];
    if (self.select == 1) {
        if ([self.delegate respondsToSelector:@selector(btnMoveEndWith:)]) {
            [self.delegate btnMoveEndWith:self];
        }
        self.select = 0;
    }
   
}

@end
