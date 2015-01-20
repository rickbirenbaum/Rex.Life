//
//  RecommendationModel.h
//  RexTile
//
//  Created by Sweety Singh on 1/1/15.
//  Copyright (c) 2015 Perennial. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecommendationModel : NSObject

@property (strong, nonatomic) NSString *rec_id;
@property (strong, nonatomic) NSString *rec_name;
@property (strong, nonatomic) NSString *rec_address;
@property (strong, nonatomic) NSString *rec_phoneno;
@property (strong, nonatomic) NSString *rec_place_id;
@property (strong, nonatomic) NSString  *rec_categories;
@property (strong, nonatomic) NSString *rec_rating;
@property (strong, nonatomic) NSString  *rec_recomended_users;
@property (readwrite, nonatomic) double latitude;
@property (readwrite, nonatomic) double longitude;
@property (readwrite, nonatomic) double distanceInMeter;
@property (readwrite, nonatomic) NSString *strDistance;

@end

