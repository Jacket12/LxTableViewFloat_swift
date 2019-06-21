//
//  WJSliderView.m
//  WJSliderView
//
//  Created by 谭启宏 on 15/12/18.
//  Copyright © 2015年 谭启宏. All rights reserved.
//

#import "WJSliderView.h"

@interface WJSliderView ()

#define kDeviceWidth            [UIScreen mainScreen].bounds.size.width
#define HEXCOLOR(hex)        [UIColor colorWithRed : ((CGFloat)((hex & 0xFF0000) >> 16)) / 255.0 green : ((CGFloat)((hex & 0xFF00) >> 8)) / 255.0 blue : ((CGFloat)(hex & 0xFF)) / 255.0 alpha : 1.0]
#define kColorGrobalBgGray              HEXCOLOR(0xeeeeee)                  //#eeeeee 背景
#define ColorRGB(r, g, b)    [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0]

#define kColorThemeStyle                HEXCOLOR(0x38cecd)

#define wSelf(self) __weak typeof(self) wSelf = self;
#define kFontNormal_16 [UIFont systemFontOfSize:16]
#define kColorBtnBgBlue_10       ColorRGB(25, 174, 218)  //谈蓝色

@property (nonatomic,strong)UIView *sliderView;
@property (nonatomic,strong)UIView *grayView;
//下标
@property (nonatomic,assign)NSInteger index;
//如果使用了indexPressgress则,index失效，避免冲突
//@property (nonatomic,assign)BOOL isUseIndexProgress;

@property (nonatomic,assign)CGFloat width;
@property (nonatomic,assign)CGFloat height;

@property (nonatomic,assign)CGFloat slider_c_x;
@property (nonatomic,assign)CGFloat slider_c_y;

@property (nonatomic,strong)UILabel *selectedLabel;

@end

@implementation WJSliderView

- (UIView *)sliderView {
    if (!_sliderView) {
        _sliderView = [[UIView alloc]initWithFrame:CGRectMake(0,self.height-2, self.width, 2)];
        _sliderView.backgroundColor = kColorThemeStyle;
        _slider_c_x = _sliderView.center.x;
        _slider_c_y = _sliderView.center.y;
    }
    return _sliderView;
}

-(UIView *)grayView
{
    if (!_grayView) {
        
        _grayView  = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 0.5,kDeviceWidth, 0.5)];
        _grayView.backgroundColor = UIColor.whiteColor;
    }
    return _grayView;
}

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)array {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self commonInitWithArray:array];
    }
    return self;
}

//核心类
- (void)commonInitWithArray:(NSArray *)array {
    self.width = self.frame.size.width/array.count;
    self.height = self.frame.size.height;
    
    
    [self addSubview:self.grayView];
    [self addSubview:self.sliderView];
    
    wSelf(self);
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *title     =(NSString *)obj;
        UILabel *label      = [UILabel new];
        label.tag           = idx;
        label.text          = title;
        label.textColor     =[UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.frame         = CGRectMake(idx * wSelf.width, 0, wSelf.width, wSelf.height - 3);
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap =
        [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPressed:)];
        [label addGestureRecognizer:tap];
        [self addSubview:label];
        
        if (idx == 0) wSelf.selectedLabel = label;
    }];
    
    //默认选中第一项
    [self changeSelectionColor:self.index];
}

#pragma mark - 事件监听
- (void)tapPressed:(UITapGestureRecognizer *)sender {
    self.index = sender.view.tag;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(wj_sliderViewDidIndex:)]) {
        [self.delegate wj_sliderViewDidIndex:self.index];
    }
    
    [self changeSelectionColor:self.index];
}

- (void)setIndexProgress:(CGFloat)indexProgress {
    //_indexProgress = indexProgress;
    //self.isUseIndexProgress = YES;
    self.sliderView.center = CGPointMake(_slider_c_x + indexProgress * self.width,_slider_c_y);
    
}

-(void)changeSelectionColor:(NSInteger)index
{
    _index = index;
    wSelf(self);
    [self.subviews enumerateObjectsUsingBlock:^(UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop)
    {
        if ([view isKindOfClass:[UILabel class]]) {
            
            UILabel *label = (UILabel *)view;
            label.font = wSelf.font == nil ? kFontNormal_16 : wSelf.font;
            if (view.tag != wSelf.index) {
                label.textColor = wSelf.defaultTextColor == nil ? [UIColor blackColor] : wSelf.defaultTextColor;
            } else if(view.tag == wSelf.index){
                label.textColor = wSelf.selectionTextColor == nil ? kColorBtnBgBlue_10 : wSelf.selectionTextColor;
                [wSelf scaleAnimation: label];
            }
        }
    }];
}

-(void)scaleAnimation:(UILabel *)label
{
    if (label == _selectedLabel) {
        return;
    }
    
    //缩放动画
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation1.fromValue = [NSNumber numberWithFloat:1.2f];
    animation1.toValue  = [NSNumber numberWithFloat:1.0f];
    animation1.duration = 0.3;
    animation1.repeatCount = 1;
    animation1.fillMode = kCAFillModeForwards;
    animation1.removedOnCompletion = NO;
    animation1.autoreverses = NO;
    [self.selectedLabel.layer addAnimation:animation1 forKey:@"animation1"];
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation2.fromValue = [NSNumber numberWithFloat:1.0f];
    animation2.toValue  = [NSNumber numberWithFloat:1.2f];
    animation2.duration = 0.3;
    animation2.repeatCount = 1;
    animation2.fillMode = kCAFillModeForwards;
    animation2.removedOnCompletion = NO;
    animation2.autoreverses = NO;
    [label.layer addAnimation:animation2 forKey:@"animation2"];
    
    self.selectedLabel = label;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    wSelf(self);
    [self.subviews enumerateObjectsUsingBlock:^(UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([view isKindOfClass:[UILabel class]]) {
            
            UILabel *label = (UILabel *)view;
            label.font=wSelf.font == nil ? kFontNormal_16 : wSelf.font;
            if (view.tag !=wSelf.index) {
                label.textColor=wSelf.defaultTextColor == nil ? [UIColor whiteColor] : wSelf.defaultTextColor;
            } else if(view.tag == wSelf.index){
                label.textColor=wSelf.selectionTextColor ==nil ? kColorBtnBgBlue_10 : wSelf.selectionTextColor;
                wSelf.selectedLabel = label;
                [wSelf scaleAnimation: label];
            }
        }
    }];
}

@end
