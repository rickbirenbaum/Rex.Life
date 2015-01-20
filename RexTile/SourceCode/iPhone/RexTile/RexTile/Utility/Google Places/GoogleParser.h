//
//  GoogleParser.h
//  RexTile
//
//  Created by Sweety Singh on 12/17/14.
//  Copyright (c) 2014 Perennial. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoogleParser : NSObject

- (NSArray *)parseGooglePlacesResponse:(NSArray *)response;
- (NSArray *)parseGeoCodeResponse:(NSArray *)response;
- (NSArray *)parsePlaceDetailResponse:(NSDictionary *)response;
- (NSArray *)parseGoogleTextSearchResponse:(NSArray *)response;
@end
