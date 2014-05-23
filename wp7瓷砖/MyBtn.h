//
//  MyBtn.h
//  wp7瓷砖
//
//  Created by 张伟凯 on 14-5-23.
//  Copyright (c) 2014年 张伟凯. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyBtn;
@protocol MyBtnDelegate <NSObject>

@optional
- (void)btnMoveEndWith:(MyBtn*)btn;
- (void)btnMovingWith:(MyBtn*)btn;
- (void)btnMoveStartWith:(MyBtn*)btn;

@end

@interface MyBtn : UIButton
@property(nonatomic,assign)int select;
@property(nonatomic,weak)id <MyBtnDelegate> delegate;
@property(nonatomic,assign)int viewStatus;
@end
