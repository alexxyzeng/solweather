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
//        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithXMLString:responseObject options:1 error:nil];
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:responseObject options:1 error:nil];
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
        if ([weatherData.cityName isEqualToString:@"襄樊" ]) {
            weatherData.cityName = @"襄阳";
        }
        //当前天气概况
        NSString *overviewStr = [[dataArray objectAtIndex:6] stringValue];
        NSArray *overview = [overviewStr componentsSeparatedByString:@" "];
        weatherData.weatherOverview = overview[1] ;
                NSLog(@"%@", weatherData.weatherOverview);
        //获取天气图标
        weatherData.weatherImgStr = [[dataArray objectAtIndex:8] stringValue];
//        if ([weatherStr contains:@"雾"] && ![weatherStr contains:@"霾"]) {
//            weatherData.weatherImg = [UIImage imageNamed:@"fog"];
//        }
        //获取更多的天气信息
        NSString *desc = [[dataArray objectAtIndex:10] stringValue];
        
        NSString *content = [desc substringFromIndex:7];
        NSLog(@"%@", content);
        NSArray *comp = [content componentsSeparatedByString:@"；"];
        //温度范围
        weatherData.todayTemp = [[dataArray objectAtIndex:5] stringValue];
        NSLog(@"%@", weatherData.todayTemp);
        //当前温度
        NSString *temp = [comp[0] substringFromIndex:3];
        weatherData.currTemp = [temp stringByReplacingOccurrencesOfString:@"℃" withString:@"°"];
                NSLog(@"%@", weatherData.currTemp);
        //风向 风力
        weatherData.windScale = [comp[1] substringFromIndex:6];
                NSLog(@"%@", weatherData.windScale);
         //湿度
        weatherData.humidity = comp[2];
                NSLog(@"%@", weatherData.humidity);
        //空气质量
        NSString *aqi = comp[3];
        NSArray *airArr = [aqi componentsSeparatedByString:@"。"];
        weatherData.airQuality = airArr[1];
                NSLog(@"%@", weatherData.airQuality);
        //获取明天天气
        weatherData.tomorrowImgStr = [[dataArray objectAtIndex:15] stringValue];
                NSLog(@"%@", weatherData.tomorrowImgStr);
//        if ([tomorrowStr contains:@"雾"] && ![tomorrowStr contains:@"霾"]) {
//            weatherData.tomorrowImg = [UIImage imageNamed:@"fog"];
//        }
        weatherData.tomorrowTemp = [[dataArray objectAtIndex:12] stringValue];
                NSLog(@"%@", weatherData.tomorrowTemp);
        weatherData.thirdImgStr = [[dataArray objectAtIndex:20] stringValue];
                NSLog(@"%@", weatherData.thirdImgStr);
        weatherData.thirdTemp = [[dataArray objectAtIndex:17] stringValue];
                NSLog(@"%@", weatherData.thirdTemp);
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
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count > 0) {
            //地理信息反编译，获取当前城市信息
            CLPlacemark *placemark = placemarks[0];
            NSDictionary *addressDict = placemark.addressDictionary;
            NSString *city = [addressDict objectForKey:(NSString *)kABPersonAddressCityKey];
            //根据当前城市信息，获取天气数据
            if ([city contains:@"市"]) {
                NSString *locationName = [city stringByReplacingOccurrencesOfString:@"市" withString:@""];
                NSLog(@"%@", locationName);
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
    NSLog(@"%@",cityStr);
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
