//
//  AppDelegate.m
//  RexTile
//
//  Created by Sweety Singh on 12/17/14.
//  Copyright (c) 2014 Perennial. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import "Constants.h"
#import "UserModel.h"
#import "RexTabBarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

{
    UIAlertView *locationAlert;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //Instantiate a location object.
    self.locationManager = [[CoreLocationController alloc] init];
     //Make this controller the delegate for the location manager.
    self.locationManager.delegate = self;
    //[locationManager.locMgr startMonitoringSignificantLocationChanges];
    
    UserModel *user = [UserModel sharedInstance];
    if(user.user_userId)
    {
        [self pushTabBarController];
    }
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    {
        // This is the first launch ever
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] setObject:@" Current Location " forKey:UserChosenAddress];
        
//        [[NSUserDefaults standardUserDefaults] setObject:[[NSUserDefaults standardUserDefaults] objectForKey:UserLatitude] forKey:UserChosenLatitude];
//        [[NSUserDefaults standardUserDefaults] setObject:[[NSUserDefaults standardUserDefaults] objectForKey:UserLongitude] forKey:UserChosenLongitude];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)pushTabBarController
{
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:RextileStoryboard bundle:nil];
        
    RexTabBarController *tabBarController = (RexTabBarController *)[storyBoard instantiateViewControllerWithIdentifier:TabBarController];
    
    UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
    [navController pushViewController:tabBarController animated:NO];
    
    
}

#pragma mark - Location Service Delegates

/*
 CORE LOCATION DELEGATE METHODS, CALLED WHEN WE GET ANY UPDATED IN CHANGE OF LOCATION
 OR ANY ERROR.
 */
- (void)locationUpdate:(CLLocation *)location
{
    NSMutableDictionary *currentLocation = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",location.coordinate.latitude], Latitude, [NSString stringWithFormat:@"%f",location.coordinate.longitude], Longitude, nil];
    
    NSString  *currentLocationAddress=[self getAddressFromLatLong:[NSString stringWithFormat:@"%f,%f",location.coordinate.latitude,location.coordinate.longitude]];
    [currentLocation setValue:currentLocationAddress forKey:Address];
    
    [self.locationManager.locMgr stopUpdatingLocation];
    self.locationManager.delegate = nil;
    [self addLocationToUserModel:currentLocation];
}

- (void)locationError:(NSError *)error
{
    if (!locationAlert) {
        locationAlert = [[UIAlertView alloc] initWithTitle:AlertTitle message:@"You have not enabled location services. Please enable. Still want to continue?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"Yes", nil];
        [locationAlert show];
    }
    
    
}

-(void)addLocationToUserModel:(NSDictionary *)location
{
    /*
     THIS ADDS LATITUDE AND LONGITUDE TO USER MODEL
     */
        
    [[NSUserDefaults standardUserDefaults] setObject:[location valueForKey:Latitude] forKey:UserLatitude];
    [[NSUserDefaults standardUserDefaults] setObject:[location valueForKey:Longitude] forKey:UserLongitude];
    [[NSUserDefaults standardUserDefaults] setObject:[location valueForKey:Address] forKey:UserCurrentAddress];
   
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UserChosenLatitude] == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:[location valueForKey:Latitude] forKey:UserChosenLatitude];
        [[NSUserDefaults standardUserDefaults] setObject:[location valueForKey:Longitude] forKey:UserChosenLongitude];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
}


#pragma mark- UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex)
    {
        case 0:
            //   NSLog(@"Username %@",[alertView textFieldAtIndex:0].text);
        {
            NSDictionary *currentLocation = [NSDictionary dictionaryWithObjectsAndKeys:@"73.000000", Latitude, @"18.000000", Longitude, nil];
            [self addLocationToUserModel:currentLocation];
            locationAlert = nil;
        }
            
            break;
            
        case 1:/// Submit the email address to server
            //   NSLog(@"validated Username %@",[alertView textFieldAtIndex:0].text);
        {
            NSDictionary *currentLocation = [NSDictionary dictionaryWithObjectsAndKeys:@"73.000000", Latitude, @"18.000000", Longitude, nil];
            [self addLocationToUserModel:currentLocation];
            locationAlert = nil;
            
        }
            break;
            
        default:
            break;
    }
    
}


-(NSString*)getAddressFromLatLong : (NSString *)latLng {
    //  NSString *string = [[Address.text stringByAppendingFormat:@"+%@",cityTxt.text] stringByAppendingFormat:@"+%@",addressText];
    NSString *esc_addr =  [latLng stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    
    if(result.length==0){
        return nil;
    }
    
    NSMutableDictionary *data = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding]options:NSJSONReadingMutableContainers error:nil];
    NSMutableArray *dataArray = (NSMutableArray *)[data valueForKey:@"results" ];
    if (dataArray.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Enter a valid address" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        for (id firstTime in dataArray) {
            NSString *jsonStr1 = [firstTime valueForKey:@"formatted_address"];
            return jsonStr1;
        }
    }
    
    return nil;
}
@end
