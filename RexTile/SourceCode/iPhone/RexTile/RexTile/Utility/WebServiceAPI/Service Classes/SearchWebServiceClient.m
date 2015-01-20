//
//  SearchWebServiceClient.m
//  RexTile
//
//  Created by Sweety Singh on 1/8/15.
//  Copyright (c) 2015 Perennial. All rights reserved.
//

#import "SearchWebServiceClient.h"
#import "RexParser.h"



@implementation SearchWebServiceClient

-(void)saveSearch:(GooglePlaceModel *)place{
    self.request = [[AsynchroniousRequest alloc] init];
    self.request.delegate = self;
    self.request.tag = 2;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ServerURL,SaveSearch]];
    
    
    
    NSMutableDictionary *requestbodyDict = [[NSMutableDictionary alloc] init];
    [requestbodyDict setObject:[[NSUserDefaults standardUserDefaults]valueForKey:kUserId] forKey:UserId];
    [requestbodyDict setObject:[[NSUserDefaults standardUserDefaults]valueForKey:kSessionId] forKey:UserSessionId];
    
    [requestbodyDict setObject:[NSNumber numberWithDouble:place.latitude] forKey:PlaceLatitude];
    [requestbodyDict setObject:[NSNumber numberWithDouble:place.longitude] forKey:PlaceLongitude];
     [requestbodyDict setObject:[NSObject isNull:place.placeAddress]?@"":place.placeAddress forKey:SavedSearch];
    [self.request requestURL:url withPOSTParameters:requestbodyDict file:nil];
}


-(void)fetchSearchHistory{
    self.request = [[AsynchroniousRequest alloc] init];
    self.request.delegate = self;
    self.request.tag = 1;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ServerURL,FetchSearchHistory]];

    
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
                    RexParser *parser = [[RexParser alloc] init];
                    NSArray *parsedData = [parser parseSearchHistory:[data objectForKey:@"data"]];
                    [self.delegate request:self didFinishWithResult:parsedData];
                    
                }
                    break;
                case 2:
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
