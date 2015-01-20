//
//  CoreLocationController.m
//  CoreLocationDemo
//
//  Created by Nicholas Vellios on 8/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//




#import "CoreLocationController.h"
#import "Constants.h"


@implementation CoreLocationController

- (id)init
{
	self = [super init];
	
	if(self != nil) {
		self.locMgr = [[CLLocationManager alloc] init];
		self.locMgr.delegate = self;
        self.locMgr.desiredAccuracy = kCLLocationAccuracyBest;
#ifdef __IPHONE_8_0
        if(IS_OS_8_OR_LATER) {
            // Use one or the other, not both. Depending on what you put in info.plist
            [self.locMgr requestWhenInUseAuthorization];
            [self.locMgr requestAlwaysAuthorization];
        }
#endif
        //Set some parameters for the location object.
        
        [self.locMgr startUpdatingLocation];

	}
	return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	if([self.delegate conformsToProtocol:@protocol(CoreLocationControllerDelegate)])
    {
		[self.delegate locationUpdate:newLocation];
	}
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	if([self.delegate conformsToProtocol:@protocol(CoreLocationControllerDelegate)])
    {
		[self.delegate locationError:error];
	}
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        
       
        
    }
}
@end
