//
//  RecommendationListWebServices.m
//  RexTile
//
//  Created by Sweety Singh on 1/1/15.
//  Copyright (c) 2015 Perennial. All rights reserved.
//

#import "RecommendationListWebServices.h"
#import "RexParser.h"


@implementation RecommendationListWebServices

-(void)addRecommendation:(GooglePlaceModel *)placeModel{
    
    self.request = [[AsynchroniousRequest alloc] init];
    self.request.delegate = self;
    self.request.tag = 1;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ServerURL,AddRecommendation]];
    
    NSMutableDictionary *requestbodyDict = [[NSMutableDictionary alloc] init];
    [requestbodyDict setObject:[[NSUserDefaults standardUserDefaults]valueForKey:kUserId] forKey:UserId];
    [requestbodyDict setObject:[[NSUserDefaults standardUserDefaults]valueForKey:kSessionId] forKey:UserSessionId];
    
    [requestbodyDict setObject:[NSObject isNull:placeModel.placeName]?@"":placeModel.placeName forKey:PlaceName];
    [requestbodyDict setObject:[NSObject isNull:placeModel.placeID]?@"":placeModel.placeID forKey:PlaceId];
    [requestbodyDict setObject:[NSNumber numberWithDouble:placeModel.longitude] forKey:PlaceLongitude];
    [requestbodyDict setObject:[NSNumber numberWithDouble:placeModel.latitude] forKey:PlaceLatitude];
    [requestbodyDict setObject:[NSObject isNull:placeModel.placeRating]?@"":placeModel.placeRating forKey:PlaceRating];
    
    [requestbodyDict setObject:[NSObject isNull:placeModel.placeAddress]?@"":placeModel.placeAddress forKey:PlaceAddress];
    [requestbodyDict setObject:[NSObject isNull:placeModel.placePhoneNo]?@"":placeModel.placePhoneNo forKey:PlacePhone];
    
     NSString * categoryString = [placeModel.category componentsJoinedByString:@","];
     [requestbodyDict setObject:[NSObject isNull:categoryString]?@"":categoryString forKey:Categories];
    
     NSString * photosString = [placeModel.photoArray componentsJoinedByString:@","];
     [requestbodyDict setObject:[NSObject isNull:photosString]?@"":photosString forKey:PlacePhotos];


    
    [self.request requestURL:url withPOSTParameters:requestbodyDict file:nil];
}

-(void)removeRecommendation:(NSString *)placeId{
    self.request = [[AsynchroniousRequest alloc] init];
    self.request.delegate = self;
    self.request.tag = 2;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ServerURL,RemoveRecommendation]];
    
    NSMutableDictionary *requestbodyDict = [[NSMutableDictionary alloc] init];
    [requestbodyDict setObject:[[NSUserDefaults standardUserDefaults]valueForKey:kUserId] forKey:UserId];
    [requestbodyDict setObject:[[NSUserDefaults standardUserDefaults]valueForKey:kSessionId] forKey:UserSessionId];
    
    [requestbodyDict setObject:[NSObject isNull:placeId]?@"":placeId forKey:PlaceId];
    
    [self.request requestURL:url withPOSTParameters:requestbodyDict file:nil];
    
    
}
-(void)addTryList:(GooglePlaceModel *)placeModel{
    self.request = [[AsynchroniousRequest alloc] init];
    self.request.delegate = self;
    self.request.tag = 3;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ServerURL,AddRecommendation]];
    
    NSMutableDictionary *requestbodyDict = [[NSMutableDictionary alloc] init];
    [requestbodyDict setObject:[[NSUserDefaults standardUserDefaults]valueForKey:kUserId] forKey:UserId];
    [requestbodyDict setObject:[[NSUserDefaults standardUserDefaults]valueForKey:kSessionId] forKey:UserSessionId];
    
    [requestbodyDict setObject:[NSObject isNull:placeModel.placeName]?@"":placeModel.placeName forKey:PlaceName];
    [requestbodyDict setObject:[NSObject isNull:placeModel.placeID]?@"":placeModel.placeID forKey:PlaceId];
    [requestbodyDict setObject:[NSNumber numberWithDouble:placeModel.longitude] forKey:PlaceLongitude];
    [requestbodyDict setObject:[NSNumber numberWithDouble:placeModel.latitude] forKey:PlaceLatitude];
    [requestbodyDict setObject:[NSObject isNull:placeModel.placeRating]?@"":placeModel.placeRating forKey:PlaceRating];
    
    [requestbodyDict setObject:[NSObject isNull:placeModel.placeAddress]?@"":placeModel.placeAddress forKey:PlaceAddress];
    [requestbodyDict setObject:[NSObject isNull:placeModel.placePhoneNo]?@"":placeModel.placePhoneNo forKey:PlacePhone];
    
    NSString * categoryString = [placeModel.category componentsJoinedByString:@","];
    [requestbodyDict setObject:[NSObject isNull:categoryString]?@"":categoryString forKey:Categories];
    
    NSString * photosString = [placeModel.photoArray componentsJoinedByString:@","];
    [requestbodyDict setObject:[NSObject isNull:photosString]?@"":photosString forKey:PlacePhotos];
    
    
    
    [self.request requestURL:url withPOSTParameters:requestbodyDict file:nil];
}
-(void)removeTryList:(NSString *)placeId{
    self.request = [[AsynchroniousRequest alloc] init];
    self.request.delegate = self;
    self.request.tag = 4;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ServerURL,RemoveRecommendation]];
    
    NSMutableDictionary *requestbodyDict = [[NSMutableDictionary alloc] init];
    [requestbodyDict setObject:[[NSUserDefaults standardUserDefaults]valueForKey:kUserId] forKey:UserId];
    [requestbodyDict setObject:[[NSUserDefaults standardUserDefaults]valueForKey:kSessionId] forKey:UserSessionId];
    
    [requestbodyDict setObject:[NSObject isNull:placeId]?@"":placeId forKey:PlaceId];
    
    [self.request requestURL:url withPOSTParameters:requestbodyDict file:nil];
}


-(void)getMyRecs{
   
    self.request = [[AsynchroniousRequest alloc] init];
    self.request.delegate = self;
    self.request.tag = 5;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ServerURL,FetchRecommendation]];
    
    NSMutableDictionary *requestbodyDict = [[NSMutableDictionary alloc] init];
    [requestbodyDict setObject:[[NSUserDefaults standardUserDefaults]valueForKey:kUserId] forKey:UserId];
    [requestbodyDict setObject:[[NSUserDefaults standardUserDefaults]valueForKey:kSessionId] forKey:UserSessionId];
    
    [requestbodyDict setObject:[NSNumber numberWithInt:1] forKey:RecsType];
    
    [self.request requestURL:url withPOSTParameters:requestbodyDict file:nil];
}

-(void)getMyFriendsRecs
{
    self.request = [[AsynchroniousRequest alloc] init];
    self.request.delegate = self;
    self.request.tag = 6;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ServerURL,FetchRecommendation]];
    
    NSMutableDictionary *requestbodyDict = [[NSMutableDictionary alloc] init];
    [requestbodyDict setObject:[[NSUserDefaults standardUserDefaults]valueForKey:kUserId] forKey:UserId];
    [requestbodyDict setObject:[[NSUserDefaults standardUserDefaults]valueForKey:kSessionId] forKey:UserSessionId];
    
    [requestbodyDict setObject:[NSNumber numberWithInt:0] forKey:RecsType];
    
    [self.request requestURL:url withPOSTParameters:requestbodyDict file:nil];

}

-(void)getRecommendationStatus:(NSArray *)placeIdArray{
    self.request = [[AsynchroniousRequest alloc] init];
    self.request.delegate = self;
    self.request.tag = 7;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ServerURL,GetRecommendedPlaces]];
    
    NSMutableDictionary *requestbodyDict = [[NSMutableDictionary alloc] init];
    [requestbodyDict setObject:[[NSUserDefaults standardUserDefaults]valueForKey:kUserId] forKey:UserId];
    [requestbodyDict setObject:[[NSUserDefaults standardUserDefaults]valueForKey:kSessionId] forKey:UserSessionId];
    
    NSString * placeIdString = [placeIdArray componentsJoinedByString:@","];
    
    [requestbodyDict setObject:placeIdString forKey:PlaceIds];
    
    [self.request requestURL:url withPOSTParameters:requestbodyDict file:nil];
}


- (void)getHomeRecsCount{
    self.request = [[AsynchroniousRequest alloc] init];
    self.request.delegate = self;
    self.request.tag = 8;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ServerURL,ViewHomeCount]];
    
    NSMutableDictionary *requestbodyDict = [[NSMutableDictionary alloc] init];
    [requestbodyDict setObject:[[NSUserDefaults standardUserDefaults]valueForKey:kUserId] forKey:UserId];
    [requestbodyDict setObject:[[NSUserDefaults standardUserDefaults]valueForKey:kSessionId] forKey:UserSessionId];
    
    [self.request requestURL:url withPOSTParameters:requestbodyDict file:nil];
    
}


#pragma mark - Web service delegates

- (void)request:(AsynchroniousRequest *)asynchroniousRequest didFinishWithResponse:(NSData *)responseData
{
    NSError *error = nil;
    
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
    
    NSLog(@"json %@ %@",json,error);
    if(!error)
    {
        if([[json valueForKey:@"status"] isEqualToString:@"Success"])
        {
            NSDictionary *data=[json valueForKey:@"data"];
            switch (asynchroniousRequest.tag)
            {
                case 1:
                {
                    [self.delegate request:self didFinishWithResult:@[data]];
                }
                     break;
                case 2:
                {
                    [self.delegate request:self didFinishWithResult:@[data]];
                }
                     break;
                case 3:
                {
                    
                    [self.delegate request:self didFinishWithResult:@[data]];
                }
                    break;
                case 4:
                {
                    [self.delegate request:self didFinishWithResult:@[data]];
                }
                    break;
                case 5:
                {
                    
                    RexParser *parser = [[RexParser alloc] init];
                    NSArray *parsedData = [parser parseMyRecsData:[data objectForKey:@"recs"]];
                    [self.delegate request:self didFinishWithResult:parsedData];
                }
                    break;
                case 6:
                {
                    RexParser *parser = [[RexParser alloc] init];
                    NSArray *parsedData = [parser parseMyRecsData:[data objectForKey:@"recs"]];
                    [self.delegate request:self didFinishWithResult:parsedData];
                }
                    break;
                case 7:
                {
                    [self.delegate request:self didFinishWithResult:@[data]];
                }
                    break;
                case 8:
                {
                    [self.delegate request:self didFinishWithResult:@[data]];
                }
                    break;
                default:
                    break;
            }
        }
        else
        {
            NSDictionary *errorDict=[json valueForKey:@"error"];
            
            if ([errorDict[@"errorCode"] intValue] == 1019)
            {
                // session expired
                NSDictionary *userInfo = @{NSLocalizedDescriptionKey : [errorDict valueForKey:@"errormsg"]};
                error = [NSError errorWithDomain:WebServerErrorDomain code:SessionExpiredCode userInfo:userInfo];
                [self.delegate request:self didFailWithError:error];
            }
            else
            {
                NSDictionary *userInfo = @{NSLocalizedDescriptionKey : [errorDict valueForKey:@"errormsg"]};
                
                error = [NSError errorWithDomain:WebServerErrorDomain code:WebServerErrorCode userInfo:userInfo];
                [self.delegate request:self didFailWithError:error];
            }
        }
    }
    else
    {
        [self.delegate request:self didFailWithError:error];
    }
}

- (void)request:(AsynchroniousRequest *)asynchroniousRequest didFailWithError:(NSError *)error
{
    [self.delegate request:self didFailWithError:error];
}

#pragma mark - Cancel Request

- (void)cancelRequest:(id)sender
{
    // NSLog(@"Request cancelled");
    [self.request cancelRequest];
}



@end
