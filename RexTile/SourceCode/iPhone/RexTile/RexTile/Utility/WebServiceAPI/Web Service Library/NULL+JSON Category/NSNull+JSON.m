//
//  NSNull+JSON.m
//  WCI
//
//  Created by Rahul N. Mane on 19/06/14.
//  Copyright (c) 2014 Rahul N. Mane. All rights reserved.
//

#import "NSNull+JSON.h"

@implementation NSNull (JSON)

- (NSUInteger)length { return 0; }

- (NSInteger)integerValue { return 0; };

- (float)floatValue { return 0; };

- (NSString *)description { return @"-"; }

- (BOOL)isEqualToString:(NSString *)aString{
    return NO;
}
- (NSArray *)componentsSeparatedByString:(NSString *)separator { return @[]; }

- (id)objectForKey:(id)key { return nil; }

- (BOOL)boolValue { return NO; }

@end
