//
//  GoogleParser.m
//  RexTile
//
//  Created by Sweety Singh on 12/17/14.
//  Copyright (c) 2014 Perennial. All rights reserved.
//

#import "GoogleParser.h"
#import "GeoCodeModel.h"
#import "GooglePlaceModel.h"

#import <CoreLocation/CoreLocation.h>

@implementation GoogleParser

- (NSArray *)parseGooglePlacesResponse:(NSArray *)response{
    
    NSMutableArray *placeModels = [NSMutableArray array];
   
    NSArray * placesArray = response;
   
    for (NSDictionary *place in placesArray){
     
        GooglePlaceModel *googlePlaceModel = [[GooglePlaceModel alloc] init];
        
        googlePlaceModel.latitude = [[[[place objectForKey:@"geometry"] objectForKey:@"location"] valueForKey:@"lat"] doubleValue];
        googlePlaceModel.longitude = [[[[place objectForKey:@"geometry"] objectForKey:@"location"] valueForKey:@"lng"] doubleValue];

        
        googlePlaceModel.coordinates = CLLocationCoordinate2DMake(googlePlaceModel.latitude,googlePlaceModel.longitude);
        
        googlePlaceModel.placeName = [place valueForKey:@"name"];
        googlePlaceModel.placeID = [place valueForKey:@"place_id"];
        googlePlaceModel.placeAddress = [place valueForKey:@"vicinity"];
        googlePlaceModel.category = [place objectForKey:@"types"];
        googlePlaceModel.placeIcon = [place valueForKey:@"icon"];
        
        CLLocation *startLocation = [[CLLocation alloc] initWithLatitude: (CLLocationDegrees)[[[NSUserDefaults standardUserDefaults] objectForKey:UserChosenLatitude] doubleValue] longitude:(CLLocationDegrees)[[[NSUserDefaults standardUserDefaults] objectForKey:UserChosenLongitude] doubleValue]];
        
        CLLocation *endLocation = [[CLLocation alloc] initWithLatitude:(CLLocationDegrees) googlePlaceModel.latitude  longitude:(CLLocationDegrees)  googlePlaceModel.longitude];
        CLLocationDistance distance = [startLocation distanceFromLocation:endLocation]; // aka double
        googlePlaceModel.distanceInMeter = distance;
     //   NSLog(@"distance %f",distance);
//        NSLog(@"Calculated Miles %@ feet %f", [NSString stringWithFormat:@"%f",(distance/1609.344)],(distance*3.281));
        if (lroundf(distance*3.281) < 500) {
            googlePlaceModel.strDistance = [NSString stringWithFormat:@"%ld ft",lroundf(distance*3.281)];
        }else{
            googlePlaceModel.strDistance = [NSString stringWithFormat:@"%.1f mi",(distance/1609.344)];
        }
        
        [placeModels addObject:googlePlaceModel];
    }
    
    return placeModels;
}

- (NSArray *)parseGoogleTextSearchResponse:(NSArray *)response{
    
    NSMutableArray *placeModels = [NSMutableArray array];
    
    NSArray * placesArray = response;
    
    for (NSDictionary *place in placesArray){
        
        GooglePlaceModel *googlePlaceModel = [[GooglePlaceModel alloc] init];
        
        googlePlaceModel.latitude = [[[[place objectForKey:@"geometry"] objectForKey:@"location"] valueForKey:@"lat"] doubleValue];
        googlePlaceModel.longitude = [[[[place objectForKey:@"geometry"] objectForKey:@"location"] valueForKey:@"lng"] doubleValue];
        
        
        googlePlaceModel.coordinates = CLLocationCoordinate2DMake(googlePlaceModel.latitude,googlePlaceModel.longitude);
        
        googlePlaceModel.placeName = [place valueForKey:@"name"];
        googlePlaceModel.placeID = [place valueForKey:@"place_id"];
        googlePlaceModel.placeAddress = [place valueForKey:@"formatted_address"];
        googlePlaceModel.category = [place objectForKey:@"types"];
        googlePlaceModel.placeIcon = [place valueForKey:@"icon"];
        CLLocation *startLocation = [[CLLocation alloc] initWithLatitude: (CLLocationDegrees)[[[NSUserDefaults standardUserDefaults] objectForKey:UserChosenLatitude] doubleValue] longitude:(CLLocationDegrees)[[[NSUserDefaults standardUserDefaults] objectForKey:UserChosenLongitude] doubleValue]];
        
        CLLocation *endLocation = [[CLLocation alloc] initWithLatitude:(CLLocationDegrees) googlePlaceModel.latitude  longitude:(CLLocationDegrees)  googlePlaceModel.longitude];
        CLLocationDistance distance = [startLocation distanceFromLocation:endLocation]; // aka double
        googlePlaceModel.distanceInMeter = distance;
        //   NSLog(@"distance %f",distance);
        //   NSLog(@"Calculated Miles %@ feet %f", [NSString stringWithFormat:@"%f",(distance/1609.344)],(distance*3.281));
        if (lroundf(distance*3.281) < 500) {
            googlePlaceModel.strDistance = [NSString stringWithFormat:@"%ld ft",lroundf(distance*3.281)];
        }else{
            googlePlaceModel.strDistance = [NSString stringWithFormat:@"%.1f mi",(distance/1609.344)];
        }
        
        [placeModels addObject:googlePlaceModel];
    }
    
    return placeModels;
}



- (NSArray *)parseGeoCodeResponse:(NSArray *)response{
     NSMutableArray *locations = [NSMutableArray array];
     NSArray *foundLocations = response;
    for (NSDictionary *location in foundLocations) {
        
        GeoCodeModel *geoModel = [[GeoCodeModel alloc] init];
        geoModel.latitude = [[[[location objectForKey:@"geometry"] objectForKey:@"location"] valueForKey:@"lat"] doubleValue];
        geoModel.longitude = [[[[location objectForKey:@"geometry"] objectForKey:@"location"] valueForKey:@"lng"] doubleValue];
        geoModel.address = [location objectForKey:@"formatted_address"];
        
        geoModel.coordinates = CLLocationCoordinate2DMake(geoModel.latitude, geoModel.longitude);
        
        
        [locations addObject:geoModel];
    }
    
    
    return locations;
}
- (NSArray *)parsePlaceDetailResponse:(NSDictionary *)response{
    NSMutableArray *placeDetail  = [NSMutableArray array];
    
    GooglePlaceModel *googlePlaceModel = [[GooglePlaceModel alloc] init];
    googlePlaceModel.latitude = [[[[response objectForKey:@"geometry"] objectForKey:@"location"] valueForKey:@"lat"] doubleValue];
    googlePlaceModel.longitude = [[[[response objectForKey:@"geometry"] objectForKey:@"location"] valueForKey:@"lng"] doubleValue];
    googlePlaceModel.placeName = [response valueForKey:@"name"];
    googlePlaceModel.placeID = [response valueForKey:@"place_id"];
    googlePlaceModel.placeAddress = [response valueForKey:@"formatted_address"];
    googlePlaceModel.category = [response objectForKey:@"types"];
    googlePlaceModel.placePhoneNo = [response valueForKey:@"international_phone_number"];
    googlePlaceModel.openHours = [[response objectForKey:@"opening_hours"] objectForKey:@"weekday_text"];
    googlePlaceModel.placeWebsite = [response valueForKey:@"website"];
    
    CLLocation *startLocation = [[CLLocation alloc] initWithLatitude: (CLLocationDegrees)[[[NSUserDefaults standardUserDefaults] objectForKey:UserChosenLatitude] doubleValue] longitude:(CLLocationDegrees)[[[NSUserDefaults standardUserDefaults] objectForKey:UserChosenLongitude] doubleValue]];
    
    CLLocation *endLocation = [[CLLocation alloc] initWithLatitude:(CLLocationDegrees) googlePlaceModel.latitude  longitude:(CLLocationDegrees)  googlePlaceModel.longitude];
    CLLocationDistance distance = [startLocation distanceFromLocation:endLocation]; // aka double
    NSLog(@"distance %f",distance);
    googlePlaceModel.distanceInMeter = distance;
  //  NSLog(@"Calculated Miles %@ feet %f", [NSString stringWithFormat:@"%f",(distance/1609.344)],(distance*3.281));
    if (lroundf(distance*3.281) < 500) {
        googlePlaceModel.strDistance = [NSString stringWithFormat:@"%ld ft",lroundf(distance*3.281)];
    }else{
        googlePlaceModel.strDistance = [NSString stringWithFormat:@"%.1f mi",(distance/1609.344)];
    }

    NSMutableArray *photos = [response objectForKey:@"photos"];
    NSMutableArray *photosArry = [[NSMutableArray alloc] init];
    for (int i = 0; i < [photos count]; i++) {
       
        NSString *photoReference = [[photos objectAtIndex:i] valueForKey:@"photo_reference"];
        [photosArry addObject:photoReference];
    }
    googlePlaceModel.photoArray = photosArry;
    googlePlaceModel.placeRating = [NSString stringWithFormat:@"%@",[response valueForKey:@"rating"]];

    [placeDetail addObject:googlePlaceModel];
    
    return placeDetail;
}












-(NSArray *)parseGooglePlacesResult:(NSDictionary *)response{
    NSMutableArray *placeModels = [NSMutableArray array];
    
    
    
    
    
    return placeModels;
}











@end
