//
//  NTYAirDataServer.h
//  NTYAirData
//
//  Created by naoty on 2014/05/19.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NTYAirDataServer : NSObject

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
                          managedObjectModel:(NSManagedObjectModel *)managedObjectModel;
- (void)start;

@end
