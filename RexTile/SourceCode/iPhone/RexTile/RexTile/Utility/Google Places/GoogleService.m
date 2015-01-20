//
//  GoogleService.m
//  RexTile
//
//  Created by Sweety Singh on 12/17/14.
//  Copyright (c) 2014 Perennial. All rights reserved.
//

#import "GoogleService.h"
#import "Constants.h"

#import "GoogleParser.h"

@implementation GoogleService


- (void)getNearByPlaces{
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=%d&types=%@&rankBy=distance&sensor=true&key=%@", [[[NSUserDefaults standardUserDefaults] objectForKey:UserChosenLatitude] floatValue], [[[NSUserDefaults standardUserDefaults] objectForKey:UserChosenLongitude] floatValue], 500, GOOGLE_PLACE_TYPES, GOOGLE_API_KEY];
   
//    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&rankBy=distance&types=%@&rankBy=distance&sensor=true&key=%@", [[[NSUserDefaults standardUserDefaults] objectForKey:UserLatitude] floatValue], [[[NSUserDefaults standardUserDefaults] objectForKey:UserLongitude] floatValue], GOOGLE_PLACE_TYPES, GOOGLE_API_KEY];
  
    //build request URL
    NSURL *requestURL = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //build NSURLRequest
    request=[NSURLRequest requestWithURL:requestURL
                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                         timeoutInterval:60.0];
    
    
    //create connection and start downloading data
    NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    // Append Stuffs
    
    connectionId = [[NSMutableDictionary alloc] init];
    
    NSNumber *connectionKey = [NSNumber numberWithUnsignedLong:(unsigned long)request.hash];
    
    [connectionId setObject:@"SearchPlace" forKey:connectionKey];
    
    
    
    if(connection){
        //connection valid, so init data holder
        receivedData = [NSMutableData data];
    }else{
        //connection failed, tell delegate
        NSError *error = [NSError errorWithDomain:@"Places Error" code:5 userInfo:nil];
        if (self.delegate) {
            [self.delegate googleService:self didFailWithError:error];
        }
    }
    
}
- (void)getPlacesForQuery:(NSString *)query{
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?location=%f,%f&radius=%d&rankBy=distance&query=%@&sensor=true&key=%@", [[[NSUserDefaults standardUserDefaults] objectForKey:UserChosenLatitude] floatValue], [[[NSUserDefaults standardUserDefaults] objectForKey:UserChosenLongitude] floatValue], 500,query, GOOGLE_API_KEY];
    
    //build request URL
    NSURL *requestURL = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //build NSURLRequest
    request=[NSURLRequest requestWithURL:requestURL
                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                         timeoutInterval:60.0];
    
    
    //create connection and start downloading data
    NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    // Append Stuffs
    
    connectionId = [[NSMutableDictionary alloc] init];
    
    NSNumber *connectionKey = [NSNumber numberWithUnsignedLong:(unsigned long)request.hash];
    
    [connectionId setObject:@"SearchPlaceText" forKey:connectionKey];
    
    if(connection){
        //connection valid, so init data holder
        receivedData = [NSMutableData data];
    }else{
        //connection failed, tell delegate
        NSError *error = [NSError errorWithDomain:@"Places Error" code:5 userInfo:nil];
        if (self.delegate) {
            [self.delegate googleService:self didFailWithError:error];
        }
    }

}
- (void)fetchPlaceDetail:(NSString *)placeId{
    
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?placeid=%@&key=%@",placeId,GOOGLE_API_KEY];

    
    //build request URL
    NSURL *requestURL = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //build NSURLRequest
    request=[NSURLRequest requestWithURL:requestURL
                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                         timeoutInterval:60.0];
    
    
    //create connection and start downloading data
    NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    // Append Stuffs
    
    connectionId = [[NSMutableDictionary alloc] init];
    
    NSNumber *connectionKey = [NSNumber numberWithUnsignedLong:(unsigned long)request.hash];
    
    [connectionId setObject:@"PlaceDetail" forKey:connectionKey];
    
    
    
    if(connection){
        //connection valid, so init data holder
        receivedData = [NSMutableData data];
    }else{
        //connection failed, tell delegate
        NSError *error = [NSError errorWithDomain:@"Places detail Error" code:5 userInfo:nil];
        if (self.delegate) {
            [self.delegate googleService:self didFailWithError:error];
        }
    }

}





/*
 *  Reset data when a new response is received
 */
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [receivedData setLength:0];
}


/*
 *  Append received data
 */
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    if (self.delegate) {
        [self.delegate googleService:self didFailWithError:error];
    }
}

/*
 *  Called when done downloading response from Google. Builds a table of AddressComponents objects
 *	and tells the delegate that it was successful or informs the delegate of a failure.
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSNumber *connectionKey = [NSNumber numberWithUnsignedLong:(unsigned long)request.hash];
    
    NSString *requestkey = [connectionId objectForKey:connectionKey];
  //  NSLog(@"requestkey %@ connectionKey %@",requestkey,connectionKey);
    
    
    NSError *error = nil;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingMutableContainers error:&error];
    if(!error)
    {
        if([[json valueForKey:@"status"] isEqualToString:@"OK"])
        {
           
            
            if ([requestkey isEqualToString:@"SearchPlace"]) {
                 NSArray *data=[json valueForKey:@"results"];
                GoogleParser *parser = [[GoogleParser alloc] init];
                NSArray *parsedData = [parser parseGooglePlacesResponse:data];
                [self.delegate googleService:self didFinishWithResult:parsedData];
                
            }else if ([requestkey isEqualToString:@"GeoCode"]) {
                 NSArray *data=[json valueForKey:@"results"];
                GoogleParser *parser = [[GoogleParser alloc] init];
                NSArray *parsedData = [parser parseGeoCodeResponse:data];
                [self.delegate  googleService:self didFinishWithResult:parsedData];
            
            }else if ([requestkey isEqualToString:@"PlaceDetail"]) {
                NSDictionary *data=[json valueForKey:@"result"];
                GoogleParser *parser = [[GoogleParser alloc] init];
                NSArray *parsedData = [parser parsePlaceDetailResponse:data];
                [self.delegate  googleService:self didFinishWithResult:parsedData];
            }else if ([requestkey isEqualToString:@"SearchPlaceText"]) {
                NSArray *data=[json valueForKey:@"results"];
                GoogleParser *parser = [[GoogleParser alloc] init];
                NSArray *parsedData = [parser parseGoogleTextSearchResponse:data];
                [self.delegate googleService:self didFinishWithResult:parsedData];
                
            }
            
        }else{
            
                if([[json valueForKey:@"status"] isEqualToString:@"ZERO_RESULTS"])
                {
                    error = [NSError errorWithDomain:@"GeocoderError" code:1 userInfo:nil];
                }
                else if([[json valueForKey:@"status"] isEqualToString:@"OVER_QUERY_LIMIT"])
                {
                    error = [NSError errorWithDomain:@"GeocoderError" code:2 userInfo:nil];
                }
                else if([[json valueForKey:@"status"] isEqualToString:@"REQUEST_DENIED"])
                {
                    error = [NSError errorWithDomain:@"GeocoderError" code:3 userInfo:nil];
                }
                else if([[json valueForKey:@"status"] isEqualToString:@"INVALID_REQUEST"])
                {
                    error = [NSError errorWithDomain:@"GeocoderError" code:4 userInfo:nil];
                }
                if (self.delegate) {
                    [self.delegate googleService:self didFailWithError:error];
                }

    }
    }else{
        [self.delegate googleService:self didFailWithError:error];
    }
}

@end
