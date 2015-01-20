//
//  GooglePlaceModel.h
//  RexTile
//
//  Created by Sweety Singh on 12/17/14.
//  Copyright (c) 2014 Perennial. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface GooglePlaceModel : NSObject


@property (strong, nonatomic) NSString *placeAddress;
@property (strong, nonatomic) NSString *placeID;
@property (strong, nonatomic) NSString *placeName;
@property (strong, nonatomic) NSArray *category;
@property (readwrite, nonatomic) double latitude;
@property (readwrite, nonatomic) double longitude;
@property (readwrite, nonatomic) double distanceInMeter;
@property (readwrite, nonatomic) NSString *strDistance;
@property (readwrite, nonatomic) CLLocationCoordinate2D coordinates;
@property (strong, nonatomic) NSString *placePhoneNo;
@property (strong, nonatomic) NSArray *openHours;
@property (strong, nonatomic) NSString *placeWebsite;
@property (strong, nonatomic) NSMutableArray *photoArray;
@property (strong, nonatomic) NSString *placeRating;
@property (strong, nonatomic) NSString *placeIcon;

@property (strong, nonatomic) NSString  *rec_recomended_users;
@property (readwrite, nonatomic) BOOL isAddedRec;

- (void)setIsAddedRecByNumber:(NSNumber *)number;

@end
