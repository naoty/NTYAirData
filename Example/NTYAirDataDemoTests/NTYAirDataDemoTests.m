//
//  NTYAirDataDemoTests.m
//  NTYAirDataDemoTests
//
//  Created by naoty on 2014/05/19.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NTYAirData.h"
#import "AFNetworking.h"
#import "TKRGuard.h"

@interface NTYAirDataDemoTests : XCTestCase
@property (nonatomic) NTYAirDataServer *dataServer;

@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, readonly) NSURL *applicationDocumentDirectoryURL;

@property (nonatomic) AFHTTPRequestOperationManager *manager;
@end

@implementation NTYAirDataDemoTests

- (void)setUp
{
    [super setUp];
    
    self.dataServer = [[NTYAirDataServer alloc] initWithManagedObjectContext:self.managedObjectContext];
    [self.dataServer addResource:[NTYResourceDescription resourceForEntityName:@"User" resourceKey:@"name"]];
    [self.dataServer startWithPort:5678];
    self.manager = [AFHTTPRequestOperationManager manager];
}

- (void)tearDown
{
    [self.dataServer stop];
    
    [super tearDown];
}

- (void)testGetObjects
{
    __block BOOL success;
    [self.manager GET:@"http://localhost:5678/users.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success = YES;
        RESUME;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        success = NO;
        RESUME;
    }];
    
    WAIT;
    XCTAssertTrue(success, @"");
}

- (void)testGetObject
{
    __block BOOL success;
    [self.manager GET:@"http://localhost:5678/users/Alice.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success = YES;
        RESUME;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        success = NO;
        RESUME;
    }];
    
    WAIT;
    XCTAssertTrue(success, @"");
}

- (void)testPostObject
{
    __block BOOL success;
    
    NSDictionary *parameters = @{@"name": @"New user", @"age": @20};
    [self.manager POST:@"http://localhost:5678/users.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success = YES;
        RESUME;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        success = NO;
        RESUME;
    }];
    
    WAIT;
    XCTAssertTrue(success, @"");
}

#pragma mark - Core Data

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    if (self.persistentStoreCoordinator) {
        self.managedObjectContext = [NSManagedObjectContext new];
        _managedObjectContext.persistentStoreCoordinator = _persistentStoreCoordinator;
    }
    return _managedObjectContext;
    
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [self.applicationDocumentDirectoryURL URLByAppendingPathComponent:@"NTYAirDataDemoTests.sqlite"];
    
    NSError *error = nil;
    self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Error: %@", error);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    self.managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

#pragma mark - Private methods

- (NSURL *)applicationDocumentDirectoryURL
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
