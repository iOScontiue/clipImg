//
//  UIView+ViewController.m
//  DynamicEditImgLikeSystemFunction
//
//  Created by 卢育彪 on 2018/6/20.
//  Copyright © 2018年 luyubiao. All rights reserved.
//

#import "UIView+ViewController.h"

@implementation UIView (ViewController)

- (UIViewController*)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

@end
