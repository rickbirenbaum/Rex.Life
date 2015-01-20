//
//  UserWebServiceClient.h
//  RexTile
//
//  Created by Sweety Singh on 12/23/14.
//  Copyright (c) 2014 Perennial. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebServiceDelegate.h"
#import "AsynchroniousRequest.h"
#import "WebServiceConstants.h"


@interface UserWebServiceClient : NSObject<AsynchroniousRequestDelegate>
@property (strong, nonatomic) AsynchroniousRequest *request;
@property (nonatomic,readwrite) NSInteger tag;
@property (weak, nonatomic) id <WebServiceDelegate> delegate;

@property (strong, nonatomic) ASIFormDataRequest *requestform;


- (void)signInUserWithPhone:(NSString *)phoneNo email:(NSString *)emailId;
- (void)syncUserContact:(NSArray *)contacts;

- (void)getRecommendationCountForPlaces:(NSArray *)placesArray;
- (void)getHomeRecsCount;
@end
