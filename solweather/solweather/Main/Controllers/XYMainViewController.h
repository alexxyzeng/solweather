//
//  ViewController.h
//  solarweather
//
//  Created by xiayao on 16/2/12.
//  Copyright (c) 2016年 xiayao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYGetWeatherData.h"
#import "XYWeatherView.h"
#import "XYLeftMenuViewController.h"
#import "XYRightViewController.h"
#import "XYWeatherScrollView.h"

@interface XYMainViewController : UIViewController <UIScrollViewDelegate, XYWeatherViewDelegate, XYLeftMenuViewControllerDelegate, XYRightViewControllerDelegate>
/**
 *  天气滚动视图
 */
@property (nonatomic, strong) XYWeatherScrollView *weatherScrView;
/**
 *  更新天气数据
 */
- (void)updateWeatherData;

@end

