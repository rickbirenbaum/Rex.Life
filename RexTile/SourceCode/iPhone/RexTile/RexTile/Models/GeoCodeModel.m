//
//  GeoCodeModel.m
//  RexTile
//
//  Created by Sweety Singh on 12/17/14.
//  Copyright (c) 2014 Perennial. All rights reserved.
//

#import "GeoCodeModel.h"

@implementation GeoCodeModel
#ifdef DEBUG

- (NSString *)description
{
    NSMutableString *propertyDescriptions = [[NSMutableString alloc] init];
    NSDictionary *descriptions = [self describablePropertyNames];
    for (NSString *key in [descriptions allKeys])
    {
        id value = [self valueForKey:key];
        NSString *displayName = [descriptions valueForKey:key];
        [propertyDescriptions appendFormat:@"; %@ = %@", displayName, value];
    }
    return [NSString stringWithFormat:@"<%@: 0x%lx%@>", [self class], (unsigned long)self, propertyDescriptions];
}

- (NSDictionary *)describablePropertyNames
{
    return @{@"restaurant_id" : @"RestaurantId", @"restaurant_name" : @"RestaurantName", @"restaurant_address" : @"RestaurantAddress", @"restaurant_picUrl" : @"RestaurantPicUrl", @"restaurant_rating" : @"RestaurantRating"};
}

#endif
@end
