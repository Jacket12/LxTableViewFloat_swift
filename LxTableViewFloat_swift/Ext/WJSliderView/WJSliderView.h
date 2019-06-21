//
//  WJSliderView.h
//  WJSliderView
//
//  Created by 谭启宏 on 15/12/18.
//  Copyright © 2015年 谭启宏. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WJSliderViewDelegate <NSObject>

- (void)wj_sliderViewDidIndex:(NSInteger)index;
@end

@interface WJSliderView : UIView

@property (nonatomic, assign) CGFloat indexProgress;
@property (nonatomic, strong) UIColor *defaultTextColor;
@property (nonatomic, strong) UIColor *selectionTextColor;
@property (nonatomic, strong) UIFont  *font;

@property (nonatomic,weak)id<WJSliderViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)array;

///改变选中文字背景色
-(void)changeSelectionColor:(NSInteger)index;

@end
