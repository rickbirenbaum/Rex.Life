//
//  SearchWebServiceClient.h
//  RexTile
//
//  Created by Sweety Singh on 1/8/15.
//  Copyright (c) 2015 Perennial. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebServiceDelegate.h"
#import "AsynchroniousRequest.h"
#import "WebServiceConstants.h"
#import "GooglePlaceModel.h"

@interface SearchWebServiceClient : NSObject<AsynchroniousRequestDelegate>
@property (strong, nonatomic) AsynchroniousRequest *request;
@property (nonatomic,readwrite) NSInteger tag;
@property (weak, nonatomic) id <WebServiceDelegate> delegate;

@property (strong, nonatomic) ASIFormDataRequest *requestform;


-(void)saveSearch:(GooglePlaceModel *)place;
-(void)fetchSearchHistory;
@end
