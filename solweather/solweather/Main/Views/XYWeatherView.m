//
//  XYWeatherView.m
//  Sol°C
//
//  Created by xiayao on 16/1/31.
//  Copyright © 2016年 xiayao. All rights reserved.
//

#import "XYWeatherView.h"
#define HEIGHT self.bounds.size.height
#define WIDTH  self.bounds.size.width

@interface XYWeatherView ()
/**
 *  天气详情的容器视图
 */
@property (strong, nonatomic) UIView *container;
/**
 *  垂直下拉手势
 */
@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
/**
 *  天气状况图标
 */
@property (strong, nonatomic) UIImageView *conditionIconView;
@property (nonatomic, strong) UILabel *updateLabel;
/**
 *  天气状况描述
 */
@property (strong, nonatomic) UILabel *conditionDescLabel;

/**
 *  当前温度
 */
@property (strong, nonatomic) UILabel *currentTempLabel;
//空气质量标签
@property (strong, nonatomic) UILabel *airQualityLabel;

//湿度标签
@property (strong, nonatomic) UILabel *humidityLabel;

//风力等级标签
@property (strong, nonatomic) UILabel *windSpeedLabel;
/**
 *  今天温度范围
 */
@property (strong, nonatomic) UILabel *todayTempLabel;
/**
 *  明天温度范围
 */
@property (strong, nonatomic) UILabel *tomorrowTempLabel;
/**
 *  后天温度范围
 */
@property (strong, nonatomic) UILabel *thirdTempLabel;
/**
 *  今天天气图标
 */
@property (strong, nonatomic) UIImageView *todayImg;
/**
 *  明天天气图标
 */
@property (strong, nonatomic) UIImageView *tomorrowImg;
/**
 *  后天天气图标
 */
@property (strong, nonatomic) UIImageView *thirdImg;
/**
 *  今天标签
 */
@property (strong, nonatomic) UILabel *todayLabel;
/**
 *  明天标签
 */
@property (strong, nonatomic) UILabel *tomorrowLabel;
/**
 *  后天标签
 */
@property (strong, nonatomic) UILabel *thirdLabel;

@end

@implementation XYWeatherView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _container = [[UIView alloc] initWithFrame:self.bounds];
        _container.backgroundColor = [UIColor clearColor];
        [self addSubview:_container];
        
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
        _panGestureRecognizer.minimumNumberOfTouches = 1;
        _panGestureRecognizer.delegate = self;
        [_container addGestureRecognizer:_panGestureRecognizer];
        
        [self initDetailLabel];
        [self initUpdateLabel];
        [self initConditionIconLabel];
        [self initConditionDescLabel];
        [self initCurrentTempLabel];
        [self initForecastLabel];
    }

    
    return self;
}

#pragma mark Pan Gesture Recognizer Methods
//天气视图的平移，根据收拾的开始和结束，通知代理执行方法，并将视图进行平移
- (void)didPan:(UIPanGestureRecognizer *)gestureRecognizer
{
    static CGFloat initialCenterY = 0.0;
    CGPoint translatedPoint = [gestureRecognizer translationInView:self.container];//视图的平移
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        initialCenterY = self.container.center.y;
        
        //通知代理开始下拉
        [self.delegate didBeginPanningWeatherView];
        
    } else if(gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
        // 通知代理结束下拉
        [self.delegate didFinishPanningWeatherView];
        
        //回到初始的y值
        [UIView animateWithDuration:0.3 animations: ^ {
            self.container.center = CGPointMake(self.container.center.x, initialCenterY);
        }];
        
    } else if(translatedPoint.y <= 50 && translatedPoint.y > 0) {
        //平移container
        self.container.center = CGPointMake(self.container.center.x, self.center.y + translatedPoint.y);
    }
}
//!!!:
#pragma mark UIGestureRecognizerDelegate Methods
//是否需要开始识别手势
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        //  We only want to register vertial pans
        // 只识别垂直方向的手势
        UIPanGestureRecognizer *panGestureRecognizer = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint velocity = [panGestureRecognizer velocityInView:self.container];
        return fabs(velocity.y) > fabs(velocity.x);
    }
    return YES;
}

//是否同时识别多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark 各种标签初始化方法
//下拉刷新标签
- (void)initUpdateLabel
{
    static const int fontSize = 16;
    _updateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, - 1.5 * fontSize, WIDTH, 1.5 * fontSize)];
    _updateLabel.numberOfLines = 0;
    _updateLabel.adjustsFontSizeToFitWidth = YES;
    _updateLabel.font = [UIFont systemFontOfSize:fontSize];
    _updateLabel.textColor = [UIColor whiteColor];
    _updateLabel.textAlignment = NSTextAlignmentCenter;
    [_container addSubview:_updateLabel];
}
//天气状况图标
- (void)initConditionIconLabel
{
    //FIXME: 已修复
    _conditionIconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0.12 * HEIGHT, WIDTH, 0.4 * HEIGHT)];
    _conditionIconView.contentMode = UIViewContentModeScaleAspectFill;
    _conditionIconView.backgroundColor = [UIColor clearColor];
    [_container addSubview:_conditionIconView];
}
//天气描述标签
- (void)initConditionDescLabel
{

    _conditionDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0.5 * WIDTH, 30)];
    _conditionDescLabel.center = CGPointMake(self.container.center.x, 0.13 * HEIGHT);
    _conditionDescLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:24];
    _conditionDescLabel.textColor = [UIColor whiteColor];
    _conditionDescLabel.textAlignment = NSTextAlignmentCenter;
    _conditionDescLabel.numberOfLines = 1;
    _conditionDescLabel.adjustsFontSizeToFitWidth = YES;
    [_container addSubview:_conditionDescLabel];
}

/**
 *  当前温度标签
 */
- (void)initCurrentTempLabel
{
    _currentTempLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.center.x - 130, self.center.y, 120 , 65)];
    _currentTempLabel.textAlignment = NSTextAlignmentRight;
    _currentTempLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:80];
    _currentTempLabel.textColor = [UIColor whiteColor];
    _currentTempLabel.adjustsFontSizeToFitWidth = YES;
    [_container addSubview:_currentTempLabel];
}

//设置空气质量、湿度和风速标签
- (void)initDetailLabel
{

    _airQualityLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.center.x + 15, self.center.y + 1, 120, 20)];
    _airQualityLabel.textAlignment = NSTextAlignmentLeft;
    _airQualityLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    _airQualityLabel.textColor = [UIColor whiteColor];
    _currentTempLabel.adjustsFontSizeToFitWidth = YES;
    
    _windSpeedLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.center.x + 15, self.center.y + 23, 120, 20)];
    _windSpeedLabel.textAlignment = NSTextAlignmentLeft;
    _windSpeedLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    _windSpeedLabel.textColor = [UIColor whiteColor];
    _windSpeedLabel.adjustsFontSizeToFitWidth = YES;
    
    _humidityLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.center.x + 15, self.center.y + 45, 120, 20)];
    _humidityLabel.textAlignment = NSTextAlignmentLeft;
    _humidityLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    _humidityLabel.textColor = [UIColor whiteColor];
    _humidityLabel.adjustsFontSizeToFitWidth = YES;
    
    [_container addSubview:_airQualityLabel];
    [_container addSubview:_windSpeedLabel];
    [_container addSubview:_humidityLabel];
}

//设置今天、明天和后天天气预报标签
- (void)initForecastLabel
{
    int imgW = 75;
    int imgH = 75;
    int margin = (self.bounds.size.width - 3 *imgW) / 4;
    //今天天气概况
    _todayLabel = [[UILabel alloc]initWithFrame:CGRectMake(margin, 1.35 * self.center.y, imgW, 40)];

    _todayLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    _todayLabel.textColor = [UIColor whiteColor];
    _todayLabel.textAlignment = NSTextAlignmentCenter;
    _todayLabel.adjustsFontSizeToFitWidth = YES;
    
    _todayImg = [[UIImageView alloc] initWithFrame:CGRectMake(margin, 1.35 * self.center.y + 25, imgW, imgH)];
    _todayImg.contentMode = UIViewContentModeScaleAspectFill;
    
    _todayTempLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, 1.35 * self.center.y + 70, imgW, imgH)];
    _todayTempLabel.textColor = [UIColor whiteColor];
    _todayTempLabel.textAlignment = NSTextAlignmentCenter;
    _todayTempLabel.adjustsFontSizeToFitWidth = YES;
    
    [_container addSubview:_todayLabel];
    [_container addSubview:_todayImg];
    [_container addSubview:_todayTempLabel];
    
    //明天天气概况
    _tomorrowLabel = [[UILabel alloc]initWithFrame:CGRectMake(margin * 2 + 75,
                                              1.35 * self.center.y, imgW, 40)];

    _tomorrowLabel.textColor = [UIColor whiteColor];
    _tomorrowLabel.textAlignment = NSTextAlignmentCenter;
    _tomorrowLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    _tomorrowLabel.adjustsFontSizeToFitWidth = YES;
    
    _tomorrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(margin * 2 + 75,
                                             1.35 * self.center.y + 25, imgW, imgH)];
    _tomorrowImg.contentMode = UIViewContentModeScaleAspectFill;
    
    _tomorrowTempLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin * 2 + 75,
                                           1.35 * self.center.y + 70, imgW, imgH)];
    _tomorrowTempLabel.textColor = [UIColor whiteColor];
    _tomorrowTempLabel.textAlignment = NSTextAlignmentCenter;
    _tomorrowTempLabel.adjustsFontSizeToFitWidth = YES;
    
    [_container addSubview:_tomorrowLabel];
    [_container addSubview:_tomorrowImg];
    [_container addSubview:_tomorrowTempLabel];
    
    //后天天气概况
    _thirdLabel = [[UILabel alloc]initWithFrame:CGRectMake(margin * 3 + 150,
                                              1.35 * self.center.y, imgW, 40)];

    _thirdLabel.textColor = [UIColor whiteColor];
    _thirdLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    _thirdLabel.textAlignment = NSTextAlignmentCenter;
    _thirdLabel.adjustsFontSizeToFitWidth = YES;
    
    _thirdImg = [[UIImageView alloc] initWithFrame:CGRectMake(margin * 3 + 150,
                                             1.35 * self.center.y + 25, imgW, imgH)];
    _thirdImg.contentMode = UIViewContentModeScaleAspectFill;
    
    _thirdTempLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin * 3 + 150,
                                           1.35 * self.center.y + 70, imgW, imgH)];
    _thirdTempLabel.textColor = [UIColor whiteColor];
    _thirdTempLabel.textAlignment = NSTextAlignmentCenter;
    _thirdTempLabel.adjustsFontSizeToFitWidth = YES;
    
    [_container addSubview:_thirdLabel];
    [_container addSubview:_thirdImg];
    [_container addSubview:_thirdTempLabel];
}
@end
