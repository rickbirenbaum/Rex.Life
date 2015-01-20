//
//  CountryListDataSource.m
//  Country List
//
//  Created by Pradyumna Doddala on 18/12/13.
//  Copyright (c) 2013 Pradyumna Doddala. All rights reserved.
//

#import "CountryListDataSource.h"
#import "CountryData.h"

#define kCountriesFileName @"countries.json"

@interface CountryListDataSource () {
    NSMutableArray *countriesList;
}

@end

@implementation CountryListDataSource

- (id)init {
    self = [super init];
    if (self) {
        [self parseJSON];
    }
    
    return self;
}

- (void)parseJSON {
    countriesList = [[NSMutableArray alloc] init];
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"countries" ofType:@"json"]];
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
    NSArray *parsedData = (NSArray *)parsedObject;
    if (localError != nil) {
        NSLog(@"%@", [localError userInfo]);
    }
    for (int i =0; i<[parsedData count]; i++) {
        CountryData *countryData = [CountryData new];
        countryData.name = [[parsedData objectAtIndex:i] valueForKey:kCountryName];
        countryData.dial_code = [[parsedData objectAtIndex:i] valueForKey:kCountryCallingCode];
        countryData.code = [[parsedData objectAtIndex:i] valueForKey:kCountryCode];
        [countriesList addObject:countryData ];
    }
    
}

- (NSArray *)countries
{
    return countriesList;
}
@end
