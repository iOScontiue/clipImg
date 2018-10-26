//
//  PanGesRec.m
//  DynamicEditImgLikeSystemFunction
//
//  Created by 卢育彪 on 2018/4/28.
//  Copyright © 2018年 luyubiao. All rights reserved.
//

#import "PanGesRec.h"

@implementation PanGesRec

- (instancetype)initWithTarget:(id)target Action:(SEL)action InView:(UIView *)view
{
    self = [super initWithTarget:target action:action];
    if (self) {
        self.targetView = view;
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent*)event
{
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    self.beginPoint = [touch locationInView:self.targetView];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    self.movedPoint = [touch locationInView:self.targetView];
}

@end
