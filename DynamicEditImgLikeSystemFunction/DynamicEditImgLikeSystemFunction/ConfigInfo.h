//
//  ConfigInfo.h
//  DynamicEditImgLikeSystemFunction
//
//  Created by 卢育彪 on 2018/4/25.
//  Copyright © 2018年 luyubiao. All rights reserved.
//

#ifndef ConfigInfo_h
#define ConfigInfo_h

#define YBMainWindow [UIApplication sharedApplication].keyWindow

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define NavgationHeight 64
#define kHEIGHT 50
#define kItemHeight 60
#define CLIP_VIEW_BOTTOM_MAX 170
#define CLIP_VIEW_TOP_MIN 40
#define CLIP_VIEW_LR_MIN 10

/**
 *裁剪框frame
 */
#define KClipAreaEdge 10
#define KClipAreaYOffset 70

/**
 *ClipAreaLayer.m文件参数
 */
#define LINE_COLOR [UIColor whiteColor].CGColor
#define LINE_WIDTH 2
#define SHORT_LINE_THICK 4
#define SHORT_LINE_LENGTH SCREEN_WIDTH/30

#define PANGR_OFFET 20
#define CLIP_AREA_MIN_WH 60

/**
 *动画时间
 */
#define ANI_DURA 1

#define KBtnBaseViewHeight 50
#define kRotateNumMax 4

#define kWeakSelf(type)__weak typeof(type)weak##type = type;

#endif /* ConfigInfo_h */
