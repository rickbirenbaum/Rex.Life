//
//  CountryListViewController.m
//  Country List
//
//  Created by Pradyumna Doddala on 18/12/13.
//  Copyright (c) 2013 Pradyumna Doddala. All rights reserved.
//

#import "CountryListViewController.h"
#import "CountryListDataSource.h"
#import "CountryCell.h"
#import "CountryData.h"

@interface CountryListViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *dataRows;
@property (strong, nonatomic) UILocalizedIndexedCollation *localizedIndexedCollation;
@property (strong, nonatomic) NSMutableArray *sectionsArray;
@end

@implementation CountryListViewController
{
    NSArray *indices;
   
}


- (id)initWithNibName:(NSString *)nibNameOrNil delegate:(id)delegate
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        // Custom initialization
        _delegate = delegate;
    }
    return self;
}
-(id)init{
    self = [super init];
    if (self) {
        // Custom initialization
       
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CountryListDataSource *dataSource = [[CountryListDataSource alloc] init];
    _dataRows = [dataSource countries];
   // [_tableView reloadData];
    
    [self configureSections];
    indices = [self.localizedIndexedCollation sectionIndexTitles];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Utility function

-(void)configureSections
{
    self.localizedIndexedCollation = [UILocalizedIndexedCollation currentCollation];
    NSInteger index, sectionTitlesCount = [[self.localizedIndexedCollation sectionTitles] count];
    NSMutableArray *newSectionsArray = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
    
    for (index = 0; index < sectionTitlesCount; index++)
    {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [newSectionsArray addObject:array];
    }
    
    for (CountryData *data in _dataRows)
    {
        
        NSInteger sectionNumber = [self.localizedIndexedCollation sectionForObject:data collationStringSelector:@selector(name)];
        NSMutableArray *sectionTimeZones = newSectionsArray[sectionNumber];
        [sectionTimeZones addObject:data];
    }
    
    for (index = 0; index < sectionTitlesCount; index++)
    {
        NSMutableArray *timeZonesArrayForSection = newSectionsArray[index];
        NSArray *sortedTimeZonesArrayForSection = [self.localizedIndexedCollation sortedArrayFromArray:timeZonesArrayForSection collationStringSelector:@selector(name)];
        newSectionsArray[index] = sortedTimeZonesArrayForSection;
    }
    
    //    [newSectionsArray insertObject:FirstSectionTitle atIndex:0];
    //    [newSectionsArray insertObject:mostContactFriendList atIndex:1];
    //    [newSectionsArray insertObject:recentContactFriendList atIndex:2];
    
    self.sectionsArray = newSectionsArray;
    //    backupSectionArray = [NSMutableArray arrayWithArray:newSectionsArray];
    
    [self.tableView reloadData];
}




#pragma mark - UITableView Datasource


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    return [self.localizedIndexedCollation sectionTitles][section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sectionsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [[self.sectionsArray objectAtIndex:section] count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    CountryCell *cell = (CountryCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[CountryCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    NSArray *arr = [self.sectionsArray objectAtIndex:indexPath.section];
    CountryData *countryData = [arr objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [countryData valueForKey:kCountryName];
    cell.detailTextLabel.text = [countryData valueForKey:kCountryCallingCode];
    
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [self.localizedIndexedCollation sectionTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [indices indexOfObject:title];
}
#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark -
#pragma mark Actions

- (IBAction)done:(id)sender
{
    if ([_delegate respondsToSelector:@selector(didSelectCountry:)]) {
        NSArray *arr = [self.sectionsArray objectAtIndex:[_tableView indexPathForSelectedRow].section];
        NSDictionary *countryData = [arr objectAtIndex:[_tableView indexPathForSelectedRow].row];
        
        [self.delegate didSelectCountry:countryData];
       // [self dismissViewControllerAnimated:YES completion:NULL];
        [self.navigationController popViewControllerAnimated:NO];
    } else {
        NSLog(@"CountryListView Delegate : didSelectCountry not implemented");
    }
}
- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
