//
//  DoneCollectionView.m
//  DynamicEditImgLikeSystemFunction
//
//  Created by 卢育彪 on 2018/6/13.
//  Copyright © 2018年 luyubiao. All rights reserved.
//

#import "DoneCollectionView.h"

#define cellIdentify @"DoneCollectionViewCell"

@implementation DoneCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self)
    {
        self.imgArr = [NSMutableArray array];
        self.selectedImgArr = [NSMutableArray array];
        //        self.backgroundColor = [UIColor orangeColor];
        [self registerClass:[DoneCollectionViewCell class] forCellWithReuseIdentifier:cellIdentify];
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

- (void)setImgArr:(NSMutableArray *)imgArr
{
    if (_imgArr != imgArr) {
        _imgArr = imgArr;
    }
    [self reloadData];
}

#pragma mark -
#pragma mark - UICollectionViewDataSource And UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imgArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DoneCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentify forIndexPath:indexPath];
    cell.imgView.image = self.imgArr[indexPath.item];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DoneCollectionViewCell *cell = (DoneCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.selectedImgView.hidden = NO;
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"是否保存到系统相册" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImage *img = self.imgArr[indexPath.row];
        
        UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
        NSString *imgPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", @"/Documents/image", @"."]];
        NSData *data = UIImagePNGRepresentation(img);
        [data writeToFile:imgPath atomically:YES];
        NSLog(@"HomeDirectory-------%@", NSHomeDirectory());
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        cell.selectedImgView.hidden = YES;
    }];
    [alertVC addAction:sureAction];
    [alertVC addAction:cancelAction];
    [self.viewController presentViewController:alertVC animated:YES completion:nil];
    
    
//    cell.selectedImgView.hidden = !cell.selectedImgView.hidden;
//    if (!cell.selectedImgView.hidden)
//    {
//        [self.selectedImgArr addObject:self.imgArr[indexPath.row]];
//    }
//    else
//    {
//        if (self.selectedImgArr.count > 0)
//        {
//            UIImage *cancelImg = self.imgArr[indexPath.row];
//            for (int i = 0; i < self.selectedImgArr.count; i++) {
//
//                UIImage *subImg = self.selectedImgArr[i];
//                if ([subImg isEqual:cancelImg]) {
//
//                    [self.selectedImgArr removeObjectAtIndex:i];
//                    break;
//                }
//            }
//        }
//    }
    
    //    NSLog(@"selectedImgArr----%ld", self.selectedImgArr.count);
}

#pragma mark -
#pragma mark - Save image callback

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = @"保存成功";
    if (error) {
        message = @"保存失败";
    }

    [MBProgressHUD wj_showPlainText:message hideAfterDelay:ANI_DURA view:self];
    
//    NSLog(@"save result :%@", message);
}

@end
