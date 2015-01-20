//
//  InnerView1.h
//  ComponentDemo
//
//  Created by Sweety Singh on 1/9/15.
//  Copyright (c) 2015 Perennial. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CallView : UIView
@property (weak, nonatomic) IBOutlet UIButton *btnPhoneNo;
@property (weak, nonatomic) IBOutlet UIButton *btnWebsite;

@property (weak, nonatomic) IBOutlet UILabel *lblMonday;
@property (weak, nonatomic) IBOutlet UILabel *lblTuesday;
@property (weak, nonatomic) IBOutlet UILabel *lblWednesday;
@property (weak, nonatomic) IBOutlet UILabel *lblThursday;
@property (weak, nonatomic) IBOutlet UILabel *lblFriday;
@property (weak, nonatomic) IBOutlet UILabel *lblSaturday;
@property (weak, nonatomic) IBOutlet UILabel *lblSunday;

@property (weak, nonatomic) IBOutlet UIButton *btnTryList;
@property (weak, nonatomic) IBOutlet UIButton *btnRecList;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UIView *categoryView;



@end
