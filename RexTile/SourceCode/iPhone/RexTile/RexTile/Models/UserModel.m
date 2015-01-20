//
//  UserModel.m
//  RexTile
//
//  Created by Sweety Singh on 12/19/14.
//  Copyright (c) 2014 Perennial. All rights reserved.
//

#import "UserModel.h"

#import "Constants.h"



static UserModel *sharedInstance = nil;


@implementation UserModel



+ (instancetype) sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[UserModel alloc] init];
        [sharedInstance loadSettings];
    });
    return sharedInstance;
}

- (void)saveSettings
{
    [[NSUserDefaults standardUserDefaults] setValue:self.user_userName forKey:kUserName];
    
    [[NSUserDefaults standardUserDefaults] setValue:self.user_emailId forKey:kEmailId];
    
    [[NSUserDefaults standardUserDefaults] setValue:self.user_userId forKey:kUserId];
  
    [[NSUserDefaults standardUserDefaults] setValue:self.user_phoneNo forKey:kUserPhoneNumber];
   
    [[NSUserDefaults standardUserDefaults] setValue:self.user_sessionId forKey:kSessionId];
    
    [[NSUserDefaults standardUserDefaults] setValue:self.user_loginType forKey:kLoginType];
    
    [[NSUserDefaults standardUserDefaults] setValue:self.user_smsStatus forKey:kSmsStatus];
    
    
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)resetSettings
{
    self.user_userName = @"";
    
    self.user_emailId = @"";
   
    self.user_userId = @"";
   
    self.user_phoneNo = @"";

    self.user_sessionId = @"";
    self.user_loginType = @"";
    self.user_smsStatus = @"";
    
    [self saveSettings];
}
- (void)loadSettings
{
    self.user_userName = [[NSUserDefaults standardUserDefaults] valueForKey:kUserName];
    
    self.user_emailId = [[NSUserDefaults standardUserDefaults] valueForKey:kEmailId];
    
    self.user_userId = [[NSUserDefaults standardUserDefaults] valueForKey:kUserId];
    
    self.user_phoneNo = [[NSUserDefaults standardUserDefaults] valueForKey:kUserPhoneNumber];
   
    self.user_sessionId = [[NSUserDefaults standardUserDefaults] valueForKey:kSessionId];
    self.user_loginType = [[NSUserDefaults standardUserDefaults] valueForKey:kLoginType];
    self.user_smsStatus = [[NSUserDefaults standardUserDefaults] valueForKey:kSmsStatus];
}




#ifdef DEBUG

- (NSString *)description
{
    NSMutableString *propertyDescriptions = [[NSMutableString alloc] init];
    NSDictionary *descriptions = [self describablePropertyNames];
    for (NSString *key in [descriptions allKeys])
    {
        id value = [self valueForKey:key];
        NSString *displayName = [descriptions valueForKey:key];
        [propertyDescriptions appendFormat:@"; %@ = %@", displayName, value];
    }
    return [NSString stringWithFormat:@"<%@: 0x%lx%@>", [self class], (unsigned long)self, propertyDescriptions];
}

- (NSDictionary *)describablePropertyNames
{
    return @{@"user_userId" : @"UserId", @"user_userName" : @"UserName", @"user_emailId" : @"UserEmail",@"user_phoneNo" : @"UserPhoneNumber"};
}

#endif



@end
