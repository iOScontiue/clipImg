//
//  ClipAreaLayer.m
//  DynamicEditImgLikeSystemFunction
//
//  Created by 卢育彪 on 2018/4/26.
//  Copyright © 2018年 luyubiao. All rights reserved.
//

#import "ClipAreaLayer.h"

@implementation ClipAreaLayer

-(instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

//外部改变裁剪框的边界，则须重新绘图
-(void)setTopEdge:(CGFloat)topEdge
{
    if (_topEdge != topEdge) {
        _topEdge = topEdge;
    }
//    [self setNeedsDisplay];
}

-(void)setBottomEdge:(CGFloat)bottomEdge
{
    if (_bottomEdge != bottomEdge) {
        _bottomEdge = bottomEdge;
    }
//    [self setNeedsDisplay];
}

-(void)setLeftEdge:(CGFloat)leftEdge
{
    if (_leftEdge != leftEdge) {
        _leftEdge = leftEdge;
    }
//    [self setNeedsDisplay];
}

-(void)setRightEdge:(CGFloat)rightEdge
{
    if (_rightEdge != rightEdge) {
        _rightEdge = rightEdge;
    }
//    [self setNeedsDisplay];
}

//绘制裁剪框
-(void)drawInContext:(CGContextRef)ctx
{
    UIGraphicsPushContext(ctx);
    
    //line_top
    [self createLineWithContext:ctx FromPoint:CGPointMake(self.leftEdge, self.topEdge) ToPoint:CGPointMake(self.rightEdge, self.topEdge)];
    
    //line_bottom
    [self createLineWithContext:ctx FromPoint:CGPointMake(self.leftEdge, self.bottomEdge) ToPoint:CGPointMake(self.rightEdge, self.bottomEdge)];
    
    //line_left
    [self createLineWithContext:ctx FromPoint:CGPointMake(self.leftEdge, self.topEdge) ToPoint:CGPointMake(self.leftEdge, self.bottomEdge)];
    
    //line_right
    [self createLineWithContext:ctx FromPoint:CGPointMake(self.rightEdge, self.topEdge) ToPoint:CGPointMake(self.rightEdge, self.bottomEdge)];
    
    //shortLine_leftTop
    [self createShortLineWithContext:ctx FromPoint:CGPointMake(self.leftEdge, self.topEdge) ToPoint:CGPointMake(self.leftEdge+SHORT_LINE_LENGTH, self.topEdge)];
    [self createShortLineWithContext:ctx FromPoint:CGPointMake(self.leftEdge, self.topEdge) ToPoint:CGPointMake(self.leftEdge, self.topEdge+SHORT_LINE_LENGTH)];
    
    //shortLine_leftBottom
    [self createShortLineWithContext:ctx FromPoint:CGPointMake(self.leftEdge, self.bottomEdge) ToPoint:CGPointMake(self.leftEdge+SHORT_LINE_LENGTH, self.bottomEdge)];
    [self createShortLineWithContext:ctx FromPoint:CGPointMake(self.leftEdge, self.bottomEdge) ToPoint:CGPointMake(self.leftEdge, self.bottomEdge-SHORT_LINE_LENGTH)];
    
    //shortLine_rightTop
    [self createShortLineWithContext:ctx FromPoint:CGPointMake(self.rightEdge, self.topEdge) ToPoint:CGPointMake(self.rightEdge-SHORT_LINE_LENGTH, self.topEdge)];
    [self createShortLineWithContext:ctx FromPoint:CGPointMake(self.rightEdge, self.topEdge) ToPoint:CGPointMake(self.rightEdge, self.topEdge+SHORT_LINE_LENGTH)];
    
    //shortLine_rightBottom
    [self createShortLineWithContext:ctx FromPoint:CGPointMake(self.rightEdge, self.bottomEdge) ToPoint:CGPointMake(self.rightEdge-SHORT_LINE_LENGTH, self.bottomEdge)];
    [self createShortLineWithContext:ctx FromPoint:CGPointMake(self.rightEdge, self.bottomEdge) ToPoint:CGPointMake(self.rightEdge, self.bottomEdge-SHORT_LINE_LENGTH)];
    
    UIGraphicsPopContext();
}

- (void)createLineWithContext:(CGContextRef)ctx FromPoint:(CGPoint)fp ToPoint:(CGPoint)tp
{
    CGContextSetStrokeColorWithColor(ctx, LINE_COLOR);
    CGContextSetLineWidth(ctx, LINE_WIDTH);
    CGContextMoveToPoint(ctx, fp.x, fp.y);
    CGContextAddLineToPoint(ctx, tp.x, tp.y);
    CGContextStrokePath(ctx);
}

- (void)createShortLineWithContext:(CGContextRef)ctx FromPoint:(CGPoint)fp ToPoint:(CGPoint)tp
{
    CGContextSetStrokeColorWithColor(ctx, LINE_COLOR);
    CGContextSetLineWidth(ctx, SHORT_LINE_THICK);
    CGContextMoveToPoint(ctx, fp.x, fp.y);
    CGContextAddLineToPoint(ctx, tp.x, tp.y);
    CGContextStrokePath(ctx);
}

- (void)configClipAreaWithTop:(CGFloat)top Bottom:(CGFloat)bottom Left:(CGFloat)left Right:(CGFloat)right
{
    self.topEdge = top;
    self.bottomEdge = bottom;
    self.leftEdge = left;
    self.rightEdge = right;
    
    //通过调用该方法来调用绘图方法drawInContext：
    [self setNeedsDisplay];
}

@end
