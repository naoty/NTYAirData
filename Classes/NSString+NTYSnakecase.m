//
//  NSString+NTYSnakecase.m
//  NTYAirData
//
//  Created by naoty on 2014/05/19.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

#import "NSString+NTYSnakecase.h"

@implementation NSString (NTYSnakecase)

- (instancetype)snakecaseString
{
    NSString *scannedString;
    NSMutableString *snakecaseString = [NSMutableString new];
    NSCharacterSet *uppercaseLetterCharacterSet = [NSCharacterSet uppercaseLetterCharacterSet];
    
    NSScanner *scanner = [NSScanner scannerWithString:self];
    while (!scanner.isAtEnd) {
        if ([scanner scanCharactersFromSet:uppercaseLetterCharacterSet intoString:&scannedString]) {
            [snakecaseString appendString:scannedString.lowercaseString];
        }
        if ([scanner scanUpToCharactersFromSet:uppercaseLetterCharacterSet intoString:&scannedString]) {
            [snakecaseString appendString:scannedString];
            [snakecaseString appendString:@"_"];
        }
    }
    
    return [snakecaseString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"_"]];
}

@end
