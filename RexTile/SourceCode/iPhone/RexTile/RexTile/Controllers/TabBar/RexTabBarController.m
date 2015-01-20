//
//  TabBarController.m
//  RexTile
//
//  Created by Sweety Singh on 12/18/14.
//  Copyright (c) 2014 Perennial. All rights reserved.
//

#import "RexTabBarController.h"
#import "Constants.h"
#import "DCPathButton.h"
#import "RexMyRecsViewController.h"
#import "RexMyFriendsRecsViewController.h"

@interface RexTabBarController ()<DCPathButtonDelegate>

@end

@implementation RexTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
     self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    [self ConfigureDCPathButton];
    
  //  [[UITabBar appearance] setBarTintColor:UIColorFromRGB(58, 58, 58, 1)];
   
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"tab_bar.png"]];
    UITabBarItem *home_item = [self.tabBar.items objectAtIndex:0];
    home_item.tag = 1;
    home_item.image = [[UIImage imageNamed:@"tab_home.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
   
    UITabBarItem *search_item = [self.tabBar.items objectAtIndex:2];
    search_item.image = [[UIImage imageNamed:@"tab_search.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    search_item.tag = 3;
    


    self.tabBar.tintColor = [UIColor whiteColor];
   
  //  self.tabBar.backgroundImage = [UIImage imageNamed:@"status_bar.png"];

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

-(void)removeOnLogout{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - DCPathButton

- (void)ConfigureDCPathButton
{
    // Configure center button
    //
    DCPathButton *dcPathButton = [[DCPathButton alloc]initWithCenterImage:[UIImage imageNamed:@"plus"]
                                                           hilightedImage:[UIImage imageNamed:@"plus"]];
    dcPathButton.delegate = self;
    
    //self.tabBarController.tabBarItem =[[UITabBarItem alloc] initWithTitle:@"" image:dcPathButton selectedImage:dcPathButton]; //dcPathButton;
    
    // Configure item buttons
    //
    DCPathItemButton *itemButton_1 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"rec"]
                                                           highlightedImage:[UIImage imageNamed:@"rec"]
                                                            backgroundImage:[UIImage imageNamed:@"rec"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"rec"]];
    
    DCPathItemButton *itemButton_2 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"try"]
                                                           highlightedImage:[UIImage imageNamed:@"try"]
                                                            backgroundImage:[UIImage imageNamed:@"try"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"try"]];
    
    DCPathItemButton *itemButton_3 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"add-a"]
                                                           highlightedImage:[UIImage imageNamed:@"add-a"]
                                                            backgroundImage:[UIImage imageNamed:@"add-a"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"add-a"]];
    
    
    DCPathItemButton *itemButton_4 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"contact1"]
                                                           highlightedImage:[UIImage imageNamed:@"contact1"]
                                                            backgroundImage:[UIImage imageNamed:@"contact1"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"contact1"]];
    
    DCPathItemButton *itemButton_5 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"friend"]
                                                           highlightedImage:[UIImage imageNamed:@"friend"]
                                                            backgroundImage:[UIImage imageNamed:@"friend"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"friend"]];
    // Add the item button into the center button
    //
    [dcPathButton addPathItems:@[itemButton_1, itemButton_2, itemButton_3, itemButton_4, itemButton_5]];
    
    // Change the bloom radius
    //
    dcPathButton.bloomRadius = 100.0f;
    
    // Change the DCButton's center
    //
    
    dcPathButton.dcButtonCenter = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height-25);
   
    
    [self.view addSubview:dcPathButton];
    
}


#pragma mark - DCPathButton Delegate

- (void)itemButtonTappedAtIndex:(NSUInteger)index
{
     NSLog(@"Add %@ Views %@",self.selectedViewController, [(UINavigationController *)self.selectedViewController viewControllers]);
    //UIViewController *viewController =[self.viewControllers objectAtIndex:0];
    UIViewController *selectedController = self.selectedViewController;
    
    
    NSLog(@"You tap at index : %ld", (unsigned long)index);
    switch (index) {
        case 0:
        {
            NSLog(@"My recs");
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:RextileStoryboard bundle:nil];
            
            RexMyRecsViewController *myRecsViewController = (RexMyRecsViewController *)[storyBoard instantiateViewControllerWithIdentifier:MyRecs];
            if ([selectedController isKindOfClass:[UINavigationController class]])
            {
                if (![[[(UINavigationController *)selectedController viewControllers] lastObject] isKindOfClass:[RexMyRecsViewController class]])
                {
                     [(UINavigationController *)selectedController pushViewController:myRecsViewController animated:NO];
                }

            }
            
        }
            break;
        case 1:
        {
            NSLog(@"TRY List");
        }
            break;
        case 2:
        {
            NSLog(@"Add recs");
        }
            break;
        case 3:
        {
            NSLog(@"Contact");
        }
            break;
        case 4:
        {
            NSLog(@"Friends recs");
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:RextileStoryboard bundle:nil];
            
            RexMyFriendsRecsViewController *myFriendsRecsViewController = (RexMyFriendsRecsViewController *)[storyBoard instantiateViewControllerWithIdentifier:MyFriendsRecs];
            if ([selectedController isKindOfClass:[UINavigationController class]])
            {
                if (![[[(UINavigationController *)selectedController viewControllers] lastObject] isKindOfClass:[RexMyFriendsRecsViewController class]])
                {
                    [(UINavigationController *)selectedController pushViewController:myFriendsRecsViewController animated:NO];
                }
                
            }

        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UITABBAR Delegate


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item;{
    switch (item.tag) {
        case 1:
        {
           // NSLog(@"Home %@",self.viewControllers);
            UIViewController *viewController =[self.viewControllers objectAtIndex:0];
            if ([viewController isKindOfClass:[UINavigationController class]])
            {
                [(UINavigationController *)viewController popToRootViewControllerAnimated:NO];
            }
            
        }
            break;
        case 3:{
            UIViewController *viewController =[self.viewControllers objectAtIndex:2];
            if ([viewController isKindOfClass:[UINavigationController class]])
            {
                [(UINavigationController *)viewController popToRootViewControllerAnimated:NO];
            }
        }
        default:
            break;
    }
}


@end
