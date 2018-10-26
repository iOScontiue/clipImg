//
//  ColorCollectionView.h
//  DynamicEditImgLikeSystemFunction
//
//  Created by 卢育彪 on 2018/6/12.
//  Copyright © 2018年 luyubiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorCollectionViewCell.h"


@interface ColorCollectionView : UICollectionView<UICollectionViewDataSource, UICollectionViewDelegate>

//滤镜渲染——变色
@property (nonatomic, strong) GPUImageSepiaFilter *filter;
@property (nonatomic, strong) GPUImagePicture *staticPicture;

@property (nonatomic, strong) NSMutableArray *outPutImgArr;
@property (nonatomic, strong) NSMutableArray *selectedImgArr;
@property (nonatomic, strong) UIImage *inputImage;
@property (nonatomic, copy)  void(^selectItemBlock)(NSInteger selectCount);

@end
