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
+ (NSMutableDictionary *)weatherData;

/**
 Save the given weather data
 @param weatherData Weather data to save
 */
+ (void)setWeatherData:(NSMutableDictionary *)weatherData;

/**
 Get the saved ordered-list of weather tags
 @returns The saved weather tags
 */
+ (NSMutableArray *)weatherTags;

/**
 Save the given ordered-list of weather tags
 @param weatherTags List of weather tags
 */
+ (void)setWeatherTags:(NSMutableArray *)weatherTags;
@end
