//
//  ClipImagePage.h
//  DynamicEditImgLikeSystemFunction
//
//  Created by 卢育彪 on 2018/4/25.
//  Copyright © 2018年 luyubiao. All rights reserved.
//

#import "BaseViewController.h"

@class TabBar;
@class ClipAreaLayer;
@class PanGesRec;
@class ShadowView;
@class FilterSlider;
@class ColorCollectionView;

@interface ClipImagePage : BaseViewController<CAAnimationDelegate>
{
    float _valueOffset;
    NSInteger _rorateNum;
    CGRect _originalImgViewFrame;
    BOOL _isClickColor;
}

//原始数据
@property (nonatomic, strong) UIImageView *originalImgView;
@property (nonatomic, assign) CGFloat originalWidth;
@property (nonatomic, assign) CGFloat originalHeight;

//裁剪前的图片
@property (nonatomic, strong) UIImage *targetImg;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIButton *editBtn;
//@property (nonatomic, strong) UIButton *resetBtn;
@property (nonatomic, strong) UIView *clipBtnBaseView;
@property (nonatomic, strong) TabBar *myTabBar;
@property (nonatomic, strong) ShadowView *shaView;

//裁剪框
@property (nonatomic, assign) CGFloat clipAreaCenterX;
@property (nonatomic, assign) CGFloat clipAreaCenterY;
@property (nonatomic, assign) CGFloat clipAreaWidth;
@property (nonatomic, assign) CGFloat clipAreaHeight;
@property (nonatomic, assign) CGRect preClipAreaFrame;
@property (nonatomic, strong) ClipAreaLayer *clipAreaLayer;

//手势
@property (nonatomic, assign) ACTIVE_GESTURE_VIEW acGeView;
@property (nonatomic, strong) PanGesRec *panGesRec;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinGesRec;

//滤镜图片
@property (nonatomic, strong) ColorCollectionView *colorCollectionView;

//裁剪后
@property (nonatomic, strong) UIImageView *clipImgView;

@end
