//
//  DoneCollectionView.h
//  DynamicEditImgLikeSystemFunction
//
//  Created by 卢育彪 on 2018/6/13.
//  Copyright © 2018年 luyubiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoneCollectionViewCell.h"

@interface DoneCollectionView : UICollectionView<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray *imgArr;
@property (nonatomic, strong) NSMutableArray *selectedImgArr;

@end
