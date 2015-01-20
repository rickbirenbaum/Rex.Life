//
//  AppDelegate.h
//  RexTile
//
//  Created by Sweety Singh on 12/17/14.
//  Copyright (c) 2014 Perennial. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreLocationController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,CoreLocationControllerDelegate>
{
    
}
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) CoreLocationController *locationManager;
@end

