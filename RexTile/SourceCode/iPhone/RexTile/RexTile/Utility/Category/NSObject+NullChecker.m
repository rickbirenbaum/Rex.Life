//
//  NSObject+NullChecker.m
//  I_Like_My_Waitress
//
//  Created by Rahul V. Mane on 9/9/14.
//  Copyright (c) 2014 Perennial. All rights reserved.
//

#import "NSObject+NullChecker.h"

@implementation NSObject (NullChecker)

+ (BOOL) isNull:(id)value
{
    if (value == [NSNull null] || value == nil || [value isEqual: @""] || [[value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)
        return YES;
    
    return NO;
}

@end
