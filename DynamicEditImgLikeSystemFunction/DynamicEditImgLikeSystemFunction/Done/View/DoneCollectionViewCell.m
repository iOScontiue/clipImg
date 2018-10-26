//
//  DoneCollectionViewCell.m
//  DynamicEditImgLikeSystemFunction
//
//  Created by 卢育彪 on 2018/6/13.
//  Copyright © 2018年 luyubiao. All rights reserved.
//

#import "DoneCollectionViewCell.h"

#define selectImgViewWH 15

@implementation DoneCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self.contentView addSubview:self.imgView];
        [self.contentView addSubview:self.selectedImgView];
    }
    return self;
}

- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.clipsToBounds = YES;
    }
    return _imgView;
}

- (UIImageView *)selectedImgView
{
    if (!_selectedImgView) {
        _selectedImgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imgView.frame)-selectImgViewWH/2.0, CGRectGetMinY(self.imgView.frame)-selectImgViewWH/2.0, selectImgViewWH, selectImgViewWH)];
        _selectedImgView.image = [UIImage imageNamed:@"icon_wancheng"];
        _selectedImgView.hidden = YES;
    }
    return _selectedImgView;
}

@end
