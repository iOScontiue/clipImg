//
//  ClipImagePage.m
//  DynamicEditImgLikeSystemFunction
//
//  Created by 卢育彪 on 2018/4/25.
//  Copyright © 2018年 luyubiao. All rights reserved.
//

#import "ClipImagePage.h"

#define CLIP_AREA_WIDTH_MAX [UIScreen mainScreen].bounds.size.width-2*KClipAreaEdge
#define btnWidth 100
#define kSliderHeight 50
#define kValueLabelWidth 100
#define kBaseViewLR 10

@interface ClipImagePage ()

@end

@implementation ClipImagePage

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    
    self.clipAreaCenterX = self.view.center.x;
    self.clipAreaCenterY = self.view.center.y-KClipAreaYOffset;
    self.targetImg = [UIImage imageNamed:@"TARGET_IMAGE"];
    
    [self createOriginalViews];
}

#pragma mark -
#pragma mark - init subViews

- (void)createOriginalViews
{
    [self.view addSubview:self.originalImgView];
    [self.view addSubview:self.editBtn];
    
    [self configClipAreaWidthIf:SCREEN_WIDTH HeightIf:SCREEN_WIDTH*9/16 OriginalWidth:self.targetImg.size.width OriginalHeight:self.targetImg.size.height];
    
    self.originalImgView.frame = CGRectMake(self.view.center.x-self.clipAreaWidth/2.0, self.view.center.y-self.clipAreaHeight/2.0, self.clipAreaWidth, self.clipAreaHeight);
    
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 80));
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.originalImgView.mas_bottom).offset(30);
    }];
}

- (void)initializeData
{
    _isClickColor = NO;
    _valueOffset = M_PI_2;
    _rorateNum = 0;
    self.clipAreaWidth = 0;
    self.clipAreaHeight = 0;
}

- (void)createSubViews
{
    //initialize data
    [self initializeData];
    
    //GestureRecognizer
    
    self.panGesRec = [[PanGesRec alloc] initWithTarget:self Action:@selector(handlePanGes:) InView:self.view];
     self.pinGesRec = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinGes:)];
    
    //self.imgView
    
    self.imgView = [[UIImageView alloc] init];
    self.imgView.contentMode = UIViewContentModeScaleAspectFit;
    self.imgView.image = self.targetImg;
    
    //self.shaView
    
    self.shaView = [[ShadowView alloc] init];
    
    //self.myTabBar
    
    self.myTabBar = [[TabBar alloc] init];
    self.myTabBar.backgroundColor = [UIColor clearColor];
    self.myTabBar.hidden = YES;
    [self.myTabBar handleTabBarItemBlcok:^(NSInteger tag) {
        [self handleBtnEvent:tag];
    }];
    
    //self.clipBtnBaseView
    
    self.clipBtnBaseView = [[UIView alloc] initWithFrame:CGRectMake(kBaseViewLR, SCREEN_HEIGHT-KBtnBaseViewHeight-kHEIGHT, SCREEN_WIDTH-kBaseViewLR*2, KBtnBaseViewHeight)];
    self.clipBtnBaseView.hidden = YES;
    self.clipBtnBaseView.backgroundColor = [UIColor clearColor];
    
    UIButton *rotateBtn = [[UIButton alloc] init];
    [rotateBtn setTitle:@"rotate90" forState:UIControlStateNormal];
    [rotateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rotateBtn.tag = 301;
    [rotateBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.clipBtnBaseView addSubview:rotateBtn];
    [rotateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(btnWidth, CGRectGetHeight(self.clipBtnBaseView.frame)));
        make.left.equalTo(self.clipBtnBaseView).offset(0);
        make.centerY.equalTo(self.clipBtnBaseView).offset(0);
    }];
    
//    self.resetBtn = [[UIButton alloc] init];
//    [self.resetBtn setTitle:@"RESET" forState:UIControlStateNormal];
//    [self.resetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    self.resetBtn.tag = 303;
//    self.resetBtn.hidden = YES;
//    [self.resetBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.clipBtnBaseView addSubview:self.resetBtn];
//    [self.resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(btnWidth, CGRectGetHeight(self.clipBtnBaseView.frame)));
//        make.center.equalTo(self.clipBtnBaseView);
//    }];
    
    UIButton *scaleBtn = [[UIButton alloc] init];
    [scaleBtn setTitle:@"scale" forState:UIControlStateNormal];
    [scaleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    scaleBtn.tag = 302;
    scaleBtn.hidden = YES;//暂时隐藏，先不用
    [scaleBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.clipBtnBaseView addSubview:scaleBtn];
    [scaleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(btnWidth, CGRectGetHeight(self.clipBtnBaseView.frame)));
        make.right.equalTo(self.clipBtnBaseView).offset(0);
        make.centerY.equalTo(self.clipBtnBaseView).offset(0);
    }];
    
    //self.colorCollectionView
    
    CGFloat distance = 10;
    CGFloat collectionViewHeight = 2*distance+kItemHeight;
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = distance;
    layout.sectionInset = UIEdgeInsetsMake(distance, distance, distance, distance);
    
    kWeakSelf(self)
    self.colorCollectionView = [[ColorCollectionView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-kHEIGHT-collectionViewHeight, SCREEN_WIDTH,collectionViewHeight) collectionViewLayout:layout];
    self.colorCollectionView.selectItemBlock = ^(NSInteger selectCount) {
        UIButton *doneBtn = (UIButton *)[weakself.myTabBar viewWithTag:TBItemCDoneTag];
        if (selectCount > 0) {
            doneBtn.selected = YES;
            doneBtn.userInteractionEnabled = YES;
        } else {
            doneBtn.selected = NO;
            doneBtn.userInteractionEnabled = NO;
        }
    };
    self.colorCollectionView.hidden = YES;
    
    //self.clipImgView
    self.clipImgView = [[UIImageView alloc] init];
    
    //self.clipAreaLayer
    
    self.clipAreaLayer = [[ClipAreaLayer alloc] init];
    self.clipAreaLayer.frame = self.view.bounds;
//    self.clipAreaLayer.fillRule = kCAFillRuleEvenOdd;//生成一个空心遮罩
//    self.clipAreaLayer.fillColor = [UIColor whiteColor].CGColor;
//    self.clipAreaLayer.opacity = 0.5;
    
    [self.view addSubview:self.imgView];
    [self.view addSubview:self.shaView];
    [self.view addSubview:self.myTabBar];
    [self.view addSubview:self.clipBtnBaseView];
    [self.view addSubview:self.colorCollectionView];
    [self.view addSubview:self.clipImgView];
    [self.view.layer addSublayer:self.clipAreaLayer];
    
    [self configClipAreaWidthIf:SCREEN_WIDTH HeightIf:SCREEN_WIDTH*9/16 OriginalWidth:self.targetImg.size.width OriginalHeight:self.targetImg.size.height];
    
    //根据图片的缩放，动态配置view的宽高
    //    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.size.mas_equalTo(CGSizeMake(self.clipAreaWidth, self.clipAreaHeight));
    //        make.center.equalTo(self.view);
    //    }];
    self.imgView.frame = CGRectMake(self.view.center.x-self.clipAreaWidth/2.0, self.view.center.y-self.clipAreaHeight/2.0, self.clipAreaWidth, self.clipAreaHeight);
    
    [self.myTabBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view).offset(0);
        make.height.offset(kHEIGHT);
    }];
    
    NSLog(@"self.targetImg---1---%@", self.targetImg);
    NSLog(@"self.imgView.frame---1---%@", NSStringFromCGRect(self.imgView.frame));
}

#pragma mark -
#pragma mark - Getters And Setters

-(UIImageView *)originalImgView
{
    if (!_originalImgView) {
        _originalImgView = [[UIImageView alloc] init];
        _originalImgView.contentMode = UIViewContentModeScaleAspectFit;
        _originalImgView.image = self.targetImg;
    }
    return _originalImgView;
}

-(UIButton *)editBtn
{
    if (!_editBtn) {
        _editBtn = [[UIButton alloc] init];
        [_editBtn setTitle:@"Edit" forState:UIControlStateNormal];
        [_editBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _editBtn.tag = 300;
        [_editBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editBtn;
}

//- (PanGesRec *)panGesRec
//{
//    if (!_panGesRec) {
//        _panGesRec = [[PanGesRec alloc] initWithTarget:self Action:@selector(handlePanGes:) InView:self.view];
//    }
//    return _panGesRec;
//}
//
//- (UIPinchGestureRecognizer *)pinGesRec
//{
//    if (!_pinGesRec) {
//        _pinGesRec = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinGes:)];
//    }
//    return _pinGesRec;
//}

//图片编辑前展示的预设区域
- (void)configClipAreaWidthIf:(CGFloat)widthIf HeightIf:(CGFloat)heightIf OriginalWidth:(CGFloat)oriWidht OriginalHeight:(CGFloat)oriHeight
{
    //当图片宽与裁剪区域宽之比大于图片高与裁剪区域高之比时，将图片高铺满裁剪区域高，图片宽成比例放大;反之亦然——————目的：保证图片至少填满预设区域
    if (oriWidht/widthIf <= oriHeight/heightIf) {
        
        self.clipAreaWidth = widthIf;
        self.clipAreaHeight = oriHeight *(self.clipAreaWidth/oriWidht);
    } else {
        self.clipAreaHeight = heightIf;
        self.clipAreaWidth = oriWidht *(self.clipAreaHeight/oriHeight);
    }
}

- (void)slider:(UISlider *)sl
{
    
}

//处理tabbarItem的点击事件
- (void)handleBtnEvent:(NSInteger)tag
{
    if (tag != TBItemCDoneTag) {
        UIButton *currentBtn = (UIButton *)[self.myTabBar viewWithTag:tag];
        currentBtn.selected = NO;
        currentBtn.userInteractionEnabled = NO;
    }
    
    self.pinGesRec.enabled = NO;
    self.panGesRec.enabled = NO;
    
    //处理缩放后点击触发阴影效果
    if (_isClickColor) {
        self.imgView.hidden = YES;
    }else{
        self.imgView.hidden = NO;
    }
    
    switch (tag) {
//        case TBItemCancelTag:
//        {
//            //编辑：是，弹出sheet；否，直接返回原页面
//            [self showAnimationWithColor:[UIColor clearColor] TBHidden:YES EditBtnHidden:NO FlagStr:@"cancel"];
//        }
//            break;
        case TBItemClipTag:
        {
            /*四个事件
             *1.图片往上移——带动画；
             *2.增加裁剪框；
             *3.增加罗盘；
             *4.增加左右按钮——左：90度旋转；右：缩放比例列表
             */
            
            UIButton *colorBtn = (UIButton *)[self.myTabBar viewWithTag:TBItemColorTag];
            colorBtn.selected = YES;
            colorBtn.userInteractionEnabled = YES;
            
            self.colorCollectionView.hidden = YES;
            self.clipBtnBaseView.hidden = NO;
            self.pinGesRec.enabled = YES;
            self.panGesRec.enabled = YES;
//            self.resetBtn.hidden = YES;
            
            [self moveUpForImgView:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)1.0*NSEC_PER_SEC), dispatch_get_main_queue()
                           , ^{
                               self.clipAreaLayer.hidden = NO;
                               [self setUpClipLayer:YES];
                               self.preClipAreaFrame = CGRectMake(self.clipAreaLayer.leftEdge, self.clipAreaLayer.topEdge, self.clipAreaWidth, self.clipAreaHeight);
                           });
            [self addAllGestures];
            _originalImgViewFrame = self.imgView.frame;
        }
            break;
        case TBItemColorTag:
        {
            //根据裁剪的新图片重新设置imgView的frame
            
            _isClickColor = YES;
            
            self.imgView.hidden = YES;
            self.clipBtnBaseView.hidden = YES;
            self.clipAreaLayer.hidden = YES;
            self.colorCollectionView.hidden = NO;
            self.clipImgView.hidden = NO;
            
            UIImage *clipImg = [self clipDownOriginalImg];
            CGSize imgViewSize = [self adjustImgViewWithImgSize:clipImg.size];
            
            self.clipImgView.image = clipImg;
            self.clipImgView.frame = CGRectMake(0, 0, imgViewSize.width, imgViewSize.height);
            self.clipImgView.center = CGPointMake(self.clipAreaCenterX, self.clipAreaCenterY);
            
            self.colorCollectionView.inputImage = clipImg;
        }
            break;
        case TBItemCDoneTag:
        {
            self.clipBtnBaseView.hidden = YES;
            self.clipAreaLayer.hidden = YES;
            self.imgView.hidden = YES;
            self.colorCollectionView.hidden = NO;
            
            if (self.colorCollectionView.selectedImgArr.count == 0) {
                [MBProgressHUD wj_showPlainText:@"请选择图片" hideAfterDelay:ANI_DURA view:self.view];
            }else{
                DoneViewController *vc = [DoneViewController new];
                vc.sourceImgArr = self.colorCollectionView.selectedImgArr;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        default:
            break;
    }
}

//要的是实际图片的大小
- (UIImage *)clipDownOriginalImg
{
    CGFloat imageScale = MIN(self.imgView.frame.size.width/self.targetImg.size.width, self.imgView.frame.size.height/self.targetImg.size.height);
    CGFloat clipX = (self.clipAreaLayer.leftEdge - self.imgView.frame.origin.x)/imageScale;
    CGFloat clipY = (self.clipAreaLayer.topEdge - self.imgView.frame.origin.y)/imageScale;
    CGFloat clipWidth = self.clipAreaWidth/imageScale;
    CGFloat clipHeight = self.clipAreaHeight/imageScale;
    CGRect clipImgRect = CGRectMake(clipX, clipY, clipWidth, clipHeight);
    
    CGImageRef sourceImageRef = [self.targetImg CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, clipImgRect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    CGImageRelease(newImageRef);
    
    return newImage;
}

- (void)configShadowArea
{
//    self.resetBtn.hidden = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        CATransition *tran = [CATransition animation];
        tran.type = @"moveIn";
        tran.subtype = kCATransitionFade;
        tran.duration = 0.5;
        [self.shaView.layer addAnimation:tran forKey:nil];
        
        self.shaView.frame = self.imgView.frame;
        //坐标转换——shaView中的drawRect:方法是以自己为坐标原点绘图
        CGRect rect = [self.view convertRect:CGRectMake(self.clipAreaLayer.leftEdge, self.clipAreaLayer.topEdge, self.clipAreaWidth, self.clipAreaHeight) toView:self.shaView];
        self.shaView.isSetShadow = YES;
        self.shaView.highLightArea = rect;
    });
}

- (void)btnClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 300://开始编辑
        {
            self.originalImgView.hidden = YES;
            [self createSubViews];
            
            [self showAnimationWithColor:[UIColor blackColor] TBHidden:NO EditBtnHidden:YES FlagStr:@"edit"];
        }
            break;
        case 301://旋转90度——顺时针
        {
            _rorateNum++;
            
            [UIView animateWithDuration:0.5 animations:^{
                self.shaView.isSetShadow = NO;
            }];
            self.clipAreaLayer.hidden = YES;
            CGFloat dura = 1.0f;
            
            //旋转前：记录imgView与clipAreaLayer左边和底边的距离
            CGFloat preRoOffsetX = fabs(CGRectGetMaxY(self.imgView.frame)-self.clipAreaLayer.bottomEdge);
            CGFloat preRoOffsetY = fabs(CGRectGetMinX(self.imgView.frame)-self.clipAreaLayer.leftEdge);
            
            //旋转
            [UIView animateWithDuration:dura animations:^{
                CGAffineTransform trans = CGAffineTransformMakeRotation(_valueOffset);
                self.imgView.transform = trans;
            }];
            
            _valueOffset += M_PI_2;
            if (_rorateNum == kRotateNumMax) {
                _valueOffset = M_PI_2;
                _rorateNum = 0;
            }
            
            //切换坐标——imgView的frame自动修正
            [self changeXYWithRotation:_valueOffset];
            UIImage *agerImage = [self getRotatedImg];
            self.targetImg = agerImage;
            
            CGFloat temp = self.clipAreaWidth;
            self.clipAreaWidth = self.clipAreaHeight;
            self.clipAreaHeight = temp;
            CGFloat scale = [self drawClipArea];
//            [self setUpClipLayer:YES];
            
            //旋转后：调整imgView的位置——左变上，底变左
            self.imgView.frame = CGRectMake(self.clipAreaLayer.leftEdge-preRoOffsetX, self.clipAreaLayer.topEdge-preRoOffsetY, CGRectGetWidth(self.imgView.frame), CGRectGetHeight(self.imgView.frame));
            
            //缩放
            CABasicAnimation *baAniScale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            baAniScale.beginTime = dura;
            baAniScale.duration = dura;
            baAniScale.fromValue = @1;
            baAniScale.toValue = @(scale);
            [self.imgView.layer addAnimation:baAniScale forKey:nil];
            
            //缩放后调整imgView的位置
            CGFloat imgViewX = 0;
            CGFloat imgViewY = 0;
            CGFloat imgWidth = CGRectGetWidth(self.imgView.frame)*scale;
            CGFloat imgHeight = CGRectGetHeight(self.imgView.frame)*scale;

            imgViewX = self.clipAreaLayer.leftEdge-preRoOffsetX*scale;
            imgViewY = self.clipAreaLayer.topEdge-preRoOffsetY*scale;
            
            //修正imgView位置
            self.imgView.frame = CGRectMake(imgViewX, imgViewY, imgWidth, imgHeight);
            
            //修正clipAreaLayer位置
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.clipAreaLayer.hidden = NO;
            });
            
            [self configShadowArea];
        }
            break;
        case 302://比例缩放
        {
            
        }
            break;
//        case 303://剪裁重置
//        {
//            [self initializeData];
//
//            self.targetImg = self.imgView.image;
//
//            if (self.imgView) {
//                [self.imgView removeFromSuperview];
//            }
//
//            if (self.clipAreaLayer) {
//                [self.clipAreaLayer removeFromSuperlayer];
//            }
//
//            self.imgView = [[UIImageView alloc] init];
//            self.imgView.contentMode = UIViewContentModeScaleAspectFit;
//            self.imgView.image = self.targetImg;
//            [self.view addSubview:self.imgView];
//            [self moveUpForImgView:NO];
//
//            self.clipAreaLayer = [[ClipAreaLayer alloc] init];
//            self.clipAreaLayer.frame = self.view.bounds;
//            [self.view.layer addSublayer:self.clipAreaLayer];
////            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)1.0*NSEC_PER_SEC), dispatch_get_main_queue()
////                           , ^{
//                               self.clipAreaLayer.hidden = NO;
//                               [self setUpClipLayer:YES];
//                               self.preClipAreaFrame = CGRectMake(self.clipAreaLayer.leftEdge, self.clipAreaLayer.topEdge, self.clipAreaWidth, self.clipAreaHeight);
////                           });
////            [self addAllGestures];
//            [self.view bringSubviewToFront:self.shaView];
//            _originalImgViewFrame = self.imgView.frame;
//
////            self.resetBtn.hidden = YES;
//            NSLog(@"self.targetImg---2---%@", self.targetImg);
//        }
//            break;
        default:
            break;
    }
}

- (void)changeXYWithRotation:(float)rotate
{
    CGRect imgViewRect = CGRectMake(0, 0, self.imgView.frame.size.height, self.imgView.frame.size.width);
    UIGraphicsBeginImageContext(imgViewRect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextRotateCTM(context, rotate);
    CGContextRestoreGState(context);
}

- (UIImage *)getRotatedImg
{
    //使用绘制的方法得到旋转之后的图片
    double rotationZ = [[self.imgView.layer valueForKeyPath:@"transform.rotation.z"] doubleValue];
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.imgView.image.size.width, self.imgView.image.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(rotationZ);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    UIGraphicsBeginImageContextWithOptions(rotatedSize, NO, self.imgView.image.scale);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    CGContextRotateCTM(bitmap,rotationZ);
    CGContextScaleCTM(bitmap, 1, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.imgView.image.size.width / 2, -self.imgView.image.size.height / 2, self.imgView.image.size.width, self.imgView.image.size.height), [self.imgView.image CGImage]);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)showAnimationWithColor:(UIColor *)color TBHidden:(BOOL)isTBHidden EditBtnHidden:(BOOL)isEditBtn FlagStr:(NSString *)flag
{
    if ([flag isEqualToString:@"cancel"]) {
        
        UIAlertController *alertContrl = [UIAlertController alertControllerWithTitle:@"是否取消" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertContrl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }]];
        
        [alertContrl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [UIView animateWithDuration:0.3 animations:^{
                
                [self removeSubViews];
                
                self.originalImgView.hidden = NO;
                self.view.backgroundColor = color;
                self.editBtn.hidden = isEditBtn;
            }];
        }]];
        
        [self presentViewController:alertContrl animated:YES completion:nil];
        
    }else if ([flag isEqualToString:@"edit"]){
        
        self.colorCollectionView.hidden = YES;
        self.myTabBar.hidden = YES;
        self.clipBtnBaseView.hidden = YES;
        self.clipImgView.hidden = YES;
        
        self.view.backgroundColor = color;
        self.myTabBar.hidden = isTBHidden;
        self.editBtn.hidden = isEditBtn;
    }
}

- (void)removeSubViews
{
    
}

//动画效果
- (void)animationMoveWithLayer:(CALayer *)layer FromPoint:(CGPoint)fp ToPoint:(CGPoint)tp Duration:(CGFloat)dura
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, fp.x, fp.y);
    CGPathAddLineToPoint(path, NULL, tp.x, tp.y);
    
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyAnimation.removedOnCompletion = NO;
    keyAnimation.duration = dura;
    keyAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    keyAnimation.path = path;
    CGPathRelease(path);
    [layer addAnimation:keyAnimation forKey:nil];
}

- (void)moveUpForImgView:(BOOL)isMove
{
    if (isMove) {
        [self animationMoveWithLayer:self.imgView.layer FromPoint:CGPointMake(self.view.center.x, self.view.center.y) ToPoint:CGPointMake(self.view.center.x, self.view.center.y-KClipAreaYOffset) Duration:0.7];
    }
    
    CGFloat widthIf = CLIP_AREA_WIDTH_MAX;
    CGFloat heightIf = widthIf*9/16;
    [self configClipAreaWidthIf:widthIf HeightIf:heightIf OriginalWidth:self.targetImg.size.width OriginalHeight:self.targetImg.size.height];
    
    [self updateImgViewFrameWithCenterYOffset:0 CenterXOffset:0 Width:self.clipAreaWidth Height:self.clipAreaHeight];
}

#pragma mark -
#pragma mark - AddGestures

- (void)addAllGestures
{
    //捏合手势
    [self.view addGestureRecognizer:self.pinGesRec];
    
    //拖动手势
    [self.view addGestureRecognizer:self.panGesRec];
}

- (void)handlePanGes:(PanGesRec *)panGes
{
    CGPoint translation = [panGes translationInView:self.imgView.superview];
    CGPoint movePoint = panGes.movedPoint;
    
    //判断开始滑动时的滑动对象:top、bottom、left、right
    if (panGes.state == GR_BEGIN) {
        
        //再次开始移动，shaView整体高亮
        [UIView animateWithDuration:0.5 animations:^{
            self.shaView.isSetShadow = NO;
        }];
        
        if ([self judgeGesRecInViewWithMinX:self.clipAreaLayer.leftEdge+SHORT_LINE_LENGTH MaxX:self.clipAreaLayer.rightEdge-SHORT_LINE_LENGTH MinY:self.clipAreaLayer.topEdge-PANGR_OFFET MaxY:self.clipAreaLayer.topEdge+PANGR_OFFET]) {
            self.acGeView = CLIP_AREA_TOP;
        } else if ([self judgeGesRecInViewWithMinX:self.clipAreaLayer.leftEdge+SHORT_LINE_LENGTH MaxX:self.clipAreaLayer.rightEdge-SHORT_LINE_LENGTH MinY:self.clipAreaLayer.bottomEdge-PANGR_OFFET MaxY:self.clipAreaLayer.bottomEdge+PANGR_OFFET]) {
            self.acGeView = CLIP_AREA_BOTTOM;
        } else if ([self judgeGesRecInViewWithMinX:self.clipAreaLayer.leftEdge-PANGR_OFFET MaxX:self.clipAreaLayer.leftEdge+PANGR_OFFET MinY:self.clipAreaLayer.topEdge+SHORT_LINE_LENGTH MaxY:self.clipAreaLayer.bottomEdge-SHORT_LINE_LENGTH]) {
            self.acGeView = CLIP_AREA_LEFT;
        } else if ([self judgeGesRecInViewWithMinX:self.clipAreaLayer.rightEdge-PANGR_OFFET MaxX:self.clipAreaLayer.rightEdge+PANGR_OFFET MinY:self.clipAreaLayer.topEdge+SHORT_LINE_LENGTH MaxY:self.clipAreaLayer.bottomEdge-SHORT_LINE_LENGTH]) {
            self.acGeView = CLIP_AREA_RIGHT;
        } else if ([self judgeGesRecInViewWithMinX:self.clipAreaLayer.leftEdge-PANGR_OFFET MaxX:self.clipAreaLayer.leftEdge+PANGR_OFFET MinY:self.clipAreaLayer.topEdge MaxY:self.clipAreaLayer.topEdge+SHORT_LINE_LENGTH] || [self judgeGesRecInViewWithMinX:self.clipAreaLayer.leftEdge MaxX:self.clipAreaLayer.leftEdge+SHORT_LINE_LENGTH MinY:self.clipAreaLayer.topEdge-PANGR_OFFET MaxY:self.clipAreaLayer.topEdge+PANGR_OFFET]){
            self.acGeView = CLIP_AREA_LT;
        } else if ([self judgeGesRecInViewWithMinX:self.clipAreaLayer.leftEdge-PANGR_OFFET MaxX:self.clipAreaLayer.leftEdge+PANGR_OFFET MinY:self.clipAreaLayer.bottomEdge-SHORT_LINE_LENGTH MaxY:self.clipAreaLayer.bottomEdge] || [self judgeGesRecInViewWithMinX:self.clipAreaLayer.leftEdge MaxX:self.clipAreaLayer.leftEdge+SHORT_LINE_LENGTH MinY:self.clipAreaLayer.bottomEdge-PANGR_OFFET MaxY:self.clipAreaLayer.bottomEdge+PANGR_OFFET]){
            self.acGeView = CLIP_AREA_LB;
        } else if ([self judgeGesRecInViewWithMinX:self.clipAreaLayer.rightEdge-PANGR_OFFET MaxX:self.clipAreaLayer.rightEdge+PANGR_OFFET MinY:self.clipAreaLayer.topEdge MaxY:self.clipAreaLayer.topEdge+SHORT_LINE_LENGTH] || [self judgeGesRecInViewWithMinX:self.clipAreaLayer.rightEdge-SHORT_LINE_LENGTH MaxX:self.clipAreaLayer.rightEdge MinY:self.clipAreaLayer.topEdge-PANGR_OFFET MaxY:self.clipAreaLayer.topEdge+PANGR_OFFET]){
            self.acGeView = CLIP_AREA_RT;
        } else if ([self judgeGesRecInViewWithMinX:self.clipAreaLayer.rightEdge-PANGR_OFFET MaxX:self.clipAreaLayer.rightEdge+PANGR_OFFET MinY:self.clipAreaLayer.bottomEdge-SHORT_LINE_LENGTH MaxY:self.clipAreaLayer.bottomEdge] || [self judgeGesRecInViewWithMinX:self.clipAreaLayer.rightEdge-SHORT_LINE_LENGTH MaxX:self.clipAreaLayer.rightEdge MinY:self.clipAreaLayer.bottomEdge-PANGR_OFFET MaxY:self.clipAreaLayer.bottomEdge+PANGR_OFFET]){
            self.acGeView = CLIP_AREA_RB;
        } else {
            self.acGeView = IMAGE_VIEW;
            [self.imgView setCenter:CGPointMake(self.imgView.center.x+translation.x, self.imgView.center.y+translation.y)];
            [panGes setTranslation:CGPointZero inView:self.imgView.superview];
        }
    }
    
    
    //滑动过程中位置改变
    CGFloat offsetX = 0;
    CGFloat offsetY = 0;
    if (panGes.state == GR_CHANGED) {
        switch (self.acGeView) {
            case CLIP_AREA_TOP:
            {
                offsetY = movePoint.y-self.clipAreaLayer.topEdge;
                
                if (offsetY >=0 && self.clipAreaHeight >= CLIP_AREA_MIN_WH) {
                    self.clipAreaHeight -= fabs(offsetY);
                    self.clipAreaLayer.topEdge += fabs(offsetY);
                } else if(offsetY < 0 && self.clipAreaLayer.topEdge >= CLIP_VIEW_TOP_MIN) {
                    self.clipAreaHeight += fabs(offsetY);
                    self.clipAreaLayer.topEdge -= fabs(offsetY);
                    [self scaleImgForTop];
                }
            }
                break;
            case CLIP_AREA_BOTTOM:
            {
                offsetY = movePoint.y-self.clipAreaLayer.bottomEdge;
                if (offsetY >= 0 && self.clipAreaLayer.bottomEdge <= SCREEN_HEIGHT-CLIP_VIEW_BOTTOM_MAX) {
                    self.clipAreaHeight += fabs(offsetY);
                    self.clipAreaLayer.bottomEdge += fabs(offsetY);
                    [self scaleImgForBottom];
                } else if (offsetY < 0 && self.clipAreaHeight >= CLIP_AREA_MIN_WH){
                    self.clipAreaHeight -= fabs(offsetY);
                    self.clipAreaLayer.bottomEdge -= fabs(offsetY);
                }
            }
                break;
            case CLIP_AREA_LEFT:
            {
                offsetX = movePoint.x-self.clipAreaLayer.leftEdge;
                if (offsetX >= 0 && self.clipAreaWidth >= CLIP_AREA_MIN_WH) {
                    self.clipAreaWidth -= fabs(offsetX);
                    self.clipAreaLayer.leftEdge += fabs(offsetX);
                }else if (offsetX < 0 && self.clipAreaLayer.leftEdge >= CLIP_VIEW_LR_MIN){
                    self.clipAreaWidth += fabs(offsetX);
                    self.clipAreaLayer.leftEdge -= fabs(offsetX);
                }
            }
                break;
            case CLIP_AREA_RIGHT:
            {
                offsetX = movePoint.x-self.clipAreaLayer.rightEdge;
                if (offsetX >= 0 && self.clipAreaLayer.rightEdge <= SCREEN_WIDTH-CLIP_VIEW_LR_MIN) {
                    self.clipAreaWidth += fabs(offsetX);
                    self.clipAreaLayer.rightEdge += fabs(offsetX);
                } else if (offsetX < 0 && self.clipAreaWidth >= CLIP_AREA_MIN_WH){
                    self.clipAreaWidth -= fabs(offsetX);
                    self.clipAreaLayer.rightEdge -= fabs(offsetX);
                }
            }
                break;
            case CLIP_AREA_LT:
            {
                offsetX = movePoint.x-self.clipAreaLayer.leftEdge;
                offsetY = movePoint.y-self.clipAreaLayer.topEdge;
                if (offsetX >= 0 && offsetY >= 0 && self.clipAreaWidth >= CLIP_AREA_MIN_WH && self.clipAreaHeight >= CLIP_AREA_MIN_WH) {
                    self.clipAreaWidth -= fabs(offsetX);
                    self.clipAreaHeight -= fabs(offsetY);
                    self.clipAreaLayer.leftEdge += fabs(offsetX);
                    self.clipAreaLayer.topEdge += fabs(offsetY);
                }else if (offsetX < 0 && offsetY < 0 && self.clipAreaLayer.leftEdge >= CLIP_VIEW_LR_MIN && self.clipAreaLayer.topEdge >= CLIP_VIEW_TOP_MIN){
                    self.clipAreaWidth += fabs(offsetX);
                    self.clipAreaHeight += fabs(offsetY);
                    self.clipAreaLayer.leftEdge -= fabs(offsetX);
                    self.clipAreaLayer.topEdge -= fabs(offsetY);
                    [self scaleImgForTop];
                }
            }
                break;
            case CLIP_AREA_LB:
            {
                offsetX = movePoint.x-self.clipAreaLayer.leftEdge;
                offsetY = movePoint.y-self.clipAreaLayer.bottomEdge;
                if (offsetX >= 0 && offsetY <= 0 && self.clipAreaWidth >= CLIP_AREA_MIN_WH && self.clipAreaHeight >= CLIP_AREA_MIN_WH) {
                    self.clipAreaWidth -= fabs(offsetX);
                    self.clipAreaHeight -= fabs(offsetY);
                    self.clipAreaLayer.leftEdge += fabs(offsetX);
                    self.clipAreaLayer.bottomEdge -= fabs(offsetY);
                }else if (offsetX < 0 && offsetY > 0 && self.clipAreaLayer.leftEdge >= CLIP_VIEW_LR_MIN && self.clipAreaLayer.bottomEdge <= SCREEN_HEIGHT-CLIP_VIEW_BOTTOM_MAX){
                    self.clipAreaWidth += fabs(offsetX);
                    self.clipAreaHeight += fabs(offsetY);
                    self.clipAreaLayer.leftEdge -= fabs(offsetX);
                    self.clipAreaLayer.bottomEdge += fabs(offsetY);
                    [self scaleImgForBottom];
                }
            }
                break;
            case CLIP_AREA_RT:
            {
                offsetX = movePoint.x-self.clipAreaLayer.rightEdge;
                offsetY = movePoint.y-self.clipAreaLayer.topEdge;
                if (offsetX <= 0 && offsetY >= 0 && self.clipAreaWidth >= CLIP_AREA_MIN_WH && self.clipAreaHeight >= CLIP_AREA_MIN_WH) {
                    self.clipAreaWidth -= fabs(offsetX);
                    self.clipAreaHeight -= fabs(offsetY);
                    self.clipAreaLayer.rightEdge -= fabs(offsetX);
                    self.clipAreaLayer.topEdge += fabs(offsetY);
                }else if (offsetX > 0 && offsetY < 0 && self.clipAreaLayer.rightEdge <= SCREEN_WIDTH-CLIP_VIEW_LR_MIN && self.clipAreaLayer.topEdge >= CLIP_VIEW_TOP_MIN){
                    self.clipAreaWidth += fabs(offsetX);
                    self.clipAreaHeight += fabs(offsetY);
                    self.clipAreaLayer.rightEdge += fabs(offsetX);
                    self.clipAreaLayer.topEdge -= fabs(offsetY);
                    [self scaleImgForTop];
                }
            }
                break;
            case CLIP_AREA_RB:
            {
                offsetX = movePoint.x-self.clipAreaLayer.rightEdge;
                offsetY = movePoint.y-self.clipAreaLayer.bottomEdge;
                if (offsetX <= 0 && offsetY <= 0 && self.clipAreaWidth >= CLIP_AREA_MIN_WH && self.clipAreaHeight >= CLIP_AREA_MIN_WH) {
                    self.clipAreaWidth -= fabs(offsetX);
                    self.clipAreaHeight -= fabs(offsetY);
                    self.clipAreaLayer.rightEdge -= fabs(offsetX);
                    self.clipAreaLayer.bottomEdge -= fabs(offsetY);
                }else if (offsetX > 0 && offsetY > 0 && self.clipAreaLayer.rightEdge <= SCREEN_WIDTH-CLIP_VIEW_LR_MIN && self.clipAreaLayer.bottomEdge <= SCREEN_HEIGHT-CLIP_VIEW_BOTTOM_MAX){
                    self.clipAreaWidth += fabs(offsetX);
                    self.clipAreaHeight += fabs(offsetY);
                    self.clipAreaLayer.rightEdge += fabs(offsetX);
                    self.clipAreaLayer.bottomEdge += fabs(offsetY);
                    [self scaleImgForBottom];
                }
            }
                break;
            case IMAGE_VIEW:
            {
                [self.imgView setCenter:CGPointMake(self.imgView.center.x + translation.x, self.imgView.center.y+translation.y)];
                [panGes setTranslation:CGPointZero inView:self.imgView.superview];
            }
                break;
            default:
                break;
        }
        if (self.acGeView != IMAGE_VIEW) {
            [self setUpClipLayer:NO];
        }
    }
    
    
    if (panGes.state == GR_ENDED) {
        
        if (self.acGeView == IMAGE_VIEW) {
            //修正imgView位置————必须铺满clipAreaLayer
            [UIView animateWithDuration:0.5 animations:^{
                if (CGRectGetMinY(self.imgView.frame)>self.clipAreaLayer.topEdge) {
                    self.imgView.frame = CGRectMake(CGRectGetMinX(self.imgView.frame), self.clipAreaLayer.topEdge, CGRectGetWidth(self.imgView.frame), CGRectGetHeight(self.imgView.frame));
                }
                
                if (CGRectGetMaxY(self.imgView.frame)<self.clipAreaLayer.bottomEdge) {
                    self.imgView.frame = CGRectMake(CGRectGetMinX(self.imgView.frame), self.clipAreaLayer.bottomEdge-CGRectGetHeight(self.imgView.frame), CGRectGetWidth(self.imgView.frame), CGRectGetHeight(self.imgView.frame));
                }
                
                if (CGRectGetMinX(self.imgView.frame)>self.clipAreaLayer.leftEdge) {
                    self.imgView.frame = CGRectMake(self.clipAreaLayer.leftEdge, CGRectGetMinY(self.imgView.frame), CGRectGetWidth(self.imgView.frame), CGRectGetHeight(self.imgView.frame));
                }
                
                if (CGRectGetMaxX(self.imgView.frame)<self.clipAreaLayer.rightEdge) {
                    self.imgView.frame = CGRectMake(self.clipAreaLayer.rightEdge-CGRectGetWidth(self.imgView.frame), CGRectGetMinY(self.imgView.frame), CGRectGetWidth(self.imgView.frame), CGRectGetHeight(self.imgView.frame));
                }
            }];
        }else{
            
            /*
             思路：滑动结束后位置修正
             1.clipAreaLayer的移动后会回到中心点和宽都固定的位置；
             2.clipAreaLayer的缩放：宽固定——如果高度超过最大值——固定高度为最大值——再确定宽度；
             3.imgView的缩放：根据clipAreaLayer的缩放比例来确定宽高；
             4.imgView的位置：以clipAreaLayer为基准并根据缩放前的上边和左边的相对位置的缩放量，来确定；
             */
            
            [NSThread sleepForTimeInterval:0.3];
            //        [self animationForPosition];//移动动画效果——待解决
            
            [UIView animateWithDuration:ANI_DURA animations:^{
                
                //修正裁剪框之前的参照数据
                CGFloat preDrawClipTop = self.clipAreaLayer.topEdge;
                CGFloat preDrawClipLeft = self.clipAreaLayer.leftEdge;
                
                //修正裁剪框
                CGFloat scale = [self drawClipArea];
                
                //设置imgView————不能单纯靠裁剪框的位置偏移量来定位，要考虑到缩放
                CGFloat imgViewX = 0;
                CGFloat imgViewY = 0;
                CGFloat imgWidth = CGRectGetWidth(self.imgView.frame)*scale;
                CGFloat imgHeight = CGRectGetHeight(self.imgView.frame)*scale;
                
                CGFloat offsetX = fabs(CGRectGetMinX(self.imgView.frame)-preDrawClipLeft);
                CGFloat offsetY = fabs(CGRectGetMinY(self.imgView.frame)-preDrawClipTop);
                imgViewX = self.clipAreaLayer.leftEdge-offsetX*scale;
                imgViewY = self.clipAreaLayer.topEdge-offsetY*scale;
                
                self.imgView.frame = CGRectMake(imgViewX, imgViewY, imgWidth, imgHeight);
            }];
            
            //记录每次修复后的位置
            self.preClipAreaFrame = CGRectMake(self.clipAreaLayer.leftEdge, self.clipAreaLayer.topEdge, self.clipAreaWidth, self.clipAreaHeight);
        }
        
        //滑动后，超出clipAreaLayer的图片设置为透明
        [self configShadowArea];
    }
}

- (void)handlePinGes:(UIPinchGestureRecognizer *)pinGes
{
    CGPoint pinchCenter = [pinGes locationInView:self.imgView.superview];
    
    if (pinGes.state == UIGestureRecognizerStateBegan || pinGes.state == UIGestureRecognizerStateChanged) {
        
        [UIView animateWithDuration:0.5 animations:^{
            self.shaView.isSetShadow = NO;
        }];
        
        //CGAffineTransformScale方法90度旋转有问题
//        self.imgView.transform=CGAffineTransformScale(self.imgView.transform, pinGes.scale, pinGes.scale);
//        pinGes.scale = 1;
        
        CGFloat scale = pinGes.scale;
        CGFloat distanceX = self.imgView.frame.origin.x - pinchCenter.x;
        CGFloat distanceY = self.imgView.frame.origin.y - pinchCenter.y;
        CGFloat scaledDistanceX = distanceX * scale;
        CGFloat scaledDistanceY = distanceY * scale;
        CGRect newFrame = CGRectMake(self.imgView.frame.origin.x + scaledDistanceX - distanceX, self.imgView.frame.origin.y + scaledDistanceY - distanceY, self.imgView.frame.size.width * scale, self.imgView.frame.size.height * scale);
        self.imgView.frame = newFrame;
        pinGes.scale = 1;
    }
    
//    if (pinGes.state == UIGestureRecognizerStateEnded) {
    
        //不能过小
        if (CGRectGetMinY(self.imgView.frame)>self.clipAreaLayer.topEdge || CGRectGetMaxY(self.imgView.frame)<self.clipAreaLayer.bottomEdge || CGRectGetMinX(self.imgView.frame)>self.clipAreaLayer.leftEdge || CGRectGetMaxX(self.imgView.frame)<self.clipAreaLayer.rightEdge) {
            self.imgView.frame = CGRectMake(self.clipAreaLayer.leftEdge, self.clipAreaLayer.topEdge, self.clipAreaWidth, self.clipAreaHeight);
        }
        
        //不能过大
        CGFloat scaleNum = 10;
        CGFloat originalImgViewWidth = CGRectGetWidth(_originalImgViewFrame);
        if (CGRectGetWidth(self.imgView.frame)/originalImgViewWidth>scaleNum) {
            self.imgView.frame = _originalImgViewFrame;
            CGFloat distanceX = self.imgView.frame.origin.x - pinchCenter.x;
            CGFloat distanceY = self.imgView.frame.origin.y - pinchCenter.y;
            CGFloat scaledDistanceX = distanceX * scaleNum;
            CGFloat scaledDistanceY = distanceY * scaleNum;
            CGRect newFrame = CGRectMake(self.imgView.frame.origin.x + scaledDistanceX - distanceX, self.imgView.frame.origin.y + scaledDistanceY - distanceY, self.imgView.frame.size.width * scaleNum, self.imgView.frame.size.height * scaleNum);
            self.imgView.frame = newFrame;
            pinGes.scale = 1;
        }
    
//        NSLog(@"self.imgView.frame-----scale------%@", NSStringFromCGRect(self.imgView.frame));
//    }
    
    //缩放完后，需要点击一下图片才会执行该if语句————如何自动执行，待解决
    if (pinGes.state == UIGestureRecognizerStateEnded) {
        [self configShadowArea];
    }
//    self.resetBtn.hidden = NO;
}

- (void)scaleImgForTop
{
    //如果超出imageView的顶部，则拉伸图片—————等比例放大
    if (self.clipAreaLayer.topEdge < self.imgView.frame.origin.y && self.imgView.frame.origin.y >= CLIP_VIEW_TOP_MIN) {
        CGFloat imgViewScale = fabs(self.clipAreaLayer.topEdge- self.imgView.frame.origin.y);
        CGFloat imgViewHeight = self.imgView.frame.size.height+imgViewScale;
        CGFloat imgViewWidth = self.imgView.frame.size.width*(imgViewHeight/self.imgView.frame.size.height);
        
        //此处用masonry框架达不到效果
        self.imgView.frame = CGRectMake((SCREEN_WIDTH-imgViewWidth)/2.0, self.clipAreaLayer.topEdge, imgViewWidth, imgViewHeight);
    }
}

- (void)scaleImgForBottom
{
    if (self.clipAreaLayer.bottomEdge > CGRectGetMaxY(self.imgView.frame) && CGRectGetMaxY(self.imgView.frame) <=  SCREEN_HEIGHT-CLIP_VIEW_BOTTOM_MAX) {
        CGFloat imgViewScale = fabs(self.clipAreaLayer.bottomEdge- CGRectGetMaxY(self.imgView.frame));
        CGFloat imgViewHeight = self.imgView.frame.size.height+imgViewScale;
        CGFloat imgViewWidth = self.imgView.frame.size.width*(imgViewHeight/self.imgView.frame.size.height);
        
        //此处用masonry框架达不到效果
        self.imgView.frame = CGRectMake((SCREEN_WIDTH-imgViewWidth)/2.0, CGRectGetMinY(self.imgView.frame), imgViewWidth, imgViewHeight);
    }
}

//移动的动画效果
- (void)animationForPosition
{
    //图片整体移动，只能取中心点来处理
    CGFloat dura = 1;
    CGFloat offset = (CGRectGetHeight(self.imgView.frame)-self.clipAreaHeight)/2.0;
    
    [self animationMoveWithLayer:self.imgView.layer FromPoint:CGPointMake(self.clipAreaCenterX, CGRectGetMidY(self.imgView.frame)) ToPoint:CGPointMake(self.clipAreaCenterX, self.clipAreaCenterY-offset) Duration:dura];
    
    CGPoint p1 = self.clipAreaLayer.position;
    CGPoint p2 = CGPointMake(p1.x, p1.y+self.clipAreaCenterY-(self.clipAreaLayer.topEdge+self.clipAreaHeight/2.0));
    
    CABasicAnimation *animForLayer = [CABasicAnimation animation];
    animForLayer.delegate = self;
    animForLayer.keyPath = @"position";
    animForLayer.duration = dura;
    //        anim.fromValue = [NSValue valueWithCGPoint:p1];
    animForLayer.toValue = [NSValue valueWithCGPoint:p2];
    animForLayer.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //        //保存动画最前面效果
    animForLayer.removedOnCompletion = NO;
    animForLayer.fillMode = kCAFillModeBoth;
    [self.clipAreaLayer addAnimation:animForLayer forKey:nil];
}

- (CGSize)adjustImgViewWithImgSize:(CGSize)imgSize
{
    CGFloat width = SCREEN_WIDTH-2*KClipAreaEdge;
    CGFloat height = imgSize.height*(width/imgSize.width);
    CGFloat maxHeight = (self.clipAreaCenterY-CLIP_VIEW_TOP_MIN)*2;
    if (height > maxHeight) {
        height = maxHeight;
        width = imgSize.width*(height/imgSize.height);
    }
    return CGSizeMake(width, height);
}

- (CGFloat)drawClipArea
{
    CGFloat preChangeWidth = self.clipAreaWidth;
    CGFloat preChangeHeight = self.clipAreaHeight;
    self.clipAreaWidth = SCREEN_WIDTH-2*KClipAreaEdge;
    self.clipAreaHeight = preChangeHeight*(self.clipAreaWidth/preChangeWidth);
    CGFloat maxHeight = (self.clipAreaCenterY-CLIP_VIEW_TOP_MIN)*2;;
    if (self.clipAreaHeight > maxHeight) {
        self.clipAreaHeight = maxHeight;
        self.clipAreaWidth = preChangeWidth*(self.clipAreaHeight/preChangeHeight);
    }
    [self setUpClipLayer:YES];
    return self.clipAreaHeight/preChangeHeight;
}

//CAShapeLayer必须配合贝塞尔曲线绘制
- (void)setUpClipLayer:(BOOL)isFirst
{
    if (isFirst) {
        self.clipAreaLayer.topEdge = self.clipAreaCenterY-self.clipAreaHeight/2.0;
        self.clipAreaLayer.bottomEdge = self.clipAreaCenterY+self.clipAreaHeight/2.0;
        self.clipAreaLayer.leftEdge = self.clipAreaCenterX-self.clipAreaWidth/2.0;
        self.clipAreaLayer.rightEdge = self.clipAreaCenterX+self.clipAreaWidth/2.0;
    }
    
    //设置贝塞尔曲线
    UIBezierPath *roundPath = [UIBezierPath bezierPathWithRoundedRect:self.view.frame cornerRadius:0];
    UIBezierPath *cropPath = [UIBezierPath bezierPathWithRect:CGRectMake(self.clipAreaLayer.leftEdge, self.clipAreaLayer.topEdge, self.clipAreaWidth, self.clipAreaHeight)];
    [roundPath appendPath:cropPath];
    
    self.clipAreaLayer.path = CFBridgingRetain(roundPath);
    [self.clipAreaLayer configClipAreaWithTop:self.clipAreaLayer.topEdge Bottom:self.clipAreaLayer.bottomEdge Left:self.clipAreaLayer.leftEdge Right:self.clipAreaLayer.rightEdge];
    
    CFBridgingRelease((__bridge CFTypeRef _Nullable)(roundPath));
}

- (void)updateImgViewFrameWithCenterYOffset:(CGFloat)OffsetY CenterXOffset:(CGFloat)OffsetX Width:(CGFloat)width Height:(CGFloat)height
{
    self.imgView.frame = CGRectMake(0, 0, width, height);
    self.imgView.center = CGPointMake(self.clipAreaCenterX+OffsetX, self.clipAreaCenterY+OffsetY);
}

- (BOOL)judgeGesRecInViewWithMinX:(CGFloat)minX MaxX:(CGFloat)MaxX MinY:(CGFloat)minY MaxY:(CGFloat)maxY
{
    return (self.panGesRec.beginPoint.x >= minX && self.panGesRec.beginPoint.x <= MaxX && self.panGesRec.beginPoint.y >= minY && self.panGesRec.beginPoint.y <= maxY)?YES:NO;
}

#pragma mark -
#pragma mark - CAAnimationDelegate

//- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
//{
//    //开始事务
//    [CATransaction begin];
//    //关闭隐式动画
//    [CATransaction setDisableActions:YES];
//    self.clipAreaLayer.position = [[anim valueForKey:@"positionToEnd"] CGPointValue];
//    //提交事务
//    [CATransaction commit];
//    [self drawClipArea];
//}

@end
