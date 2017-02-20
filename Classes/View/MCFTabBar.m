//
//  MCFTabBar.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/2/17.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "MCFTabBar.h"
#import <objc/runtime.h>
@interface MCFTabBar ()

@property (nonatomic, weak) UIView *middleButton;//定制的中间按键
@end

@implementation MCFTabBar

- (void)layoutSubviews {
    [super layoutSubviews];
    
    Class class = NSClassFromString(@"UITabBarButton");
    for (UIView *btn in self.subviews) {
        if ([btn isKindOfClass:class]) {
            if (btn.center.x == self.center.x) {
                self.middleButton = btn;
                [self bringSubviewToFront:btn];
            }
        }
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.hidden == NO) {
        
        //CGPoint newP = [self convertPoint:point toView:self.middleButton];
        
        //判断如果这个新的点是在发布按钮身上，那么处理点击事件最合适的view就是发布按钮
        if ( CGRectContainsPoint(self.middleButton.frame, point)) {
           
            return self.middleButton;
        }else{//如果点不在发布按钮身上，直接让系统处理就可以了
            
            return [super hitTest:point withEvent:event];
        }

    } else {
        return [super hitTest:point withEvent:event];
    }
}

@end