
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "XYWeatherData.h"

@interface XYGetWeatherData : NSObject

/**
 *  根据城市名称获取天气数据
 *
 *  @param cityName 查询的城市名称
 *  @param success  请求成功的回调，返回天气数据的字符串数组
 *  @param failure  请求失败的回调
 */
+ (void)getWeatherDataWithCityName:(NSString *)cityName withTag:(NSInteger)tag success:(void(^)(NSArray *dataArray))success failure:(void(^)(NSError *error))failure;
/**
 *  根据城市名称获取天气数据
 *
 *  @param cityName 城市名称
 *  @param tag      城市tag
 *  @param success  返回天气数据的详细信息
 *  @param failure  返回错误信息
 */
+ (void)getDetailedWeatherDataWithCityName:(NSString *)cityName withTag:(NSInteger)tag success:(void (^)(XYWeatherData *weatherData))success failure:(void (^)(NSError *error))failure;
/**
 *  根据定位获取天气数据
 *
 *  @param location 定位信息
 *  @param tag      城市tag
 *  @param success  返回天气数据的详细信息
 *  @param failure  返回错误信息
 */
+ (void)getDetailedWeatherDataWithlocation:(CLLocation *)location withTag:(NSInteger)tag success:(void (^)(XYWeatherData *data))success failure:(void (^)(NSError *error))failure;
/**
 *  根据搜索栏输入信息获取天气数据
 *
 *  @param placemark 地标
 *  @param tag      城市tag
 *  @param success  返回天气数据的详细信息
 *  @param failure  返回错误信息
 */
+ (void)getDetailedWeatherDataWithPlacemark:(CLPlacemark *)placemark withTag:(NSInteger)tag success:(void (^)(XYWeatherData *data))success failure:(void (^)(NSError *error))failure;

@end
