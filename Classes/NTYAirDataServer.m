//
//  NTYAirDataServer.m
//  NTYAirData
//
//  Created by naoty on 2014/05/19.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

#import "NTYAirDataServer.h"
#import "GCDWebServer.h"
#import "GCDWebServerDataResponse.h"
#import "NSString+NTYSnakecase.h"
#import "NSString+ActiveSupportInflector.h"
#import "NSManagedObject+NTYJSON.h"

@interface NTYAirDataServer ()
@property (nonatomic) GCDWebServer *server;
@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) NSManagedObjectModel *managedObjectModel;
@end

@implementation NTYAirDataServer

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
                          managedObjectModel:(NSManagedObjectModel *)managedObjectModel
{
    self = [super init];
    if (self) {
        self.server = [GCDWebServer new];
        self.managedObjectContext = managedObjectContext;
        self.managedObjectModel = managedObjectModel;
    }
    return self;
}

- (void)start
{
    for (NSEntityDescription *entity in self.managedObjectModel.entities) {
        [self addHandlerToGetResourcesForEntity:entity];
    }
    
    [self.server start];
}

#pragma mark - Private methods

- (void)addHandlerToGetResourcesForEntity:(NSEntityDescription *)entity
{
    __block NTYAirDataServer *weakSelf = self;
    
    NSString *resourceName = entity.name.pluralizeString.snakecaseString;
    NSString *path = [NSString stringWithFormat:@"/%@.json", resourceName];
    [self.server addHandlerForMethod:@"GET" path:path requestClass:[GCDWebServerRequest class] processBlock:^GCDWebServerResponse* (GCDWebServerRequest *request){
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entity.name];
        NSArray *objects = [weakSelf.managedObjectContext executeFetchRequest:fetchRequest error:nil];
        
        NSMutableArray *JSONObjects = [NSMutableArray new];
        for (NSManagedObject *object in objects) {
            [JSONObjects addObject:object.JSONObject];
        }
        
        return [GCDWebServerDataResponse responseWithJSONObject:JSONObjects];
    }];
}

@end
