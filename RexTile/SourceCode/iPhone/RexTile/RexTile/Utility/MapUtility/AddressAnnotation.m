//
//  AddressAnnotation.m
//  FridgeApp
//
//  Created by Zoolook_MacBook on 20/01/11.
//  Copyright 2011 Zoolook. All rights reserved.
//

#import "AddressAnnotation.h"
#import "Cache.h"

@implementation AddressAnnotation

@synthesize coordinate;

@synthesize title;
@synthesize subtitle;
@synthesize index;

//- (NSString *)subtitle{
//	return mSubTitle;
//}
//
- (NSString *)title{
	return title;
}

-(CLLocationCoordinate2D)coordinate{
    return coordinate;
}
-(id)initWithCoordinate:(CLLocationCoordinate2D) c{
    self = [super init];
    if (self != nil)
    {
        coordinate = c;
    }
//	coordinate=c;
	//NSLog(@"init %f,%f",c.latitude,c.longitude);
	return self;
}
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    coordinate = newCoordinate;
}



@end