//
//  NSManagedObject+NTYJSON.h
//  NTYAirData
//
//  Created by naoty on 2014/05/19.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (NTYJSON)

@property (nonatomic, readonly) NSDictionary *JSONObject;

@end
