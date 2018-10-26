//
//  TabBar.h
//  DynamicEditImgLikeSystemFunction
//
//  Created by 卢育彪 on 2018/4/25.
//  Copyright © 2018年 luyubiao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TBItemTagType)
{
    TBItemCancelTag = 200,
    TBItemClipTag,
    TBItemColorTag,
    TBItemCDoneTag
};

typedef void(^TabBarItemBlcok)(NSInteger tag);
@interface TabBar : UIView

@property (nonatomic, copy) TabBarItemBlcok tbItemBlock;

- (void)handleTabBarItemBlcok:(TabBarItemBlcok)block;

@end
