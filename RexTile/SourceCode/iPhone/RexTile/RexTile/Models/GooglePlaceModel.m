//
//  GooglePlaceModel.m
//  RexTile
//
//  Created by Sweety Singh on 12/17/14.
//  Copyright (c) 2014 Perennial. All rights reserved.
//

#import "GooglePlaceModel.h"

@implementation GooglePlaceModel
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
    return @{@"placeAddress" : @"Address", @"placeID" : @"Place ID", @"placeName" : @"Name", @"category" : @"Category",@"coordinates":@"Place cordinate", @"isAddedRec" : @"Added Rec"};
}



#endif

- (void)setIsAddedRecByNumber:(NSNumber *)number
{
    if ([number intValue] == 1) {
        self.isAddedRec = YES;
    }
    else
    {
        self.isAddedRec = NO;
    }
}


@end
