//
//  NTYAirDataServer.h
//  NTYAirData
//
//  Created by naoty on 2014/05/19.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NTYResourceDescription;

@interface NTYAirDataServer : NSObject

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
- (void)addResource:(NTYResourceDescription *)resource;

- (void)start;
- (void)startWithPort:(NSUInteger)port;
- (void)stop;

@end
