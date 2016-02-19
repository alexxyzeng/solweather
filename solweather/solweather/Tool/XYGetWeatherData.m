//
//  XYWeatherData.m
//  Sol°C
//
//  Created by xiayao on 16/2/2.
//  Copyright © 2016年 xiayao. All rights reserved.
//

#import "XYGetWeatherData.h"
#import "XYWeatherData.h"
#import "XYHttpTool.h"
#import "GDataXMLNode.h"
#import "NSString+Substring.h"
#import "XYWeatherStateManager.h"
#import <AddressBook/AddressBook.h>

//#define getWeatherbyCityName @"http://www.webxml.com.cn/WebServices/WeatherWebService.asmx/getWeatherbyCityName"
//#define theCityName @"theCityName"

@implementation XYGetWeatherData

+ (void)getWeatherDataWithCityName:(NSString *)cityName withTag:(NSInteger)tag success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure
{
    NSDictionary *param = [NSDictionary dictionaryWithObject:cityName
                                                      forKey:@"theCityName"];
    [XYHttpTool GET:@"http://www.webxml.com.cn/WebServices/WeatherWebService.asmx/getWeatherbyCityName" parameters:param success:^(id responseObject) {
        //使用GDataXML解析数据
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithXMLString:responseObject options:1 error:nil];
        //获取根节点对象
        GDataXMLElement *rootElement = doc.rootElement;
        //将xml字符串转化为字符串数组
        NSArray *dataArray = [rootElement elementsForName:@"string"];
        if (success) {
            success(dataArray);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

}
//<string>湖北</string>
//<string>襄樊</string>
//<string>57278</string>
//<string>57278.jpg</string>
//<string>2016-2-2 16:14:57</string>
//<string>0℃/7℃</string>
//<string>2月2日 多云转晴</string>
//<string>无持续风向微风</string>
//<string>1.gif</string>
//<string>0.gif</string>
//<string>今日天气实况：气温：7℃；风向/风力：南风 3级；湿度：27%；紫外线强度：最弱。空气质量：中。</string>
//<string>

+ (void)getDetailedWeatherDataWithCityName:(NSString *)cityName withTag:(NSInteger)tag success:(void (^)(XYWeatherData *))success failure:(void (^)(NSError *))failure
{
    if ([cityName isEqualToString:@"襄阳"]) {
        cityName = @"襄樊";
    }
    [XYGetWeatherData getWeatherDataWithCityName:cityName withTag:tag success:^(NSArray *dataArray) {
        XYWeatherData *weatherData = [[XYWeatherData alloc] init];
        weatherData.cityName = cityName;
        //获取最低最高温度
        weatherData.todayTemp = [[dataArray objectAtIndex:5] stringValue];
        
//        weatherData.minTemp = [tempScale substringWithRange:NSMakeRange(0, 2)];
//        weatherData.maxTemp = [tempScale substringFromIndex:3];
        //当前天气概况
        NSString *overviewStr = [[dataArray objectAtIndex:6] stringValue];
        NSArray *overview = [overviewStr componentsSeparatedByString:@" "];
        weatherData.weatherOverview = overview[1] ;
        //获取天气图标
        NSString *weatherStr = [[dataArray objectAtIndex:8] stringValue];
        weatherData.weatherImg = [weatherData weatherImageWithString:weatherStr];
        if ([weatherStr contains:@"雾"] && ![weatherStr contains:@"霾"]) {
            weatherData.weatherImg = [UIImage imageNamed:@"fog"];
        }
        //获取更多的天气信息
        NSString *desc = [[dataArray objectAtIndex:10] stringValue];
        //当前天气描述
        weatherData.weatherDesc = [cityName stringByAppendingString:desc];
        
        NSString *content = [desc substringFromIndex:7];
        NSArray *comp = [content componentsSeparatedByString:@"; "];
        //温度范围
        weatherData.todayTemp = [[dataArray objectAtIndex:5] stringValue];
        //当前温度
        weatherData.currTemp = [comp[0] substringFromIndex:3];
        //风向 风力
        weatherData.windScale = [[comp[1] substringFromIndex:6] stringByReplacingOccurrencesOfString:@" " withString:@""];
        //湿度
        weatherData.humidity = [comp[2] substringFromIndex:3];
        //空气质量
        weatherData.airQuality = [comp[4] substringToIndex:5];
        //获取明天天气
        NSString *tomorrowStr = [[dataArray objectAtIndex:17] stringValue];
        weatherData.tomorrowImg = [weatherData weatherImageWithString:tomorrowStr];
        if ([tomorrowStr contains:@"雾"] && ![tomorrowStr contains:@"霾"]) {
            weatherData.tomorrowImg = [UIImage imageNamed:@"fog"];
        }
        weatherData.tomorrowTemp = [dataArray objectAtIndex:14];
        //        weatherData.tomorrowWeather = [dataArray objectAtIndex:15];
        
        //后天的天气
        NSString *thirdStr = [[dataArray objectAtIndex:22] stringValue];
        weatherData.thirdImg = [weatherData weatherImageWithString:thirdStr];
        if ([thirdStr contains:@"雾"] && ![thirdStr contains:@"霾"]) {
            weatherData.thirdImg = [UIImage imageNamed:@"fog"];
        }
        weatherData.thirdTemp = [dataArray objectAtIndex:19];
        //        weatherData.thirdWeather = [dataArray objectAtIndex:20];
        //TODO: 完善数据获取
        if (success) {
            success(weatherData);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

}

+ (void)getDetailedWeatherDataWithlocation:(CLLocation *)location withTag:(NSInteger)tag success:(void (^)(XYWeatherData *))success failure:(void (^)(NSError *))failure
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks > 0) {
            //地理信息反编译，获取当前城市信息
            CLPlacemark *placemark = placemarks[0];
            NSDictionary *addressDict = placemark.addressDictionary;
            NSString *city = [addressDict objectForKey:(NSString *)kABPersonAddressCityKey];
            //根据当前城市信息，获取天气数据
            if ([city contains:@"市"]) {
                NSString *locationName = [city stringByReplacingOccurrencesOfString:@"市" withString:@""];
                [XYGetWeatherData getDetailedWeatherDataWithCityName:locationName withTag:tag success:^(XYWeatherData *weatherData) {
                    if (success) {
                        success(weatherData);
                    }
                } failure:^(NSError *error) {
                    failure(error);
                }];
            }
        }
    }];
}

+ (void)getDetailedWeatherDataWithPlacemark:(CLPlacemark *)placemark withTag:(NSInteger)tag success:(void (^)(XYWeatherData *))success failure:(void (^)(NSError *))failure
{
    NSDictionary *addressDict = placemark.addressDictionary;
    NSString *cityStr = [addressDict objectForKey:(NSString *)kABPersonAddressCityKey];
    if ([cityStr contains:@"市"]) {
        NSString *cityName = [cityStr stringByReplacingOccurrencesOfString:@"市" withString:@""];
        [XYGetWeatherData getDetailedWeatherDataWithCityName:cityName withTag:tag success:^(XYWeatherData *weatherData) {
            if (success) {
                success(weatherData);
            }
        } failure:^(NSError *error) {
            if (failure) {
                failure(error);
            }
        }];
    }
    
}
@end
