//
//  ShadowView.m
//  DynamicEditImgLikeSystemFunction
//
//  Created by 卢育彪 on 2018/5/15.
//  Copyright © 2018年 luyubiao. All rights reserved.
//

#import "ShadowView.h"

@implementation ShadowView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
    }
    return self;
}

-(void)setIsSetShadow:(BOOL)isSetShadow
{
    _isSetShadow = isSetShadow;
    [self setNeedsDisplay];
}

-(void)setHighLightArea:(CGRect)highLightArea
{
    _highLightArea = highLightArea;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    if (self.isSetShadow) {
        [[UIColor colorWithWhite:0 alpha:0.7] setFill];
        UIRectFill(rect);
        CGRect holeRect = self.highLightArea;
        CGRect holeRectSection = CGRectIntersection(holeRect, rect);
        [[UIColor clearColor] setFill];
        UIRectFill(holeRectSection);
    } else {
        [[UIColor colorWithWhite:0 alpha:0] setFill];
        UIRectFill(rect);
    }
}

@end
