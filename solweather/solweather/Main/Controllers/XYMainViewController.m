//
//  ViewController.m
//  solarweather
//
//  Created by xiayao on 16/2/12.
//  Copyright (c) 2016年 xiayao. All rights reserved.
//

#import "XYMainViewController.h"
#import "XYLeftMenuViewController.h"
#import "XYRightViewController.h"
#import "XYWeatherScrollView.h"
#import "XYWeatherView.h"
#import "XYWeatherData.h"
#import "XYWeatherStateManager.h"
#import "XYGetWeatherData.h"
#import "UIImage+ImageEffects.h"
#import "MBProgressHUD+MJ.h"


@interface XYMainViewController ()
/**
 *  左侧菜单按钮
 */
@property (nonatomic, strong) UIButton *leftBtn;
/**
 *  右侧分享按钮
 */
@property (nonatomic, strong) UIButton *rightBtn;
/**
 *  时间标签
 */
@property (nonatomic, strong) UILabel *timeLabel;
/**
 *  天气数据
 */
@property (nonatomic, strong) NSMutableDictionary *weatherData;
/**
 *  城市天气的tags
 */
@property (nonatomic, strong) NSMutableArray *weatherTags;
/**
 *  天气视图
 */
@property (nonatomic, strong) XYWeatherView *weatherView;
/**
 *  天气背景视图
 */
@property (nonatomic, strong) UIView *backgroundView;
/**
 *  滚动指示器
 */
@property (nonatomic, strong) UIPageControl *pgControl;
/**
 *  城市列表视图控制器
 */
@property (nonatomic, strong) XYLeftMenuViewController *leftVc;
/**
 *  添加天气城市视图控制器
 */
@property (nonatomic, strong) XYRightViewController *rightVc;
/**
 *  模糊转场视图
 */
@property (nonatomic, strong) UIImageView *blurredOverlayView;

@property (assign, nonatomic) BOOL isScrolling;

@end

@implementation XYMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.modalPresentationStyle = UIModalPresentationCurrentContext;
        //检查是否有保存的天气数据
        NSDictionary *savedWeatherData = [XYWeatherStateManager weatherData];
        if (savedWeatherData) {
            _weatherData = [NSMutableDictionary dictionaryWithDictionary:savedWeatherData];
        } else {
            _weatherData = [NSMutableDictionary dictionaryWithCapacity:8];
        }
        //保存的天气城市的标签
        NSArray *savedWeatherTags = [XYWeatherStateManager weatherTags];
        if (savedWeatherTags) {
            _weatherTags = [NSMutableArray arrayWithArray:savedWeatherTags];
        } else {
            _weatherTags = [NSMutableArray arrayWithCapacity:7];
        }
        
        [self initViewControllers];
        [self initSubViews];
        [self initWeatherView];
//        [self.view bringSubviewToFront:_blurredOverlayView];
    }
    return self;
}
//初始化视图控制器
- (void)initViewControllers
{
    _leftVc = [[XYLeftMenuViewController alloc] init];
    _leftVc.delegate = self;
    
    _rightVc = [[XYRightViewController alloc] init];
    _rightVc.delegate = self;
}

//初始化子视图
- (void)initSubViews
{
    //背景视图
    _backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    _backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgimage"]];
    [self.view addSubview:_backgroundView];
    //天气滚动视图
    _weatherScrView = [[XYWeatherScrollView alloc] initWithFrame:self.view.bounds];
    _weatherScrView.delegate = self;
    _weatherScrView.bounces = NO;
    [self.view addSubview:_weatherScrView];
    //页面控制器
    _pgControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - 32, CGRectGetWidth(self.view.bounds), 32)];
    _pgControl.hidesForSinglePage = YES;
    [self.view addSubview:_pgControl];
    //左侧按钮
    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftBtn setBackgroundImage:[UIImage imageNamed:@"left_button"] forState:UIControlStateNormal];
    [_leftBtn setBackgroundImage:[UIImage imageNamed:@"left_button_press"] forState:UIControlStateHighlighted];
    [_leftBtn addTarget:self action:@selector(showLeftMenu) forControlEvents:UIControlEventTouchUpInside];
    _leftBtn.frame = CGRectMake(10, 10, 44, 44);
    [self.view addSubview:_leftBtn];
    //右侧按钮
//    [_rightBtn setBackgroundImage:[UIImage imageNamed:@"right_button_share"] forState:UIControlStateNormal];
//    [_rightBtn setBackgroundImage:[UIImage imageNamed:@"right_button_share_press"] forState:UIControlStateHighlighted];
//    [_rightBtn addTarget:self action:@selector(weatherShare) forControlEvents:UIControlEventTouchUpInside];
    UILabel *add = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    add.text = @"+";
    add.font = [UIFont fontWithName:@"HelveticaNeue" size:40];
    add.textColor = [UIColor whiteColor];
    _rightBtn = [[UIButton alloc] init];
    [_rightBtn addSubview:add];
    [_rightBtn addTarget:self action:@selector(weatherShare) forControlEvents:UIControlEventTouchUpInside];
    _rightBtn.frame = CGRectMake(CGRectGetMaxX(self.view.bounds) - 50, 10, 40, 40);

    [self.view addSubview:_rightBtn];
    //日期标签
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.dateFormat = @"YYYY年MM月dd日";
    NSString *date = [formatter stringFromDate:[NSDate date]];
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
    _timeLabel.center = CGPointMake(CGRectGetMidX(self.view.bounds), 30);
    _timeLabel.text = date;
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    [self.view addSubview:_timeLabel];
    //过渡视图
//    _blurredOverlayView = [[UIImageView alloc] initWithImage:[[UIImage alloc] init] ];
//    _blurredOverlayView.alpha = 0.0;
//    _blurredOverlayView.frame = self.view.bounds;
//    [self.view addSubview:_blurredOverlayView];
}
//左侧按钮点击事件
- (void)showLeftMenu
{
    NSMutableArray *locations = [NSMutableArray arrayWithCapacity:8];
    for (XYWeatherView *weatherView in _weatherScrView.subviews) {
            //FIXME: 返回数据为空就会崩溃掉 locationArr	NSArray *	nil
            NSArray *locationArr = @[weatherView.conditionDescLabel.text, weatherView.todayTempLabel.text, [NSNumber numberWithInteger:weatherView.tag]];
            [locations addObject:locationArr];
    }
    //将获得的天气城市数据传给左侧列表视图
    _leftVc.locations = locations;
    [self presentViewController:_leftVc animated:YES completion:nil];
    [self showBlurredOverlayView:YES];
}
//FIXME: 是否添加该功能
- (void)weatherShare
{
    [self showBlurredOverlayView:YES];
    [self presentViewController:_rightVc animated:YES completion:nil];
}
    
- (void)showBlurredOverlayView:(BOOL)show
{
    [UIView animateWithDuration:0.25 animations: ^ {
        self.blurredOverlayView.alpha = (show)? 1.0 : 0.0;;
    }];
}

- (void)setBlurredOverlayImage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^ {
        
        //  Take a screen shot of this controller's view
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0.0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        [self.view.layer renderInContext:context];
        UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        //  Blur the screen shot
        UIImage *blurred = [image applyBlurWithRadius:20
                                            tintColor:[UIColor colorWithWhite:0.15 alpha:0.5]
                                saturationDeltaFactor:1.5
                                            maskImage:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            //  Set the blurred overlay view's image with the blurred screenshot
            self.blurredOverlayView.image = blurred;
        });
    });
}

#pragma mark 天气数据的获取和展示
/**
 *  设置天气视图
 */
- (void)initWeatherView
{
    for (NSNumber *tagNumber in _weatherTags) {
        XYWeatherData *weatherData = [_weatherData objectForKey:tagNumber];
        if (weatherData) {
            XYWeatherView *weatherView = [[XYWeatherView alloc] initWithFrame:self.view.bounds];
            weatherView.delegate = self;
            weatherView.tag = tagNumber.integerValue;
            weatherView.backgroundColor = [UIColor clearColor];
            _pgControl.numberOfPages += 1;
            [_weatherScrView addSubview:weatherView isLaunch:YES];
            
            [self updateWeatherView:weatherView withData:weatherData];
        }
    }
}
//从本地数据获取天气信息
- (void)updateWeatherView:(XYWeatherView *)weatherView withData:(XYWeatherData *)data
{
    //本地没有数据就直接返回
    if (!data) {
        return;
    }
    weatherView.hasData = YES;
    weatherView.conditionIconView.image = [UIImage imageNamed:data.weatherImgStr];
    weatherView.conditionDescLabel.text = [NSString stringWithFormat:@"%@, %@", data.cityName, data.weatherOverview];
    weatherView.currentTempLabel.text = data.currTemp;
    weatherView.airQualityLabel.text = data.airQuality;
    weatherView.windSpeedLabel.text = data.windScale;
    weatherView.humidityLabel.text = data.humidity;
    
    weatherView.todayLabel.text = @"今天";
    weatherView.todayTempLabel.text = data.todayTemp;
    weatherView.todayImg.image = [UIImage imageNamed:data.weatherImgStr];

    
    weatherView.tomorrowLabel.text = @"明天";
    weatherView.tomorrowTempLabel.text = data.tomorrowTemp;
    weatherView.tomorrowImg.image = [UIImage imageNamed:data.tomorrowImgStr];
    
    weatherView.thirdLabel.text = @"后天";
    weatherView.thirdTempLabel.text = data.thirdTemp;
    weatherView.thirdImg.image = [UIImage imageNamed:data.thirdImgStr];

}

//从网络获取天气数据
- (void)updateWeatherData
{
    for (XYWeatherView *weatherView in _weatherScrView.subviews) {
            XYWeatherData *weatherData = [_weatherData objectForKey:[NSNumber numberWithInteger:weatherView.tag]];
            [MBProgressHUD showMessage:@"正在更新天气"];
            [XYGetWeatherData getDetailedWeatherDataWithPlacemark:weatherData.placemark withTag:weatherView.tag success:^(XYWeatherData *data) {
                //有数据就更新视图数据
                [self didFinishDownloadingWeatherData:data withTag:weatherView.tag];
            } failure:^(NSError *error) {
                //没有数据，就显示错误信息
                [self didFailToDownloadDataWithTag:weatherView.tag];
            }];
    }
}
//更新天气成功
- (void)didFinishDownloadingWeatherData:(XYWeatherData *)data withTag:(NSInteger)tag
{
    for (XYWeatherView *weatherView in _weatherScrView.subviews) {
        if (weatherView.tag == tag) {
            [_weatherData setObject:data forKey:[NSNumber numberWithInteger:tag]];
        }
        [self updateWeatherView:weatherView withData:data];
        [MBProgressHUD hideHUD];
    }
}

//更新天气失败
- (void)didFailToDownloadDataWithTag:(NSInteger)tag
{
    for (XYWeatherView *weatherView in _weatherScrView.subviews) {
        if (weatherView.tag == tag) {
            if (!weatherView.hasData) {
                [UIView animateWithDuration:1 animations:^{
                    [MBProgressHUD showMessage:@"更新天气失败"];
                }];
                [MBProgressHUD hideHUD];
                weatherView.conditionIconView.image = [UIImage imageNamed:@"nothing.gif"];
                weatherView.conditionDescLabel.text = @"无天气数据";
                
                weatherView.todayLabel.text = @"今天";
                weatherView.todayImg.image = [UIImage imageNamed:@"nothing.gif"];
                
                weatherView.tomorrowLabel.text = @"明天";
                weatherView.tomorrowImg.image = [UIImage imageNamed:@"nothing.gif"];
                
                weatherView.thirdLabel.text = @"后天";
                weatherView.thirdImg.image = [UIImage imageNamed:@"nothing.gif"];
                
            }
            
        }
    }
}


#pragma mark leftMenuVC代理方法

- (void)didMoveWeatherViewAtIndex:(NSInteger)sourceIndex toIndex:(NSInteger)destinationIndex
{
    NSNumber *weatherTag = [_weatherTags objectAtIndex:sourceIndex];
    [_weatherTags removeObjectAtIndex:sourceIndex];
    [_weatherTags insertObject:weatherTag atIndex:destinationIndex];
    
    //保存tags
    [XYWeatherStateManager setWeatherTags:_weatherTags];
    //  移动天气视图
    for(XYWeatherView *weatherView in _weatherScrView.subviews) {
        if(weatherView.tag == weatherTag.integerValue) {
            [_weatherScrView removeSubview:weatherView];
            [_weatherScrView insertSubview:weatherView atIndex:destinationIndex];
            break;
        }
    }
}

- (void)didRemoveWeatherViewWithTag:(NSInteger)tag
{
    //  根据tag找到要移除的天气视图
    for(XYWeatherView *weatherView in _weatherScrView.subviews) {
        if(weatherView.tag == tag) {
            [_weatherScrView removeSubview:weatherView];
            _pgControl.numberOfPages -= 1;
        }
    }
    //  移除该视图已保存的数据
    [_weatherData removeObjectForKey:[NSNumber numberWithInteger:tag]];
    //  移除视图数据关联的tag
    [_weatherTags removeObject:[NSNumber numberWithInteger:tag]];
    
    //  重新保存天气数据和视图tag
    [XYWeatherStateManager setWeatherData:self.weatherData];
    [XYWeatherStateManager setWeatherTags:self.weatherTags];
}

- (void)dismissXYLeftMenuViewController
{
    [_leftVc dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 天气滚动视图代理方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    _isScrolling = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _isScrolling = NO;
    [self setBlurredOverlayImage];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _isScrolling = YES;
    
    //  更新当前页面
    float fractionalPage = _weatherScrView.contentOffset.x / _weatherScrView.frame.size.width;
    _pgControl.currentPage = lround(fractionalPage);
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 添加城市天气视图控制器代理方法
- (void)didAddLocationWithPlacemark:(CLPlacemark *)placemark
{
    XYWeatherData *weatherData = [self.weatherData objectForKey:[NSNumber numberWithInteger:placemark.locality.hash]];
    if (!weatherData) {//如果没有天气数据
        XYWeatherView *weatherView = [[XYWeatherView alloc] initWithFrame:self.view.bounds];
        weatherView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgimage"]];

        weatherView.tag = placemark.locality.hash;
        
        _pgControl.numberOfPages += 1;
        [_weatherScrView addSubview:weatherView isLaunch:YES];
        [_weatherTags addObject:[NSNumber numberWithInteger:weatherView.tag]];

        [XYWeatherStateManager setWeatherTags:_weatherTags];
        
        [XYGetWeatherData getDetailedWeatherDataWithPlacemark:placemark withTag:weatherView.tag success:^(XYWeatherData *data) {
            [self didFinishDownloadingWeatherData:data withTag:weatherView.tag];
        } failure:^(NSError *error) {
            [self didFailToDownloadDataWithTag:weatherView.tag];
        }];
    }
}


- (void)dismissXYRightViewController
{
    [_rightVc dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 天气视图代理方法
- (BOOL)shouldPanWeatherView
{
    //将要开始下拉时不允许页面滚动
    return _isScrolling;
}
//开始下拉就不允许滚动
- (void)didBeginPanningWeatherView
{
    _weatherScrView.scrollEnabled = NO;
}
//下拉结束，允许滚动
- (void)didFinishPanningWeatherView
{
    _weatherScrView.scrollEnabled = YES;
}

@end
