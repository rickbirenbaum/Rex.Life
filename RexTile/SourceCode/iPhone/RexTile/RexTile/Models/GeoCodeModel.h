//
//  GeoCodeModel.h
//  RexTile
//
//  Created by Sweety Singh on 12/17/14.
//  Copyright (c) 2014 Perennial. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface GeoCodeModel : NSObject

@property (strong, nonatomic) NSString *address;
@property (readwrite, nonatomic) double latitude;
@property (readwrite, nonatomic) double longitude;
@property (readwrite, nonatomic) CLLocationCoordinate2D coordinates;
@end
