//
//  AsynchroniousRequest.m
//  I_Like_My_Waitress
//
//  Created by Rahul V. Mane on 8/25/14.
//  Copyright (c) 2014 Perennial. All rights reserved.
//

#import "AsynchroniousRequest.h"
#import "WebServiceConstants.h"

static const NSTimeInterval kTimeout = 25;

@implementation AsynchroniousRequest

- (void)requestURL:(NSURL *)url withPOSTParameters:(NSData *)params
{
    self.request = [[ASIHTTPRequest alloc] initWithURL:url];
    [self.request appendPostData:params];
    [self.request setRequestMethod:@"POST"];
    [self.request setDelegate:self];
    [self.request setTimeOutSeconds:kTimeout];
    [self.request addRequestHeader:@"Content-Type" value:@"application/json"];
    [self.request setDidFailSelector:@selector(requestFinishedWithError:)];
    [self.request setDidFinishSelector:@selector(requestFinishedSuccessfully:)];
    
    [self.request startAsynchronous];
}

- (void)requestURL:(NSURL *)url withPOSTParameters:(NSDictionary *)params file:(NSData *)file
{
//    NSError *error = nil;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
//    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    self.multipartRequest = [ASIFormDataRequest requestWithURL:url];
    NSArray *keys = [params allKeys];
    for (NSString *key in keys)
    {
        [self.multipartRequest setPostValue:[params valueForKey:key] forKey:key];
    }
    
    if (file)
    {
        [self.multipartRequest  setData:file withFileName:@"myImage.jpg" andContentType:@"application/octet-stream" forKey:@"profile_pic_url"];
    }
    
    [self.multipartRequest setDidFailSelector:@selector(requestFinishedWithError:)];
    [self.multipartRequest setDidFinishSelector:@selector(requestFinishedSuccessfully:)];
    [self.multipartRequest setShouldContinueWhenAppEntersBackground:YES];
    [self.multipartRequest setDelegate:self];
    [self.multipartRequest addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    [self.multipartRequest setTimeOutSeconds:kTimeout];
    [self.multipartRequest startAsynchronous];
}

-(void)requestFinishedWithError:(ASIHTTPRequest *)theRequest
{
   // NSLog(@"Request failed.");
    NSError *error = [theRequest error];
    [self.delegate request:self didFailWithError:error];
}

-(void)requestFinishedSuccessfully:(ASIHTTPRequest *)theRequest
{
    //NSLog(@"Request successful.");
   // NSLog(@" responseString %@",[theRequest responseString]);
    NSData *responseData = [theRequest responseData];
    [self.delegate request:self didFinishWithResponse:responseData];
}

- (void)cancelRequest
{
   // NSLog(@"Request cancelled from asynch request");
    if (self.request) {
        [self.request cancel];
        self.request = nil;
        [self.request setDidFinishSelector:NULL];
        [self.request setDidFailSelector:NULL];
        self.request.delegate = nil;
        self.request = nil;
    }
    
    if (self.multipartRequest) {
        [self.multipartRequest cancel];
        [self.multipartRequest setDidFinishSelector:NULL];
        [self.multipartRequest setDidFailSelector:NULL];
        self.multipartRequest.delegate = nil;
        self.multipartRequest = nil;
    }
}

@end
