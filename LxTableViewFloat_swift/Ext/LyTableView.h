//
//  LyTableView.h
//  lvxingjiaoyou
//
//  Created by JackYe on 2019/6/10.
//  Copyright © 2019 JackYe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LyTableView : UITableView

/**
 ScrollView嵌套，是否同时接收手势
 */
@property (nonatomic, assign) BOOL shouldRecognizeSimultaneously;

@property (nonatomic, assign) BOOL pointInTableHeader;

@end

NS_ASSUME_NONNULL_END
