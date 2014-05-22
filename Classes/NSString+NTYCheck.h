//
//  NSString+NTYCheck.h
//  NTYAirData
//
//  Created by naoty on 2014/05/22.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NTYCheck)

- (BOOL)isInteger;
- (BOOL)isFloat;
- (BOOL)isBoolean;

@end
