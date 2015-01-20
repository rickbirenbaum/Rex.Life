//
//  ViewController.m
//  RexTile
//
//  Created by Sweety Singh on 12/17/14.
//  Copyright (c) 2014 Perennial. All rights reserved.
//

#import "RexBaseViewController.h"


@interface RexBaseViewController ()
@property (strong, nonatomic) IBOutlet UIButton *btnSignUp;

@end

@implementation RexBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   // NSLog(@"availableLocaleIdentifiers: %@", [NSLocale ISOCountryCodes]);
    //[NSLocale ISOCountryCodes]
  
    [self.btnSignUp.layer setBorderWidth:1.0];
    [self.btnSignUp.layer setBorderColor:UIColorFromRGB(0, 145, 255, 1).CGColor];
    self.btnSignUp.layer.cornerRadius = 5.0;
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,Helvetica_RegularWithSize(17.0),NSFontAttributeName, nil];
    self.navigationController.navigationBar.titleTextAttributes = attributes;
       // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

@end
