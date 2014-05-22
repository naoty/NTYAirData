//
//  NSString+NTYCheck.m
//  NTYAirData
//
//  Created by naoty on 2014/05/22.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

#import "NSString+NTYCheck.h"

@implementation NSString (NTYCheck)

- (BOOL)isInteger
{
    NSScanner *scanner = [NSScanner scannerWithString:self];
    return [scanner scanInt:nil] && scanner.isAtEnd;
}

- (BOOL)isFloat
{
    NSScanner *scanner = [NSScanner scannerWithString:self];
    return [scanner scanInt:nil] && scanner.isAtEnd;
}

- (BOOL)isBoolean
{
    NSArray *booleanStrings = @[@"YES", @"NO", @"yes", @"no", @"TRUE", @"FALSE", @"true", @"false"];
    return [booleanStrings containsObject:self];
}

@end
