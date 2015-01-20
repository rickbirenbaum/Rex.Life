//
//  CoreLocationController.h
//  CoreLocationDemo
//
//  Created by Nicholas Vellios on 8/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol CoreLocationControllerDelegate
@required

- (void)locationUpdate:(CLLocation *)location;
- (void)locationError:(NSError *)error;

@end


@interface CoreLocationController : NSObject <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locMgr;
@property (strong, nonatomic) id delegate;

@end
