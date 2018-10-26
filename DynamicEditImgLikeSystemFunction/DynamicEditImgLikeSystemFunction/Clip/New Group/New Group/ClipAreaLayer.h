//
//  ClipAreaLayer.h
//  DynamicEditImgLikeSystemFunction
//
//  Created by 卢育彪 on 2018/4/26.
//  Copyright © 2018年 luyubiao. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface ClipAreaLayer : CAShapeLayer

@property (nonatomic, assign) CGFloat topEdge;
@property (nonatomic, assign) CGFloat bottomEdge;
@property (nonatomic, assign) CGFloat leftEdge;
@property (nonatomic, assign) CGFloat rightEdge;

- (void)configClipAreaWithTop:(CGFloat)top Bottom:(CGFloat)bottom Left:(CGFloat)left Right:(CGFloat)right;

@end
