//
//  NSManagedObject+NTYJSON.m
//  NTYAirData
//
//  Created by naoty on 2014/05/18.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

#import "NSManagedObject+NTYJSON.h"

@implementation NSManagedObject (NTYJSON)

- (NSDictionary *)JSONObject
{
    NSMutableDictionary *data = [NSMutableDictionary new];
    NSArray *keys = self.entity.attributesByName.allKeys;
    NSDateFormatter *dateFormatter;
    for (NSString *key in keys) {
        id value = [self valueForKey:key];
        
        if (value == nil) {
            value = @"";
        }
        
        if ([value isKindOfClass:[NSDate class]]) {
            NSDate *dateValue = (NSDate *)value;
            if (dateFormatter == nil) {
                dateFormatter = [NSDateFormatter new];
                dateFormatter.dateFormat = @"yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZZ";
            }
            value = [dateFormatter stringFromDate:dateValue];
        }
        
        data[key] = value;
    }
    return data.copy;
}

@end
