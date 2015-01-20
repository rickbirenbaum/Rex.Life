//
//  AddressBookUtility.h
//  RexTile
//
//  Created by Sweety Singh on 12/31/14.
//  Copyright (c) 2014 Perennial. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import "AddressBookUtilityDelegate.h"

@interface AddressBookUtility : NSObject

@property(nonatomic,strong)id<AddressBookUtilityDelegate> delegate;


-(void)getAllContact;

@end
