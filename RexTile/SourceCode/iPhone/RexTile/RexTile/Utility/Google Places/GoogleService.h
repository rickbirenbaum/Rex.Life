//
//  GoogleService.h
//  RexTile
//
//  Created by Sweety Singh on 12/17/14.
//  Copyright (c) 2014 Perennial. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GoogleServiceDelegate;

@interface GoogleService : NSObject<NSURLConnectionDelegate>{
    
    NSMutableDictionary *connectionId;
    NSMutableData *receivedData;
    NSURLRequest *request;
    id <GoogleServiceDelegate> delegate;
}
@property (nonatomic, assign) id <GoogleServiceDelegate> delegate;
@property (readwrite, nonatomic) NSInteger tag;


- (void)getNearByPlaces;
- (void)fetchPlaceDetail:(NSString *)placeId;
- (void)getPlacesForQuery:(NSString *)query;

@end



@protocol GoogleServiceDelegate <NSObject>

- (void)googleService:(GoogleService *)geoService didFinishWithResult:(NSArray *)result;
- (void)googleService:(GoogleService *)geoService didFailWithError:(NSError *)error;



@end
