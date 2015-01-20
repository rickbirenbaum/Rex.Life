//
//  RexSettingsViewController.m
//  RexTile
//
//  Created by Sweety Singh on 12/19/14.
//  Copyright (c) 2014 Perennial. All rights reserved.
//

#import "RexSettingsViewController.h"
#import "RexTabBarController.h"
#import "Constants.h"

@interface RexSettingsViewController ()

@end

@implementation RexSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIImageView *bgImage = [[UIImageView alloc] init];
    bgImage.backgroundColor = UIColorFromRGB(58, 58, 58, 1);
    [self.navigationController.navigationBar setBackgroundImage:bgImage.image forBarMetrics:UIBarMetricsDefault];
    
   // [[UINavigationBar appearance] setBackgroundImage:bgImage.image forBarMetrics:UIBarMetricsDefault];

//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.navigationController.navigationBar setBackgroundColor:UIColorFromRGB(58, 58, 58, 1)];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)btnLogoutClicked:(id)sender {
    
    UserModel *user = [UserModel sharedInstance];
    [user resetSettings];
     [[NSUserDefaults standardUserDefaults] setValue:nil forKey:kUserId];
    [[NSUserDefaults standardUserDefaults] setObject:[[NSUserDefaults standardUserDefaults] objectForKey:UserLatitude] forKey:UserChosenLatitude];
    [[NSUserDefaults standardUserDefaults] setObject:[[NSUserDefaults standardUserDefaults] objectForKey:UserLongitude]forKey:UserChosenLongitude];
     [[NSUserDefaults standardUserDefaults] setObject:@" Current Location " forKey:UserChosenAddress];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    RexTabBarController *tabBar =(RexTabBarController *) self.tabBarController;
    [tabBar removeOnLogout];
}
- (IBAction)btnDoneClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:NO];
}

@end
