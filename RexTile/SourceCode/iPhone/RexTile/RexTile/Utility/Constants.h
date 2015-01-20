//
//  Constants.h
//  RexTile
//
//  Created by Sweety Singh on 12/17/14.
//  Copyright (c) 2014 Perennial. All rights reserved.
//


#ifndef RexTile_Constants_h
#define RexTile_Constants_h
#endif

#import <UIKit/UIKit.h>


#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double) 568) < DBL_EPSILON)

#define UIColorFromRGB(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define TrimSting(a) [a stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]

#define GetImageByName(a) [UIImage imageNamed:a]

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#define Helvetica_RegularWithSize(a) [UIFont fontWithName:@"Helvetica Neue" size:a]

#define AlertTitle @"RexTile"

#define GOOGLE_API_KEY @"AIzaSyDjFlvVtWyv4DbVRPEP5DG4DF-ElD4uYXg"
#define GOOGLE_PLACE_TYPES @"accounting|airport|amusement_park|aquarium|art_gallery|atm|bakery|bank|bar|beauty_salon|bicycle_store|book_store|bowling_alley|bus_station|cafe|campground|car_dealer|car_rental|car_repair|car_wash|casino|cemetery|church|city_hall|clothing_store|convenience_store|courthouse|dentist|department_store|doctor|electrician|electronics_store|embassy|establishment|finance|fire_station|florist|food|funeral_home|furniture_store|gas_station|general_contractor|grocery_or_supermarket|gym|hair_care|hardware_store|health|hindu_temple|home_goods_store|hospital|insurance_agency|jewelry_store|laundry|lawyer|library|liquor_store|local_government_office|locksmith|lodging|meal_delivery|meal_takeaway|mosque|movie_rental|movie_theater|moving_company|museum|night_club|painter|park|parking|pet_store|pharmacy|physiotherapist|place_of_worship|plumber|police|post_office|real_estate_agency|restaurant|roofing_contractor|rv_park|school|shoe_store|shopping_mall|spa|stadium|storage|store|subway_station|synagogue|taxi_stand|train_station|travel_agency|university|veterinary_care|zoo"

//@"bar|food|casino|cafe|restaurant|shopping_mall|establishment"
#define Latitude @"Latitude"
#define Longitude @"Longitude"
#define Address @"Address"
#define UserLatitude @"UserLatitude"
#define UserLongitude @"UserLongitude"
#define UserCurrentAddress @"UserAddress"

#define UserChosenAddress @"UserChosenAddress"
#define UserChosenLatitude @"UserChosenLatitude"
#define UserChosenLongitude @"UserChosenLongitude"


/// USER MODEL

#define kUserName @"UserName"
#define kEmailId @"RegisteredEmailId"
#define kUserId @"RegisteredUserId"
#define kUserPhoneNumber @"UserPhoneNumber"
#define kSessionId @"SessionId"
#define kLoginType @"LoginType"
#define kSmsStatus @"SmsStatus"


// STORY BOARD CONSTANTS

#define LoginStoryboard @"MainStoryBoard"
#define RextileStoryboard @"RexStoryBoard"

#define TabBarController @"RexTabBarController"
#define SettingsView @"RexSettingsView"
#define CountryList @"CountryListView"
#define VerificationView @"VerficationViewController"
#define PlaceDetailView @"PlaceDetailView"
#define LocationOverlay @"RexLocationOverlayViewController"
#define MyFriendsRecs @"MyFriendsRecsViewController"
#define MyRecs @"MyRecsViewController"

