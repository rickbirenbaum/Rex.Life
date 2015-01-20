//
//  ContactModel.h
//  AddressBookUtility
//
//  Created by Rahul N. Mane on 9/13/13.
//  Copyright (c) 2013 Rahul N. Mane. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactModel : NSObject

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic,strong)  UIImage *image;
@property (nonatomic, strong) NSMutableArray *phoneNumbers;
@property (nonatomic, strong) NSMutableArray *emails;
@end
