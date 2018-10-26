//
//  DoneViewController.h
//  DynamicEditImgLikeSystemFunction
//
//  Created by 卢育彪 on 2018/6/13.
//  Copyright © 2018年 luyubiao. All rights reserved.
//

#import "BaseViewController.h"
#import "DoneCollectionView.h"

@interface DoneViewController : BaseViewController

@property (nonatomic, strong) NSMutableArray *sourceImgArr;
@property (nonatomic, strong) DoneCollectionView *doneCollectionView;

@end
