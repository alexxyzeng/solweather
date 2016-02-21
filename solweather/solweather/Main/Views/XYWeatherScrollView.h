//
//  XYWeatherScrollView.h
//  Sol°C
//
//  Created by xiayao on 16/1/31.
//  Copyright © 2016年 xiayao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYWeatherScrollView : UIScrollView
/**
 *  添加城市天气
 */
- (void)addSubview:(UIView *)weatherView isLaunch:(BOOL)launch;
/**
 *  移除城市天气
 */
- (void)removeSubview:(UIView *)weatherView;
/**
 *  插入城市天气
 */
- (void)insertSubview:(UIView *)weatherView atIndex:(NSInteger)index;
@end
