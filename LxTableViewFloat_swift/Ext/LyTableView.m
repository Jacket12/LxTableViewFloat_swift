//
//  LyTableView.m
//  lvxingjiaoyou
//
//  Created by JackYe on 2019/6/10.
//  Copyright © 2019 JackYe. All rights reserved.
//

#import "LyTableView.h"

@implementation LyTableView

/**允许手势向下传递，主要是为了解决ScrollView嵌套手势冲突问题*/
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    /** tableHeaderView区域内禁止同时接收手势 */
    if (self.pointInTableHeader == YES) {
        return NO;
    }
    
    return self.shouldRecognizeSimultaneously;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
    if (self.tableHeaderView && CGRectContainsPoint(self.tableHeaderView.frame, point)) {
        self.pointInTableHeader = YES;
    }else{
        self.pointInTableHeader = NO;
    }
    
    return [super pointInside:point withEvent:event];
}


@end
