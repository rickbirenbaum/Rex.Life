//
//  WebServiceDelegate.h
//  I_Like_My_Waitress
//
//  Created by Rahul V. Mane on 8/26/14.
//  Copyright (c) 2014 Perennial. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WebServiceDelegate <NSObject>

@required
- (void)request:(id)asynchroniousRequest didFinishWithResult:(NSArray *)result;

- (void)request:(id)asynchroniousRequest didFailWithError:(NSError *)error;

@end
