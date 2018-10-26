//
//  DoneViewController.m
//  DynamicEditImgLikeSystemFunction
//
//  Created by 卢育彪 on 2018/6/13.
//  Copyright © 2018年 luyubiao. All rights reserved.
//

#import "DoneViewController.h"

@interface DoneViewController ()

@end

@implementation DoneViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    
    self.title = @"选择图片";
    [self.view addSubview:self.doneCollectionView];
    self.doneCollectionView.imgArr = self.sourceImgArr;
}

- (DoneCollectionView *)doneCollectionView
{
    if (!_doneCollectionView)
    {
        NSInteger columnCount = 3;
        CGFloat distance = 10;
        CGFloat sectionLR = 20;
        CGFloat sectionTB = 10;
        CGFloat itemWH = (SCREEN_WIDTH-(columnCount-1)*distance-2*sectionLR)/columnCount;
        
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake(itemWH, itemWH);
        layout.minimumLineSpacing = distance;
        layout.sectionInset = UIEdgeInsetsMake(sectionTB, sectionLR, sectionTB, sectionLR);
        
        _doneCollectionView = [[DoneCollectionView alloc]initWithFrame:CGRectMake(0, NavgationHeight, SCREEN_WIDTH, SCREEN_HEIGHT-NavgationHeight) collectionViewLayout:layout];
    }
    return _doneCollectionView;
}

@end
