//
//  AsynchroniousRequest.h
//  I_Like_My_Waitress
//
//  Created by Rahul V. Mane on 8/25/14.
//  Copyright (c) 2014 Perennial. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@class AsynchroniousRequest;

@protocol AsynchroniousRequestDelegate <NSObject>

@required
- (void)request:(AsynchroniousRequest *)asynchroniousRequest didFinishWithResponse:(NSData *)responseData;

- (void)request:(AsynchroniousRequest *)asynchroniousRequest didFailWithError:(NSError *)error;

@end

@interface AsynchroniousRequest : NSObject

@property (readwrite, nonatomic) NSInteger tag;

@property (strong, nonatomic) ASIHTTPRequest *request;
@property (strong, nonatomic) ASIFormDataRequest *multipartRequest;

@property (weak, nonatomic) id <AsynchroniousRequestDelegate> delegate;

- (void)requestURL:(NSURL *)url withPOSTParameters:(NSDictionary *)params file:(NSData *)file;
- (void)requestURL:(NSURL *)url withPOSTParameters:(NSData *)params;

- (void)cancelRequest;

@end

