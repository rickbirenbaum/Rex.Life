//
//  AddressBookUtilityDelegate.h
//  AddressBookUtility
//
//  Created by Rahul N. Mane on 9/13/13.
//  Copyright (c) 2013 Rahul N. Mane. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AddressBookUtilityDelegate <NSObject>

-(void)addressBookUtilityError:(CFErrorRef)error;
-(void)addressBookUtilityDeniedAcess;
-(void)addressbookUtilityAllContacts:(NSMutableArray *)contacts;

@end
