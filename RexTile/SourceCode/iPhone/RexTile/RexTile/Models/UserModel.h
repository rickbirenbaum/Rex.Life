//
//  UserModel.h
//  RexTile
//
//  Created by Sweety Singh on 12/19/14.
//  Copyright (c) 2014 Perennial. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UserModel : NSObject


// Permanent Data to be stored
@property (strong, nonatomic) NSString *user_userName;
@property (strong, nonatomic) NSString *user_userId;
@property (strong, nonatomic) NSString *user_emailId;
@property (strong, nonatomic) NSString *user_sessionId;
@property (strong, nonatomic) NSString  *user_phoneNo;
@property (strong, nonatomic) NSString *user_smsStatus;
@property (strong, nonatomic) NSString  *user_loginType;

+ (instancetype)sharedInstance;

- (void)saveSettings;
- (void)resetSettings;
@end
