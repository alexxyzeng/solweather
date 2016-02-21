//
//  XYWeatherView.h
//  
//
//  Created by xiayao on 16/2/12.
//
//
#import <UIKit/UIKit.h>
@class SOLWeatherData;
@protocol XYWeatherViewDelegate <NSObject>

- (BOOL)shouldPanWeatherView;

- (void)didBeginPanningWeatherView;

- (void)didFinishPanningWeatherView;

@end


@interface XYWeatherView : UIView <UIGestureRecognizerDelegate>
/**
 *  是否有天气数据
 */
@property (assign, nonatomic) BOOL hasData;
/**
 *  是否有本地天气数据
 */
@property (assign, nonatomic, getter = isLocal) BOOL localWeather;
/**
 *  天气详情的容器视图
 */
@property (strong, nonatomic, readonly) UIView*container;
/**
 *  天气状况图标
 */
@property (strong, nonatomic, readonly) UIImageView *conditionIconView;

/**
 *  天气状况描述
 */
@property (strong, nonatomic, readonly) UILabel *conditionDescLabel;
///**
// *  城市名称标签
// */
//@property (strong, nonatomic) UILabel *locationLabel;
/**
 *  当前温度
 */
@property (strong, nonatomic, readonly) UILabel *currentTempLabel;
//空气质量标签
@property (strong, nonatomic, readonly) UILabel *airQualityLabel;

//湿度标签
@property (strong, nonatomic, readonly) UILabel *humidityLabel;

//风力等级标签
@property (strong, nonatomic, readonly) UILabel *windSpeedLabel;
/**
 *  今天温度范围
 */
@property (strong, nonatomic, readonly) UILabel *todayTempLabel;
/**
 *  明天温度范围
 */
@property (strong, nonatomic, readonly) UILabel *tomorrowTempLabel;
/**
 *  后天温度范围
 */
@property (strong, nonatomic, readonly) UILabel *thirdTempLabel;
/**
 *  今天天气图标
 */
@property (strong, nonatomic, readonly) UIImageView *todayImg;
/**
 *  明天天气图标
 */
@property (strong, nonatomic, readonly) UIImageView *tomorrowImg;
/**
 *  后天天气图标
 */
@property (strong, nonatomic, readonly) UIImageView *thirdImg;
/**
 *  今天标签
 */
@property (strong, nonatomic, readonly) UILabel *todayLabel;
/**
 *  明天标签
 */
@property (strong, nonatomic, readonly) UILabel *tomorrowLabel;
/**
 *  后天标签
 */
@property (strong, nonatomic, readonly) UILabel *thirdLabel;
/**
 *  天气视图代理
 */
@property (nonatomic, weak) id<XYWeatherViewDelegate> delegate;
@end
