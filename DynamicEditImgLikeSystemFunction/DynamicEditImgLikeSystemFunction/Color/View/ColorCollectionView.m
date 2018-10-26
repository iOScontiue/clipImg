//
//  ColorCollectionView.m
//  DynamicEditImgLikeSystemFunction
//
//  Created by 卢育彪 on 2018/6/12.
//  Copyright © 2018年 luyubiao. All rights reserved.
//

#import "ColorCollectionView.h"
#import <mach/mach.h>

#define cellIdentify @"ColorCollectionViewCell"

@implementation ColorCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self)
    {
        self.outPutImgArr = [NSMutableArray array];
        self.selectedImgArr = [NSMutableArray array];
//        self.backgroundColor = [UIColor orangeColor];
        [self registerClass:[ColorCollectionViewCell class] forCellWithReuseIdentifier:cellIdentify];
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

#pragma mark -
#pragma mark - setter and getter

-(GPUImageSepiaFilter *)filter
{
    if (!_filter) {
        _filter = [[GPUImageSepiaFilter alloc] init];
    }
    return _filter;
}

-(GPUImagePicture *)staticPicture
{
    if (!_staticPicture) {
        
        _staticPicture = [[GPUImagePicture alloc] init];
        [_staticPicture addTarget:self.filter];
    }
    return _staticPicture;
}

- (void)setInputImage:(UIImage *)inputImage
{
    if (_inputImage != inputImage) {
        _inputImage = inputImage;
    }
    
    //增加滤镜，渲染图片
    [self colorImg:_inputImage];
}

- (void)colorImg:(UIImage *)img
{
    [self.filter forceProcessingAtSize:img.size];
    self.staticPicture.image = img;
    
    if (self.outPutImgArr.count > 0) {
        [self.outPutImgArr removeAllObjects];
    }
    
    //图片太多，内存爆增，系统会自动杀掉app
//    [self.outPutImgArr addObject:img];
//    NSArray *paramArr = @[@"0.1", @"0.2", @"0.3", @"0.4", @"0.5", @"0.6", @"0.7", @"0.8", @"0.9", @"1.0"];
    NSArray *paramArr = @[@"0.3", @"0.5", @"0.7", @"0.9", @"1.0"];
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{

        dispatch_apply(paramArr.count, queue, ^(size_t index) {

            NSString *paramStr = paramArr[index];
            [self.filter setIntensity: paramStr.floatValue];
            [self.staticPicture processImage];
            [self.outPutImgArr addObject:[self.filter imageFromCurrentlyProcessedOutput]];
            
//            NSLog(@"memoryUsage------%lld", [self memoryUsage]);

            dispatch_async(dispatch_get_main_queue(), ^{
                [self reloadData];
            });
        });
        
//        NSLog(@"-------Done1");
        
    });
    
//    NSLog(@"-------Done2");
    
}

- (int64_t)memoryUsage {
    int64_t memoryUsageInByte = 0;
    task_vm_info_data_t vmInfo;
    mach_msg_type_number_t count = TASK_VM_INFO_COUNT;
    kern_return_t kernelReturn = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t) &vmInfo, &count);
    if(kernelReturn == KERN_SUCCESS) {
        memoryUsageInByte = (int64_t) vmInfo.phys_footprint;
        NSLog(@"Memory in use (in bytes): %lld", memoryUsageInByte);
    } else {
        NSLog(@"Error with task_info(): %s", mach_error_string(kernelReturn));
    }
    return memoryUsageInByte;
}

#pragma mark -
#pragma mark - UICollectionViewDataSource And UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.outPutImgArr.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = self.inputImage.size.width*kItemHeight/self.inputImage.size.height;
    return CGSizeMake(width, kItemHeight);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ColorCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentify forIndexPath:indexPath];
    cell.currentImg = self.outPutImgArr[indexPath.item];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ColorCollectionViewCell *cell = (ColorCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.selectedImgView.hidden = !cell.selectedImgView.hidden;
    
    if (!cell.selectedImgView.hidden)
    {
        [self.selectedImgArr addObject:self.outPutImgArr[indexPath.row]];
    }
    else
    {
        if (self.selectedImgArr.count > 0)
        {
            UIImage *cancelImg = self.outPutImgArr[indexPath.row];
            for (int i = 0; i < self.selectedImgArr.count; i++) {
                
                UIImage *subImg = self.selectedImgArr[i];
                if ([subImg isEqual:cancelImg]) {
                    
                    [self.selectedImgArr removeObjectAtIndex:i];
                    break;
                }
            }
        }
    }
    
    if (self.selectItemBlock) {
        self.selectItemBlock(self.selectedImgArr.count);
    }
}

@end
