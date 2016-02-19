//
//  XYWeatherManager.m
//  Sol°C
//
//  Created by xiayao on 16/2/4.
//  Copyright © 2016年 xiayao. All rights reserved.
//

#import "XYWeatherStateManager.h"

@implementation XYWeatherStateManager
+ (NSDictionary *)weatherData
{
    NSData *encodedWeatherData = [[NSUserDefaults standardUserDefaults]objectForKey:@"weather_data"];
    if(encodedWeatherData) {
        return (NSDictionary *)[NSKeyedUnarchiver unarchiveObjectWithData:encodedWeatherData];
    }
    return nil;
}

+ (void)setWeatherData:(NSDictionary *)weatherData
{
    NSData *encodedWeatherData = [NSKeyedArchiver archivedDataWithRootObject:weatherData];
    [[NSUserDefaults standardUserDefaults]setObject:encodedWeatherData forKey:@"weather_data"];
}

+ (NSArray *)weatherTags
{
    NSData *encodedWeatherTags = [[NSUserDefaults standardUserDefaults]objectForKey:@"weather_tags"];
    if(encodedWeatherTags) {
        return (NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:encodedWeatherTags];
    }
    return nil;
}

+ (void)setWeatherTags:(NSArray *)weatherTags
{
    NSData *encodedWeatherTags = [NSKeyedArchiver archivedDataWithRootObject:weatherTags];
    [[NSUserDefaults standardUserDefaults]setObject:encodedWeatherTags forKey:@"weather_tags"];
}
@end
