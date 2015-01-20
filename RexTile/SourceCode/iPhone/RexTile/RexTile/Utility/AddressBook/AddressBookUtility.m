//
//  AddressBookUtility.m
//  RexTile
//
//  Created by Sweety Singh on 12/31/14.
//  Copyright (c) 2014 Perennial. All rights reserved.
//

#import "AddressBookUtility.h"
#import "ContactModel.h"



@implementation AddressBookUtility

-(void)getAllContact{
   
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied ||
        ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusRestricted){
        //1
        NSLog(@"Denied");
        [self.delegate addressBookUtilityDeniedAcess];
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
        //2
        NSLog(@"Authorized");
        [self loadContacts];
    } else if(ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined){
        //3
        NSLog(@"Not determined");
        ABAddressBookRequestAccessWithCompletion(ABAddressBookCreateWithOptions(NULL, nil), ^(bool granted, CFErrorRef error) {
            if (error) {
                [self.delegate addressBookUtilityError:error]; //delegate if error occres
            } else if (!granted) {
                //4
                NSLog(@"Just denied");
                [self.delegate addressBookUtilityDeniedAcess];
                return;
            }
            //5
            NSLog(@"Just authorized");
            [self loadContacts];
            
        });
    }
}

-(void)loadContacts{
    
    CFErrorRef *error = nil;
    
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
    
    __block BOOL accessGranted = NO;
    
    if (ABAddressBookRequestAccessWithCompletion != NULL) { // we're on iOS 6
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
    }
    else { // we're on iOS 5 or older
        accessGranted = YES;
    }
    
    
    if (accessGranted) {
         NSMutableArray *arrayOfContactModelToReturn=[[NSMutableArray alloc]init];
        
        CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
        NSArray *allContact=CFBridgingRelease(people);
        NSUInteger i = 0;
        for (i = 0; i < [allContact count]; i++)
        {
            ContactModel *person = [[ContactModel alloc] init]; // model which will assume one per contact
            ABRecordRef contactPerson = (__bridge ABRecordRef)allContact[i];
            
            NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty);
            NSString *lastName =  (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
            person.firstName = firstName;
            person.lastName = lastName;

            if(ABPersonHasImageData(contactPerson))
            {
                person.image = [UIImage imageWithData:(__bridge NSData *)ABPersonCopyImageData(contactPerson)];
                
            }
            

             NSMutableArray *phoneNumbers = [[NSMutableArray alloc] init];
            
            ABMultiValueRef multi = ABRecordCopyValue(contactPerson, kABPersonPhoneProperty);
            
            for (CFIndex j=0; j < ABMultiValueGetCount(multi); j++) {
                
                NSString* phone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(multi, j);
                NSString *label = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(multi, j);
                
    
                    if([label isEqualToString:(NSString *)kABPersonPhoneMobileLabel])
                    {
                        [phoneNumbers addObject:phone];
                    }
                    else if ([label isEqualToString:(NSString *)kABPersonPhoneIPhoneLabel])
                    {
                        [phoneNumbers addObject:phone];
                    }
                    else if ([label isEqualToString:(NSString *)kABPersonPhoneMainLabel])
                    {
                        [phoneNumbers addObject:phone];
                    }
                    else if ([label isEqualToString:(NSString *)kABHomeLabel])
                    {
                        [phoneNumbers addObject:phone];
                    }
//                    else if ([label isEqualToString:(NSString *)kABWorkLabel])
//                    {
//                        [phoneNumbers addObject:phone];
//                    }
//                    else if ([label isEqualToString:(NSString *)kABOtherLabel])
//                    {
//                        [phoneNumbers addObject:phone];
//                    }
                
            }
            [person setPhoneNumbers:phoneNumbers];

            //get Contact email
            
            NSMutableArray *contactEmails = [NSMutableArray new];
            ABMultiValueRef multiEmails = ABRecordCopyValue(contactPerson, kABPersonEmailProperty);
            
            for (CFIndex i=0; i<ABMultiValueGetCount(multiEmails); i++) {
                CFStringRef contactEmailRef = ABMultiValueCopyValueAtIndex(multiEmails, i);
                NSString *contactEmail = (__bridge NSString *)contactEmailRef;
                
                [contactEmails addObject:contactEmail];
                // NSLog(@"All emails are:%@", contactEmails);
                
            }
            
            [person setEmails:contactEmails];
            if (person.phoneNumbers.count> 0) {
                [arrayOfContactModelToReturn addObject:person];
            }
            
            
#ifdef DEBUG
         //   NSLog(@"Person is: %@", person.firstName);
        //    NSLog(@"Phones are: %@", person.phoneNumbers);
         //   NSLog(@"Email is:%@", person.emails);
#endif
            
        }
        
        
        [self.delegate addressbookUtilityAllContacts:arrayOfContactModelToReturn];

        
    }

}


@end
