//
//  NTYResourceDescription.h
//  NTYAirData
//
//  Created by naoty on 2014/05/20.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NTYResourceDescription : NSObject

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *entityName;
@property (nonatomic, copy, readonly) NSString *resourceKey;

+ (instancetype)resourceForEntityName:(NSString *)entityName resourceKey:(NSString *)resourceKey;

@end
