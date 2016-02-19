//
//  XYWeatherManager.h
//  Sol°C
//
//  Created by xiayao on 16/2/4.
//  Copyright © 2016年 xiayao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XYWeatherData;

@interface XYWeatherStateManager : NSObject
/**
 Get saved weather data
 @returns Saved weather data as a dictionary
 */
+ (NSDictionary *)weatherData;

/**
 Save the given weather data
 @param weatherData Weather data to save
 */
+ (void)setWeatherData:(NSDictionary *)weatherData;

/**
 Get the saved ordered-list of weather tags
 @returns The saved weather tags
 */
+ (NSArray *)weatherTags;

/**
 Save the given ordered-list of weather tags
 @param weatherTags List of weather tags
 */
+ (void)setWeatherTags:(NSArray *)weatherTags;
@end
