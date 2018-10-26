//
//  PanGesRec.h
//  DynamicEditImgLikeSystemFunction
//
//  Created by 卢育彪 on 2018/4/28.
//  Copyright © 2018年 luyubiao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GRSTATE)
{
    GR_BEGIN = UIGestureRecognizerStateBegan,
    GR_CHANGED = UIGestureRecognizerStateChanged,
    GR_ENDED = UIGestureRecognizerStateEnded
};

@interface PanGesRec : UIPanGestureRecognizer

@property (nonatomic, strong) UIView *targetView;
@property (nonatomic, assign) CGPoint beginPoint;
@property (nonatomic, assign) CGPoint movedPoint;

- (instancetype)initWithTarget:(id)target Action:(SEL)action InView:(UIView *)view;

@end
