//
//  NTYAirDataServer.m
//  NTYAirData
//
//  Created by naoty on 2014/05/19.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

#import "NTYAirDataServer.h"
#import "NTYResourceDescription.h"
#import "NSManagedObject+NTYJSON.h"
#import "NSString+NTYCheck.h"

#import "GCDWebServer.h"
#import "GCDWebServerURLEncodedFormRequest.h"
#import "GCDWebServerDataResponse.h"

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
    [self addHandlerToPostResource:resource];
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

- (void)addHandlerToPostResource:(NTYResourceDescription *)resource
{
    __block NTYAirDataServer *weakSelf = self;
    
    NSString *path = [NSString stringWithFormat:@"/%@.json", resource.name];
    [self.server addHandlerForMethod:@"POST" path:path requestClass:[GCDWebServerURLEncodedFormRequest class] processBlock:^GCDWebServerResponse* (GCDWebServerRequest *request) {
        GCDWebServerURLEncodedFormRequest *formRequest = (GCDWebServerURLEncodedFormRequest *)request;
        
        NSManagedObject *newObject = [NSEntityDescription insertNewObjectForEntityForName:resource.entityName inManagedObjectContext:weakSelf.managedObjectContext];
        NSEntityDescription *entity = [NSEntityDescription entityForName:resource.entityName inManagedObjectContext:weakSelf.managedObjectContext];
        for (NSString *attributeName in entity.attributesByName.allKeys) {
            NSString *value = formRequest.arguments[attributeName];
            if (value == nil) {
                continue;
            } else if ([value isInteger]) {
                [newObject setValue:[NSNumber numberWithInteger:value.integerValue] forKey:attributeName];
            } else if ([value isFloat]) {
                [newObject setValue:[NSNumber numberWithFloat:value.floatValue] forKey:attributeName];
            } else if ([value isBoolean]) {
                [newObject setValue:[NSNumber numberWithBool:value.boolValue] forKey:attributeName];
            } else {
                [newObject setValue:value forKey:attributeName];
            }
        }
        
        [weakSelf.managedObjectContext save:nil];
        
        return [GCDWebServerDataResponse responseWithJSONObject:@{}];
    }];
}

@end
