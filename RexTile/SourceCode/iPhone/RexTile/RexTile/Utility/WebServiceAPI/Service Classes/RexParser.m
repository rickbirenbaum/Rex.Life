//
//  RexParser.m
//  RexTile
//
//  Created by Sweety Singh on 12/23/14.
//  Copyright (c) 2014 Perennial. All rights reserved.
//

#import "RexParser.h"
#import "RecommendationModel.h"
#import <CoreLocation/CoreLocation.h>
#import "GooglePlaceModel.h"

@implementation RexParser


- (NSArray *)userWebClientSignInSignUpParser:(NSDictionary *)responseData{
    
    UserModel *user = [UserModel sharedInstance];
    
    user.user_userId = responseData[@"user_id"];
    user.user_emailId = responseData[@"email_id"];
    user.user_phoneNo = responseData[@"phone"];
    user.user_userName = responseData[@"user_name"];
    user.user_sessionId = responseData[@"session_id"];
    user.user_loginType = responseData[@"type"];
    user.user_smsStatus = responseData[@"sms_status"];
    return @[user];
    
}
- (NSArray *)parseMyRecsData:(NSArray *)responseData{
    
    NSMutableArray *recsArray = [NSMutableArray array];
    
    for (NSDictionary *dict in responseData)
    {
       // RecommendationModel *recModel = [[RecommendationModel alloc] init];
        
        GooglePlaceModel *googlePlaceModel = [[GooglePlaceModel alloc] init];
        googlePlaceModel.latitude = [dict[@"latitude"] floatValue];
        googlePlaceModel.longitude = [dict[@"longitude"] floatValue];
        googlePlaceModel.placeName = dict[@"name"];
        googlePlaceModel.placeID = dict[@"place_id"];
        googlePlaceModel.placeAddress = dict[@"address"];
        googlePlaceModel.category = [dict[@"category_id"] componentsSeparatedByString:@","]; ;
        googlePlaceModel.placePhoneNo = dict[@"international_phone"];
        googlePlaceModel.rec_recomended_users = dict[@"recommendation_count"];
        
      /*  recModel.rec_id = dict[@"recommedation_id"];
        recModel.rec_name = dict[@"name"];
        recModel.rec_address = dict[@"address"];
        recModel.rec_categories = dict[@"category_id"];
        recModel.rec_phoneno = dict[@"international_phone"];
        recModel.rec_place_id = dict[@"place_id"];
        recModel.rec_rating = dict[@"rating"];
        recModel.rec_recomended_users = dict[@"recommendation_count"];
        recModel.latitude = [dict[@"latitude"] floatValue];
        recModel.longitude = [dict[@"longitude"] floatValue];
        */
        CLLocation *startLocation = [[CLLocation alloc] initWithLatitude: (CLLocationDegrees)[[[NSUserDefaults standardUserDefaults] objectForKey:UserChosenLatitude] doubleValue] longitude:(CLLocationDegrees)[[[NSUserDefaults standardUserDefaults] objectForKey:UserChosenLongitude] doubleValue]];
        
        CLLocation *endLocation = [[CLLocation alloc] initWithLatitude:(CLLocationDegrees) googlePlaceModel.latitude  longitude:(CLLocationDegrees)  googlePlaceModel.longitude];
        CLLocationDistance distance = [startLocation distanceFromLocation:endLocation]; // aka double
     //   NSLog(@"distance %f",distance);
        googlePlaceModel.distanceInMeter = distance;
     //   NSLog(@"Calculated Miles %@ feet %f", [NSString stringWithFormat:@"%f",(distance/1609.344)],(distance*3.281));
        if (lroundf(distance*3.281) < 500) {
            googlePlaceModel.strDistance = [NSString stringWithFormat:@"%ld ft",lroundf(distance*3.281)];
        }else{
            googlePlaceModel.strDistance = [NSString stringWithFormat:@"%.1f mi",(distance/1609.344)];
        }
        
        [recsArray addObject:googlePlaceModel];
    }
    
    return recsArray;
}
- (NSArray *)parseSearchHistory:(NSArray *)responseData{
    NSMutableArray *searchResult = [NSMutableArray array];
    for (NSDictionary *dict in responseData)
    {
        GooglePlaceModel *place =[[GooglePlaceModel alloc] init];
        place.placeAddress = dict[@"search_query"];
        place.latitude = [dict[@"latitude"] floatValue];
        place.longitude = [dict[@"longitude"] floatValue];
        
        [searchResult addObject:place];
    }
    
    return searchResult;
}



@end
