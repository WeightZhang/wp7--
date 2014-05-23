//
//  ViewController.m
//  wp7瓷砖
//
//  Created by 张伟凯 on 14-5-22.
//  Copyright (c) 2014年 张伟凯. All rights reserved.
//

#import "ViewController.h"
#import "MyBtn.h"
@interface ViewController ()<UIGestureRecognizerDelegate,MyBtnDelegate>

@property(nonatomic,weak)UIView *btnView; //所有btn的父控件
@property(nonatomic,assign)int status;//状态 是否处于可移动状态
@property(nonatomic,assign)CGPoint oldCenter;//当前位置
@property(nonatomic,assign)CGPoint newCenter;//改变后的位置

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIView *btnView = [[UIView alloc]init];
    btnView.bounds = CGRectMake(0, 0, 320, 320) ;
    btnView.center = CGPointMake(self.view.center.x, self.view.center.y);
    btnView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:btnView];
    self.btnView = btnView;
    [self addBtn];
    self.status = 0;
    
}

- (void)addBtn{
    CGFloat btnW =  70;
    CGFloat btnH =  80;
    CGFloat marginX =  (self.btnView.bounds.size.width - btnW * 3)/4;
    CGFloat marginY =  (self.btnView.bounds.size.height - btnH * 3)/4;
    
    for (int i = 0; i < 9; i ++) {
        CGFloat btnX =marginX +i%3 *(marginX+btnW ) ;
        CGFloat btnY = marginY +i/3 *(marginY+btnH ) ;
        MyBtn *btn = [[MyBtn alloc]initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
        [self.btnView addSubview:btn];
        btn.select = 0;
        btn.viewStatus = self.status;
        btn.backgroundColor = [UIColor whiteColor];
        //添加点击监听
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        //添加长按手势
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressDid:)];
        [btn addGestureRecognizer:longPress];
        //设置代理--监听控制器的变化
        btn.delegate = self;
    }
}
- (CGPoint)getBtnCenter:(UIGestureRecognizer*)pan{
 
  
    MyBtn *btn;
    for (btn in self.btnView.subviews) {
        if (!btn.select)
        if ([self isInOtherRange:pan.view with:btn]) {
//             NSLog(@"getBtnCenter btncenter = %@",[NSValue valueWithCGPoint:btn.center]);
//            [UIView animateWithDuration:0.2f animations:^{
//#warning ------
//                NSLog(@"getBtnCenter animateWithDuration = %@",[NSValue valueWithCGPoint:btn.center]);
//            } completion:^(BOOL finished) {
//                 btn.center = center;
//            }];
            return btn.center;
        }
    }
    return self.oldCenter;
}
- (BOOL)isInOtherRange:(MyBtn*)view with:(MyBtn*)btn{
    CGPoint centerView = view.center;
    CGPoint centerBtn = btn.center;
    if (
        sqrtf(powf((centerView.x - centerBtn.x), 2)+powf((centerView.y - centerBtn.y), 2))  < view.bounds.size.width/2
        ) {
          return YES;
    }
    return NO;
}




- (void)statusChange:(int)status{
    if (self.status == 1) {
        MyBtn *btn;
        [UIView animateWithDuration:0.5f animations:^{
            for (btn in self.btnView.subviews) {
                [self startShake:btn];
                btn.transform = CGAffineTransformScale(btn.transform, 0.8,0.8);
            }
        }];
        
    }else{
        NSLog(@"statusChange else");
        MyBtn *btn;
        [UIView animateWithDuration:0.5f animations:^{
            for (btn in self.btnView.subviews) {
                btn.transform = CGAffineTransformIdentity;
                [self stopShake:btn];
            }
        }];
    }
}
#pragma mark -- 重写的方法

- (void)setStatus:(int)status{
    if(_status != status){
        int temp = _status;
        _status = status;
        [self statusChange:temp];
    }
}
#pragma mark - 代理方法
- (CGPoint)getBtnCenterS:(MyBtn*)btn{
    MyBtn *child = nil;
    for (child in self.btnView.subviews) {
        
        if (child.select == 0){
            NSLog(@"getBtnCenter btncenter = %@",[NSValue valueWithCGPoint:btn.center]);
            if ([self isInOtherRange:child with:btn]) {
                [UIView animateWithDuration:0.1 animations:^{
                    child.center = self.oldCenter;
                }];
                return child.center;
            }
        }
    }
    return self.oldCenter;
}
- (void)setBtnCenter:(MyBtn*)btn{
    
    MyBtn *child = nil;
    for (child in self.btnView.subviews) {
        
        if (child.select == 0){
            if ([self isInOtherRange:child with:btn]) {
                self.newCenter = child.center;
                [UIView animateWithDuration:0.1 animations:^{
                child.center = self.oldCenter;
                    self.oldCenter = self.newCenter;
                }];
             }
        }
        
    }

}
- (void)btnMovingWith:(MyBtn *)btn{
   
         [self setBtnCenter:btn];
 
}
- (void)btnMoveStartWith:(MyBtn *)btn{
  
        self.oldCenter = btn.center;
 
}
- (void)btnMoveEndWith:(MyBtn *)btn{
    
         CGPoint  c  =  [self getBtnCenterS:btn];
         [UIView animateWithDuration:0.2f animations:^{
             btn.center = c;
         } completion:^(BOOL finished) {
             
         }];
    
    
        
   
    NSLog(@"delegate btn0 btn.select = %d",btn.select);
}
#pragma mark - 监听事件
- (void)click:(MyBtn*)btn{
    //点击按钮 是按钮不再晃动
    if(self.status == 1){
        self.status = 0;
        MyBtn *btn = nil;
        for (btn in self.btnView.subviews) {
            btn.viewStatus = self.status;
        }
    }
}
- (void)longPressDid:(UILongPressGestureRecognizer*)longPress{
    if (self.status == 0) {
        self.status = 1;
        MyBtn *btn = nil;
        for (btn in self.btnView.subviews) {
            btn.viewStatus = self.status;
        }
    }
}


#pragma mark - 晃动动画 开启 关闭
- (void)startShake:(MyBtn*)btn {
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"transform.rotation";
    
    anim.values = @[@(-M_PI/180.0*5),  @(M_PI/180.0*5), @(-M_PI/180.0*5)];
    anim.duration = 0.25;
    // 动画的重复执行次数
    anim.repeatCount = MAXFLOAT;
    
    // 保持动画执行完毕后的状态
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    
    [btn.layer addAnimation:anim forKey:@"shake"];
}

- (void)stopShake:(MyBtn*)btn  {
    [btn.layer removeAnimationForKey:@"shake"];
}
#pragma mark --- 废掉的代码
/*
 - (void)panDid:(UIPanGestureRecognizer*)pan{
 switch (pan.state) {
 case UIGestureRecognizerStateBegan:
 self.oldCenter = pan.view.center;
 
 break;
 
 case UIGestureRecognizerStateChanged:
 
 if (self.status == 1) {
 // 1.在view上面挪动的距离
 //                CGPoint translation = [pan translationInView:pan.view];
 //                CGPoint center = pan.view.center;
 //                center.x += translation.x;
 //                center.y += translation.y;
 //                pan.view.center = center;
 //
 //                // 2.清空移动的距离
 //                [pan setTranslation:CGPointZero inView:pan.view];
 
 NSLog(@"changed --- center = %@", [NSValue valueWithCGPoint:pan.view.center]);
 
 }
 
 break;
 
 case UIGestureRecognizerStateCancelled:
 NSLog(@"Cancelled");
 break;
 case UIGestureRecognizerStateEnded:
 [UIView animateWithDuration:0.1f animations:^{
 pan.view.center = [self getBtnCenter:pan];
 
 } completion:^(BOOL finished) {
 self.oldCenter = pan.view.center;
 }];
 break;
 
 
 }
 
 }

 
- (void)btnMovings:(UIButton*)btn{
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(updata:)];
    [link addToRunLoop:   [NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
 
}
- (void)updata:(id)btn{
    //    ( (UIButton*)btn.btnView.subviews[1]).transform = CGAffineTransformRotate(( (UIButton*)btn.btnView.subviews[1]).transform,  M_PI/180/10.0);
    self.view.transform = CGAffineTransformRotate(self.view.transform, M_PI/180.0/10.0);
    
    NSLog(@"Class = %@",[btn class]);
}
*/
@end
