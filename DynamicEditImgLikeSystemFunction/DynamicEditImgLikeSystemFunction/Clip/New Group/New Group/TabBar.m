//
//  TabBar.m
//  DynamicEditImgLikeSystemFunction
//
//  Created by 卢育彪 on 2018/4/25.
//  Copyright © 2018年 luyubiao. All rights reserved.
//

#import "TabBar.h"

//#define itemNameArr @[@"Cancel", @"Clip", @"Color", @"Done"]
#define itemNameArr @[@"Clip", @"Color", @"Done"]

@implementation TabBar

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews
{
    CGFloat width = SCREEN_WIDTH/itemNameArr.count;
    [itemNameArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *buttonName = (NSString *)obj;
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:buttonName forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
//        button.tag = 200+idx;
        button.tag = 201+idx;
        
        if (idx == 0) {
            button.selected = YES;
            button.userInteractionEnabled = YES;
        } else {
            button.selected = NO;
            button.userInteractionEnabled = NO;
        }
        
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(width, kHEIGHT));
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(idx*width);
        }];
    }];
}

- (void)btnClick:(UIButton *)sender
{
    sender.selected = YES;
    switch (sender.tag) {
        case TBItemCancelTag:
        {
            UIButton *clipItem = (UIButton *)[self viewWithTag:TBItemClipTag];
            UIButton *colorItem = (UIButton *)[self viewWithTag:TBItemColorTag];
            UIButton *doneItem = (UIButton *)[self viewWithTag:TBItemCDoneTag];
            clipItem.selected = NO;
            colorItem.selected = NO;
            doneItem.selected = NO;
        }
            break;
        case TBItemClipTag:
        {
            UIButton *cancelItem = (UIButton *)[self viewWithTag:TBItemCancelTag];
            UIButton *colorItem = (UIButton *)[self viewWithTag:TBItemColorTag];
            UIButton *doneItem = (UIButton *)[self viewWithTag:TBItemCDoneTag];
            cancelItem.selected = NO;
            colorItem.selected = NO;
            doneItem.selected = NO;
        }
            break;
        case TBItemColorTag:
        {
            UIButton *clipItem = (UIButton *)[self viewWithTag:TBItemClipTag];
            UIButton *cancelItem = (UIButton *)[self viewWithTag:TBItemCancelTag];
            UIButton *doneItem = (UIButton *)[self viewWithTag:TBItemCDoneTag];
            clipItem.selected = NO;
            cancelItem.selected = NO;
            doneItem.selected = NO;
        }
            break;
        case TBItemCDoneTag:
        {
            UIButton *clipItem = (UIButton *)[self viewWithTag:TBItemClipTag];
            UIButton *colorItem = (UIButton *)[self viewWithTag:TBItemColorTag];
            UIButton *cancelItem = (UIButton *)[self viewWithTag:TBItemCancelTag];
            clipItem.selected = NO;
            colorItem.selected = NO;
            cancelItem.selected = NO;
        }
            break;
        default:
            break;
    }
    
    if (self.tbItemBlock) {
        self.tbItemBlock(sender.tag);
    }
}

- (void)handleTabBarItemBlcok:(TabBarItemBlcok)block
{
    _tbItemBlock = block;
}

@end
