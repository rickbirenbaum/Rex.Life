//
//  RexParser.h
//  RexTile
//
//  Created by Sweety Singh on 12/23/14.
//  Copyright (c) 2014 Perennial. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RexParser : NSObject

- (NSArray *)userWebClientSignInSignUpParser:(NSDictionary *)responseData;
- (NSArray *)parseMyRecsData:(NSArray *)responseData;
- (NSArray *)parseSearchHistory:(NSArray *)responseData;


@end
