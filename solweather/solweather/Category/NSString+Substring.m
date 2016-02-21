//
//  NSString+Substring.m
//  
//
//  Created by xiayao on 16/2/12.
//
//

#import "NSString+Substring.h"

@implementation NSString (Substring)
- (BOOL)contains:(NSString *)substring
{
    if([self rangeOfString:substring].location != NSNotFound) {
        return YES;
    }
    return NO;
}

@end
