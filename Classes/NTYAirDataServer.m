//
//  NTYAirDataServer.m
//  NTYAirData
//
//  Created by naoty on 2014/05/19.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

#import "NTYAirDataServer.h"
#import "NTYResourceDescription.h"

#import "GCDWebServer.h"
#import "GCDWebServerDataResponse.h"
#import "NSManagedObject+NTYJSON.h"

@interface NTYAirDataServer ()
@property (nonatomic) GCDWebServer *server;
@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@end

@implementation NTYAirDataServer

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    self = [super init];
    if (self) {
        self.server = [GCDWebServer new];
        self.managedObjectContext = managedObjectContext;
    }
    return self;
}

- (void)addResource:(NTYResourceDescription *)resource
{
    [self addHandlerToGetResources:resource];
    [self addHandlerToGetResource:resource];
}

- (void)start
{
    [self.server start];
}

- (void)startWithPort:(NSUInteger)port
{
    [self.server startWithPort:port bonjourName:nil];
}

- (void)stop
{
    [self.server stop];
}

#pragma mark - Private methods

- (void)addHandlerToGetResources:(NTYResourceDescription *)resource
{
    __block NTYAirDataServer *weakSelf = self;
    
    NSString *path = [NSString stringWithFormat:@"/%@.json", resource.name];
    [self.server addHandlerForMethod:@"GET" path:path requestClass:[GCDWebServerRequest class] processBlock:^GCDWebServerResponse* (GCDWebServerRequest *request){
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:resource.entityName];
        NSArray *objects = [weakSelf.managedObjectContext executeFetchRequest:fetchRequest error:nil];
        
        NSMutableArray *JSONObjects = [NSMutableArray new];
        for (NSManagedObject *object in objects) {
            [JSONObjects addObject:object.JSONObject];
        }
        
        return [GCDWebServerDataResponse responseWithJSONObject:JSONObjects];
    }];
}

- (void)addHandlerToGetResource:(NTYResourceDescription *)resource
{
    __block NTYAirDataServer *weakSelf = self;
    
    NSString *path = [NSString stringWithFormat:@"/%@/.*\\.json", resource.name];
    [self.server addHandlerForMethod:@"GET" pathRegex:path requestClass:[GCDWebServerRequest class] processBlock:^GCDWebServerResponse* (GCDWebServerRequest *request){
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:resource.entityName];
        
        NSString *valueForResourceKey = [request.path.lastPathComponent stringByDeletingPathExtension];
        NSPredicate *predicate = [NSComparisonPredicate predicateWithLeftExpression:[NSExpression expressionForKeyPath:resource.resourceKey]
                                                                    rightExpression:[NSExpression expressionForConstantValue:valueForResourceKey]
                                                                           modifier:NSDirectPredicateModifier
                                                                               type:NSEqualToPredicateOperatorType
                                                                            options:0];
        fetchRequest.predicate = predicate;
        
        NSManagedObject *object = [[weakSelf.managedObjectContext executeFetchRequest:fetchRequest error:nil] firstObject];
        return [GCDWebServerDataResponse responseWithJSONObject:object.JSONObject ?: @{}];
    }];
}

@end
