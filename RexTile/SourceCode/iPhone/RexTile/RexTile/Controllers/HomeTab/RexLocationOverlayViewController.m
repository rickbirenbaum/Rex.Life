//
//  RexLocationOverlayViewController.m
//  RexTile
//
//  Created by Sweety Singh on 1/7/15.
//  Copyright (c) 2015 Perennial. All rights reserved.
//

#import "RexLocationOverlayViewController.h"
#import "CustomLocationTableViewCell.h"
#import "GooglePlaceModel.h"
#import "GoogleService.h"
#import "SearchWebServiceClient.h"


@interface RexLocationOverlayViewController ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate,GoogleServiceDelegate,WebServiceDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *searchResultArray;
@property (strong, nonatomic) NSMutableArray *previousLocationArray;
@property (strong, nonatomic) IBOutlet UISearchBar *locationSearchBar;
@property (strong, nonatomic) SearchWebServiceClient *searchWebService;
@property (strong, nonatomic) GoogleService *service;
@end

@implementation RexLocationOverlayViewController
{
    BOOL isSearching;
    UITapGestureRecognizer *tapGesture;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    isSearching = NO;
  
    self.previousLocationArray = [NSMutableArray array];
    self.searchResultArray = [NSMutableArray array];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self.locationSearchBar setBackgroundImage:[UIImage new]];
    [self fetchSavedSearches];
}
- (IBAction)btnCancelClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Webservice Calls
-(void)saveSearchedPlace:(GooglePlaceModel *)place{
    [MBProgressHUD showGlobalProgressHUDWithTitle:nil];
    self.searchWebService = [[SearchWebServiceClient alloc] init];
    self.searchWebService.tag = 2;
    self.searchWebService.delegate = self;
    [self.searchWebService saveSearch:place];
}
-(void)fetchSavedSearches{
    [MBProgressHUD showGlobalProgressHUDWithTitle:nil];
    self.searchWebService = [[SearchWebServiceClient alloc] init];
    self.searchWebService.tag = 1;
    self.searchWebService.delegate = self;
    [self.searchWebService fetchSearchHistory];
    
}
#pragma mark - UITABLEVIEW DELEGATES

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    NSInteger rowCount = 0;
    
    switch (section) {
        case 0:
            rowCount = 1;
            break;
        case 1:
            if (isSearching) {
                rowCount = [self.searchResultArray count];
            }else{
                rowCount = [self.previousLocationArray count];
            }
            
            break;
            
        default:
            rowCount=0;
            break;
    }
    
    return rowCount;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 64;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    return 2;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
    static NSString *CellIdentifier = @"LocationCell";
    CustomLocationTableViewCell *cell = (CustomLocationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[CustomLocationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    // cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    switch (indexPath.section) {
        case 0:
            cell.imgLocation.image = [UIImage imageNamed:@"red-icon.png"];
            cell.lblLocationAddress.text = [NSString stringWithFormat:@"Current Location - %@",[[NSUserDefaults standardUserDefaults] objectForKey:UserCurrentAddress]];
            break;
        case 1:
        {
            GooglePlaceModel *placeModel;
            cell.imgLocation.image = [UIImage imageNamed:@"blue-icon.png"];
            if (isSearching) {
                placeModel = [self.searchResultArray objectAtIndex:indexPath.row];
                
            }else{
                placeModel = [self.previousLocationArray objectAtIndex:indexPath.row];
                
            }
            cell.lblLocationAddress.text = placeModel.placeAddress;
        }
            break;
            
        default:
            break;
    }
    
    return cell;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 0;
            break;
        case 1:
            return 20;
            break;
        default:
            return 0;

            break;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
            return nil;
            
            break;
        case 1:
        {
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 20)];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 20)];
            label.text = @"PREVIOUS LOCATIONS";
            label.textAlignment = NSTextAlignmentCenter;
            label.font = Helvetica_RegularWithSize(12.0);//[UIFont systemFontOfSize:12.0];
            label.textColor = [UIColor blackColor];
            label.backgroundColor = [UIColor clearColor];
            bgView.backgroundColor = UIColorFromRGB(255, 255, 255, 0.2);
            [bgView addSubview:label];
        
            return bgView;
            
        }
            break;
        default:
            return nil;
            break;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
            [[NSUserDefaults standardUserDefaults]setValue:[[NSUserDefaults standardUserDefaults] valueForKey:UserLatitude] forKey:UserChosenLatitude];
            [[NSUserDefaults standardUserDefaults]setValue:[[NSUserDefaults standardUserDefaults] valueForKey:UserLongitude] forKey:UserChosenLongitude];
            [[NSUserDefaults standardUserDefaults] setObject:@" Current Location " forKey:UserChosenAddress];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.navigationController popViewControllerAnimated:NO];
            break;
        case 1:{
            if (isSearching) {
                isSearching = NO;
                self.locationSearchBar.text = @"";
                GooglePlaceModel *place = [self.searchResultArray objectAtIndex:indexPath.row];
                [self.previousLocationArray addObject:place];
                [self.tableView reloadData];
                [self saveSearchedPlace:place];
            }else{
                GooglePlaceModel *place = [self.previousLocationArray objectAtIndex:indexPath.row];
                [[NSUserDefaults standardUserDefaults]setValue:[NSNumber numberWithDouble:place.latitude] forKey:UserChosenLatitude];
                [[NSUserDefaults standardUserDefaults]setValue:[NSNumber numberWithDouble:place.longitude] forKey:UserChosenLongitude];
                [[NSUserDefaults standardUserDefaults]setObject:place.placeAddress forKey:UserChosenAddress];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self.navigationController popViewControllerAnimated:NO];
            }

        }
            break;
        default:
            break;
    }
    
}

#pragma mark - UISearchBar Delegates

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    if(searchBar.text.length == 0)
    {
        isSearching = NO;
        [self.searchResultArray removeAllObjects];
        [self.searchResultArray addObjectsFromArray:self.previousLocationArray];
    }
    [self addTapGesture];
    
}// called when text starts editing

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    isSearching = YES;
    
    [self.locationSearchBar resignFirstResponder];
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [self.locationSearchBar resignFirstResponder];
    
    isSearching = YES;
    if(tapGesture){
        [self.view removeGestureRecognizer:tapGesture];
        tapGesture=nil;
    }
    [self fetchSearchResultForText:TrimSting(searchBar.text)];
    
    
}// called when keyboard search button pressed


-(void)fetchSearchResultForText:(NSString *)searchStr{
    [MBProgressHUD showGlobalProgressHUDWithTitle:nil];
    self.service = [[GoogleService alloc] init];
    self.service.tag = 1;
    self.service.delegate = self;
    [self.service getPlacesForQuery:searchStr];
}


#pragma mark - Google API Delegates
- (void)googleService:(GoogleService *)geoService didFinishWithResult:(NSArray *)result{
    [MBProgressHUD dismissGlobalHUD];
    if (geoService.tag ==1) {
        // Place api
        NSLog(@"Place search ");
        self.searchResultArray = [NSMutableArray arrayWithArray:result];
        [self.tableView reloadData];
        
    }
}
- (void)googleService:(GoogleService *)geoService didFailWithError:(NSError *)error{
    [MBProgressHUD dismissGlobalHUD];
    [[[UIAlertView alloc] initWithTitle:@"Google Place Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}


#pragma mark - WEBSERVICE DELEGATES

-(void)request:(id)asynchroniousRequest didFinishWithResult:(NSArray *)result{
    
    [MBProgressHUD dismissGlobalHUD];
    
    switch ([asynchroniousRequest tag])
    {
        case 1://Fetch Search
        {
            NSLog(@"success %@",result);
            self.previousLocationArray = [NSMutableArray arrayWithArray:result];
            [self.tableView reloadData];
            
        }
            break;
            
         case 2:
            NSLog(@"success %@",result);
            break;
        default:
            break;
    }
    
    
}

-(void)request:(id)asynchroniousRequest didFailWithError:(NSError *)error
{
    [MBProgressHUD dismissGlobalHUD];
    
    
    [[[UIAlertView alloc] initWithTitle:@"ERROR" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}


#pragma mark - Tap Gesture Methods

-(void)tapGestureClicked:(UITapGestureRecognizer *)tap{
    [self.view removeGestureRecognizer:tapGesture];
    tapGesture=nil;
    [self.view endEditing:YES];
    
}
-(void)addTapGesture{
    if(tapGesture){
        [self.view removeGestureRecognizer:tapGesture];
        tapGesture=nil;
    }
    tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureClicked:)];
    [self.view addGestureRecognizer:tapGesture];
}
@end
