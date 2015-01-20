//
//  WebServiceConstants.h
//  I_Like_My_Waitress
//
//  Created by Rahul V. Mane on 8/26/14.
//  Copyright (c) 2014 Perennial. All rights reserved.
//

#define WebServerErrorDomain @"WebServerErrorDomain"
#define JSONErrorDomain @"JSONErrorDomain"

#define WebServerErrorCode 3353
#define JSONErrorCode 1563
#define SessionExpiredCode 1019
#define ScheduleErrorCode 8087
#define ViewScheduleErrorCode 4009


//#define ServerURL @"http://192.168.1.186:81/rextile_php/index.php/"   //Local Server

#define ServerURL @"http://54.148.8.157/rex/index.php/"  //Live Server




#define SignUp @"signup/register"
#define SyncContact @"signup/sync/"
#define AddRecommendation @"recommendation"
#define RemoveRecommendation @"recommendation/deleteTryOrRec"
#define FetchRecommendation @"recommendation/viewRecommendations"
#define GetRecommendedPlaces @"recommendation/getPlaceRecommendations"
#define SaveSearch @"search/saveSearch"
#define FetchSearchHistory @"search/showSearchHistory"
#define GetRecommendationCount @""
#define ViewHomeCount @"recommendation/viewRecommendationCounts"



//USER Web Service Request Variable
#define UserEmail @"email_id"
#define UserPhone @"phone"
#define UserContacts @"contacts"

#define UserId @"user_id"
#define UserSessionId @"session_id"

#define PlaceName @"place_name"
#define PlaceId @"place_id"
#define Categories @"categories"
#define PlacePhotos @"photos"

#define PlaceLatitude @"latitude"
#define PlaceLongitude @"longitude"
#define PlaceRating @"rating"
#define PlaceAddress @"address"
#define PlaceRating @"rating"
#define PlacePhone @"international phone"


#define RecsType @"type"
#define SavedSearch @"search"
#define PlaceIds @"place_ids"

