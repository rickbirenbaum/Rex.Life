//
//  RecommendationListWebServices.h
//  RexTile
//
//  Created by Sweety Singh on 1/1/15.
//  Copyright (c) 2015 Perennial. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebServiceDelegate.h"
#import "AsynchroniousRequest.h"
#import "WebServiceConstants.h"

#import "GooglePlaceModel.h"

@interface RecommendationListWebServices : NSObject<AsynchroniousRequestDelegate>
@property (strong, nonatomic) AsynchroniousRequest *request;
@property (nonatomic,readwrite) NSInteger tag;
@property (weak, nonatomic) id <WebServiceDelegate> delegate;

@property (strong, nonatomic) ASIFormDataRequest *requestform;


-(void)addRecommendation:(GooglePlaceModel *)placeModel;
-(void)removeRecommendation:(NSString *)placeId;
-(void)addTryList:(GooglePlaceModel *)placeModel;
-(void)removeTryList:(NSString *)placeId;

-(void)getMyRecs;
-(void)getMyFriendsRecs;
-(void)getRecommendationStatus:(NSArray *)placeIdArray;

- (void)getHomeRecsCount;
@end
