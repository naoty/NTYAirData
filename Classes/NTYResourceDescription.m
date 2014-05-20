//
//  NTYResourceDescription.m
//  NTYAirData
//
//  Created by naoty on 2014/05/20.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

#import "NTYResourceDescription.h"
#import "NSString+NTYSnakecase.h"
#import "NSString+ActiveSupportInflector.h"

@interface NTYResourceDescription ()
@property (nonatomic, copy) NSString *entityName;
@property (nonatomic, copy) NSString *resourceKey;
@end

@implementation NTYResourceDescription

+ (instancetype)resourceForEntityName:(NSString *)entityName resourceKey:(NSString *)resourceKey
{
    NTYResourceDescription *resource = [self new];
    if (resource) {
        resource.entityName = entityName;
        resource.resourceKey = resourceKey;
    }
    return resource;
}

- (NSString *)name
{
    return _entityName.pluralizeString.snakecaseString;
}

@end
