//
//  XYWeatherScrollView.m
//  Sol°C
//
//  Created by xiayao on 16/1/31.
//  Copyright © 2016年 xiayao. All rights reserved.
//

#import "XYWeatherScrollView.h"

@implementation XYWeatherScrollView
#pragma mark 初始化UIScrollView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.pagingEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.alwaysBounceHorizontal = YES;
    }
    return self;
}
//是否需要开始识别手势
#pragma mark 添加、删除和移动方法
- (void)addSubview:(UIView *)weatherView isLaunch:(BOOL)launch {
    [super addSubview:weatherView];
    
    NSUInteger subViewsCounts = self.subviews.count;
    //设置分页天气的frame
    weatherView.frame = CGRectMake(
                                   CGRectGetWidth(self.bounds) * (subViewsCounts - 1), 0,
                                   CGRectGetWidth(weatherView.bounds), CGRectGetHeight(weatherView.bounds));
    //设置滚动视图的contentSize
    self.contentSize = CGSizeMake(CGRectGetWidth(weatherView.bounds) * subViewsCounts,
                                  CGRectGetHeight(weatherView.bounds));
    if (!launch) {
        [self setContentOffset:CGPointMake(CGRectGetWidth(weatherView.bounds) *(subViewsCounts - 1), 0)
                      animated:YES];
    }
}

- (void)removeSubview:(UIView *)weatherView {
    NSUInteger index = [self.subviews indexOfObject:weatherView];
    if (index != NSNotFound) {
        NSUInteger subViewsCounts = self.subviews.count;
        for (NSUInteger i = index + 1; i < subViewsCounts; i ++) {
            UIView *view = [self.subviews objectAtIndex:i];
            view.frame = CGRectOffset(view.frame, -1.0 * CGRectGetWidth(weatherView.bounds), 0);
        }
        [weatherView removeFromSuperview];
        self.contentSize = CGSizeMake(CGRectGetWidth(weatherView.bounds) * (subViewsCounts - 1),
                                      self.contentSize.height);
    }
}

- (void)insertSubview:(UIView *)weatherView atIndex:(NSInteger)index
{
    [super insertSubview:weatherView atIndex:index];
    
    weatherView.frame = CGRectMake(CGRectGetWidth(self.bounds) * index, 0,
                                   CGRectGetWidth(weatherView.bounds), CGRectGetHeight(weatherView.bounds));
    NSUInteger subViewsCounts = [self.subviews count];
    for(NSUInteger i = index + 1; i < subViewsCounts; ++i) {
        UIView *subview = [self.subviews objectAtIndex:i];
        subview.frame = CGRectMake(CGRectGetWidth(self.bounds) * i, 0,
                                   CGRectGetWidth(weatherView.bounds), CGRectGetHeight(weatherView.bounds));
    }
    [self setContentSize:CGSizeMake(CGRectGetWidth(self.bounds) * subViewsCounts,
                                    self.contentSize.height)];
    NSLog(@"%s", __func__);
    
}

@end
