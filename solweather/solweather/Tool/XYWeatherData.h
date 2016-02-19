

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@interface XYWeatherData : NSObject <NSCoding>
/**
 *  城市名称
 */
@property (nonatomic, copy) NSString *cityName;
/**
 *  当前天气的placemark
 */
@property (strong, nonatomic) CLPlacemark *placemark;
/**
 *  天气概况
 */
@property (nonatomic, copy) NSString *weatherOverview;
/**
 *  当前天气的描述
 */
@property (nonatomic, copy) NSString *weatherDesc;
/**
 *  天气图标
 */
@property (nonatomic, assign) UIImage *weatherImgStr;
/**
 *  当前温度
 */
@property (nonatomic, copy) NSString *currTemp;
/**
 *  温度范围
 */
@property (nonatomic, copy) NSString *todayTemp;
/**
 *  空气质量
 */
@property (nonatomic, copy) NSString *airQuality;
/**
 *  湿度
 */
@property (nonatomic, copy) NSString *humidity;
/**
 *  风力等级
 */
@property (nonatomic, copy) NSString *windScale;
/**
 *  明天天气图标
 */
@property (nonatomic, assign) UIImage *tomorrowImgStr;
/**
 *  明天气温范围
 */
@property (nonatomic, copy) NSString *tomorrowTemp;
/**
 *  后天天气图标
 */
@property (nonatomic, assign) UIImage *thirdImgStr;
/**
 *  后天气温范围
 */
@property (nonatomic, copy) NSString *thirdTemp;

@end
