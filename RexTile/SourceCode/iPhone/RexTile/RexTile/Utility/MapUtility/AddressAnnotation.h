//
//  AddressAnnotation.h
//  FridgeApp
//
//  Created by Zoolook_MacBook on 20/01/11.
//  Copyright 2011 Zoolook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>

@interface AddressAnnotation : NSObject<MKAnnotation> {
	CLLocationCoordinate2D coordinate;
	NSString *title;
    NSString *subtitle;
    int index;

}
@property (nonatomic, assign,readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *subtitle;
@property (nonatomic)int index;

-(id)initWithCoordinate:(CLLocationCoordinate2D) c;
@end