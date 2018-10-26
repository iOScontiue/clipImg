//
//  BaseViewController.h
//  DynamicEditImgLikeSystemFunction
//
//  Created by 卢育彪 on 2018/4/25.
//  Copyright © 2018年 luyubiao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ACTIVE_GESTURE_VIEW)
{
    IMAGE_VIEW = 0,
    CLIP_AREA_LEFT,
    CLIP_AREA_RIGHT,
    CLIP_AREA_TOP,
    CLIP_AREA_BOTTOM,
    
    /**
     *左上
     */
    CLIP_AREA_LT,
    
    /**
     *左下
     */
    CLIP_AREA_LB,
    
    /**
     *右上
     */
    CLIP_AREA_RT,
    
    /**
     *右下
     */
    CLIP_AREA_RB,
    
    /**
     *上下
     */
    CLIP_AREA_TB,
    
    /**
     *左右
     */
    CLIP_AREA_LR
};

@interface BaseViewController : UIViewController

@end
