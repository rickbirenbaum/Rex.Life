//
//  UserWebServiceClient.m
//  RexTile
//
//  Created by Sweety Singh on 12/23/14.
//  Copyright (c) 2014 Perennial. All rights reserved.
//

#import "UserWebServiceClient.h"
#import "RexParser.h"


@implementation UserWebServiceClient


- (void)signInUserWithPhone:(NSString *)phoneNo email:(NSString *)emailId{
    self.request = [[AsynchroniousRequest alloc] init];
    self.request.delegate = self;
    self.request.tag = 1;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ServerURL,SignUp]];
    
    NSMutableDictionary *requestbodyDict = [[NSMutableDictionary alloc] init];
    [requestbodyDict setObject:[NSObject isNull:phoneNo]?@"":phoneNo forKey:UserPhone];
    [requestbodyDict setObject:[NSObject isNull:emailId]?@"":emailId forKey:UserEmail];
   
    [self.request requestURL:url withPOSTParameters:requestbodyDict file:nil];
}
- (void)syncUserContact:(NSMutableArray *)contacts{
    self.request = [[AsynchroniousRequest alloc] init];
    self.request.delegate = self;
    self.request.tag = 2;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ServerURL,SyncContact]];
    
    NSString * contactString = [contacts componentsJoinedByString:@","];
   
    NSMutableDictionary *requestbodyDict = [[NSMutableDictionary alloc] init];
    [requestbodyDict setObject:[[NSUserDefaults standardUserDefaults]valueForKey:kUserId] forKey:UserId];
    [requestbodyDict setObject:[[NSUserDefaults standardUserDefaults]valueForKey:kSessionId] forKey:UserSessionId];
    
    [requestbodyDict setObject:[NSObject isNull:contactString]?@"":contactString forKey:UserContacts];
   
    [self.request requestURL:url withPOSTParameters:requestbodyDict file:nil];
}


-(void)getRecommendationCountForPlaces:(NSArray *)placesArray{
    self.request = [[AsynchroniousRequest alloc] init];
    self.request.delegate = self;
    self.request.tag = 3;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ServerURL,GetRecommendationCount]];
    
    NSMutableDictionary *requestbodyDict = [[NSMutableDictionary alloc] init];
    [requestbodyDict setObject:[[NSUserDefaults standardUserDefaults]valueForKey:kUserId] forKey:UserId];
    [requestbodyDict setObject:[[NSUserDefaults standardUserDefaults]valueForKey:kSessionId] forKey:UserSessionId];
    
    NSString * placeIdString = [placesArray componentsJoinedByString:@","];
    
    [requestbodyDict setObject:placeIdString forKey:PlaceIds];
    
    [self.request requestURL:url withPOSTParameters:requestbodyDict file:nil];
}

- (void)getHomeRecsCount{
    self.request = [[AsynchroniousRequest alloc] init];
    self.request.delegate = self;
    self.request.tag = 4;
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
                    RexParser *parser = [[RexParser alloc] init];
                    NSArray *parsedData = [parser userWebClientSignInSignUpParser:data];
                    [self.delegate request:self didFinishWithResult:parsedData];
                }
                    break;
                case 2:
                {
                     [self.delegate request:self didFinishWithResult:nil];
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
