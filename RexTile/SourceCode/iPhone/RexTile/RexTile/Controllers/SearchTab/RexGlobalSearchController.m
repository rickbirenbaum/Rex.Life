//
//  GlobalSearchController.m
//  RexTile
//
//  Created by Sweety Singh on 12/18/14.
//  Copyright (c) 2014 Perennial. All rights reserved.
//

#import "RexGlobalSearchController.h"
#import "RexSettingsViewController.h"
#import "Constants.h"
#import "CustomSearchTableViewCell.h"
#import "RexLocationOverlayViewController.h"
#import "GooglePlaceModel.h"
#import "GoogleService.h"
#import "BlockOperationWithIdentifier.h"
#import "RexPlaceDetailViewController.h"



@interface RexGlobalSearchController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate,GoogleServiceDelegate>


@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *nearByPlacesArray;
@property (strong, nonatomic) NSMutableArray *searchedPlacesArray;
@property (strong, nonatomic) IBOutlet UISearchBar *locationSearchBar;
@property (strong, nonatomic) IBOutlet UIButton *btnCurrentLocation;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *btnLocationWidth;
@property (strong, nonatomic) GoogleService *googleService;
@property (nonatomic, strong) NSCache *userImageCache;
@property (nonatomic, strong) NSOperationQueue *userImageOperationQueue;


@end

@implementation RexGlobalSearchController
{
     UITapGestureRecognizer *tapGesture;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    [self setUp];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setUpNavigationBar];
    [self.locationSearchBar setBackgroundImage:[UIImage new]];
    [self setUpLocation];
    [self fetchNearByPlaces];
}
-(void)setUpNavigationBar{
     self.navigationController.navigationBar.hidden = YES;
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,Helvetica_RegularWithSize(17.0),NSFontAttributeName, nil];
    self.navigationController.navigationBar.titleTextAttributes = attributes;
}
-(void)setUp{
    self.nearByPlacesArray = [NSMutableArray array];
    self.searchedPlacesArray = [NSMutableArray array];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.userImageCache=[[NSCache alloc]init];
    self.userImageOperationQueue = [[NSOperationQueue alloc]init];
    self.userImageOperationQueue.maxConcurrentOperationCount = 2;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)btnSettingsClicked:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:RextileStoryboard bundle:nil];
    
    RexSettingsViewController *settingsViewController = (RexSettingsViewController *)[storyBoard instantiateViewControllerWithIdentifier:SettingsView];
    
    [self.navigationController pushViewController:settingsViewController animated:NO];
}


-(void)setUpLocation{
    
    
    CGFloat width = ceil([[[NSUserDefaults standardUserDefaults] objectForKey:UserChosenAddress] sizeWithAttributes:@{NSFontAttributeName:[self.btnCurrentLocation.titleLabel font]}].width);
    NSLog(@"Text widht %f",width);
    if (width > 270) {
        
        self.btnLocationWidth.constant = 280;
        [self.btnCurrentLocation setTitle:[NSString stringWithFormat:@" %@",[[NSUserDefaults standardUserDefaults] objectForKey:UserChosenAddress]] forState:UIControlStateNormal ];
        [self.btnCurrentLocation.layer setBorderColor:[UIColor whiteColor].CGColor];
        [self.btnCurrentLocation.layer setBorderWidth:1.0];
        self.btnCurrentLocation.layer.cornerRadius = 12.0;
        
    }else{
        
        width += 20 ;
        
        self.btnLocationWidth.constant = width;
        [self.btnCurrentLocation setTitle:[NSString stringWithFormat:@" %@",[[NSUserDefaults standardUserDefaults] objectForKey:UserChosenAddress]] forState:UIControlStateNormal ];
        [self.btnCurrentLocation.layer setBorderColor:[UIColor whiteColor].CGColor];
        [self.btnCurrentLocation.layer setBorderWidth:1.0];
        self.btnCurrentLocation.layer.cornerRadius = 12.0;
        self.btnCurrentLocation.layer.masksToBounds = YES;
        
    }
    
}
#pragma mark - UIButtons IBACTIONS
- (IBAction)btnLocationClicked:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:RextileStoryboard bundle:nil];
    
    RexLocationOverlayViewController *locationOverlayView = (RexLocationOverlayViewController *)[storyBoard instantiateViewControllerWithIdentifier:LocationOverlay];
    
    [self.navigationController pushViewController:locationOverlayView animated:NO];
}


#pragma mark - UITABLEVIEW DELEGATES

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    NSInteger rowCount = 0;
    
    switch (section) {
        case 0:
            rowCount = [self.nearByPlacesArray count];
            break;
        case 1:
            
            rowCount = [self.searchedPlacesArray count];
            
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
    
    
    
    static NSString *CellIdentifier = @"SearchCell";
    CustomSearchTableViewCell *cell = (CustomSearchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[CustomSearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    GooglePlaceModel *placeModel;

    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    switch (indexPath.section) {
        case 0:{
            placeModel = [self.nearByPlacesArray objectAtIndex:indexPath.row];
           
        }
            break;
        case 1:
        {
    
            placeModel = [self.searchedPlacesArray objectAtIndex:indexPath.row];
           
            
        }
            break;
            
        default:
            return nil;
            break;
    }
    
    cell.lblLocationAddress.text = placeModel.placeAddress;
    cell.lblLocationName.text = placeModel.placeName;
//    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:placeModel.placeIcon]];
//    cell.imgPlace.image  = [UIImage imageWithData:imageData];
    [cell.imgPlace.layer setBorderColor:[UIColor whiteColor].CGColor];
    [cell.imgPlace.layer setBorderWidth:1.0];
    cell.imgPlace.layer.cornerRadius = 5.0;
    cell.imgPlace.clipsToBounds = YES;
    
    
    BlockOperationWithIdentifier *operation = [BlockOperationWithIdentifier blockOperationWithBlock:^{
        
        
        //not needed
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:placeModel.placeIcon]];
        
        UIImage *img = [UIImage imageWithData:imageData];
        if (img) {
            cell.imgPlace.image = nil;//user a placeholder later
            [self.userImageCache setObject:img forKey:[NSString stringWithFormat:@"%@",placeModel.placeID]];
        }
        else{
            
            return;
        }
        
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            CustomSearchTableViewCell *updateCell =(CustomSearchTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            if (updateCell) {
                
                
                [updateCell.imgPlace.layer setBorderColor:[UIColor whiteColor].CGColor];
                [updateCell.imgPlace.layer setBorderWidth:1.0];
                updateCell.imgPlace.layer.cornerRadius = 5.0;
                updateCell.imgPlace.image = img;
                
                CATransition *transition = [CATransition animation];
                transition.duration = 0.75f;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.type = kCATransitionFade;
                
                [updateCell.imgPlace.layer addAnimation:transition forKey:nil];
                updateCell.imgPlace.contentMode=UIViewContentModeScaleAspectFit;
                updateCell.imgPlace.clipsToBounds = YES;
                
            }
        }];
    }];
    operation.queuePriority = NSOperationQueuePriorityNormal;
    operation.identifier=placeModel.placeID;
    [self.userImageOperationQueue addOperation:operation];


    return cell;


}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 24;
            break;
        case 1:
            return 24;
            break;
        default:
            return 0;
            
            break;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    switch (section) {
        case 0:{
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 24)];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, self.tableView.frame.size.width, 20)];
            label.text = @"PLACES NEARBY";
            label.textAlignment = NSTextAlignmentCenter;
            label.font = Helvetica_RegularWithSize(12.0); //[UIFont systemFontOfSize:12.0];
            label.textColor = [UIColor blackColor];
            label.backgroundColor = [UIColor clearColor];
            bgView.backgroundColor = UIColorFromRGB(255, 255, 255, 0.2);
            [bgView addSubview:label];
            
            return bgView;
        }
            break;
        case 1:
        {
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 24)];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, self.tableView.frame.size.width, 20)];
            label.text = @"PLACES";
            label.textAlignment = NSTextAlignmentCenter;
            label.font = Helvetica_RegularWithSize(12.0); //[UIFont systemFontOfSize:12.0];
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
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:RextileStoryboard bundle:nil];
    
    RexPlaceDetailViewController *placeDetailView = (RexPlaceDetailViewController *)[storyBoard instantiateViewControllerWithIdentifier:PlaceDetailView];
    placeDetailView.placeIndex = indexPath.row;
    
    switch (indexPath.section) {
        case 0:{
            placeDetailView.placesArray = self.nearByPlacesArray;
           
        }
            break;
        case 1:
        {
            placeDetailView.placesArray = self.searchedPlacesArray;
            
        }
            break;
            
        default:
            
            break;
    }
    
    
    [self.navigationController pushViewController:placeDetailView animated:NO];
}

#pragma mark - UISearchBar Delegates

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self addTapGesture];
    [self.locationSearchBar becomeFirstResponder];
    
}// called when text starts editing

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
    [self.locationSearchBar resignFirstResponder];
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    //self.locationSearchBar.text = @"";
    [self.locationSearchBar resignFirstResponder];
    if(tapGesture){
        [self.view removeGestureRecognizer:tapGesture];
        tapGesture=nil;
    }
    [self fetchSearchResultForText:TrimSting(searchBar.text)];
    
    
}// called when keyboard search button pressed
- (void) searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
    // TODO - dynamically update the search results here, if we choose to do that.
    
    
    if ([self.locationSearchBar.text length] == 0) {
        // The user clicked the [X] button or otherwise cleared the text.
        [theSearchBar performSelector: @selector(resignFirstResponder)
                           withObject: nil
                           afterDelay: 0.1];
    }
}

#pragma mark - GOOGLE Webservice calls

-(void)fetchSearchResultForText:(NSString *)searchStr{
    [MBProgressHUD showGlobalProgressHUDWithTitle:nil];
    self.googleService = [[GoogleService alloc] init];
    self.googleService.tag = 1;
    self.googleService.delegate = self;
    [self.googleService getPlacesForQuery:searchStr];
}
-(void)fetchNearByPlaces{
    [MBProgressHUD showGlobalProgressHUDWithTitle:nil];
    self.googleService = [[GoogleService alloc] init];
    self.googleService.tag = 2;
    self.googleService.delegate = self;
    [self.googleService getNearByPlaces];
}

#pragma mark - Google API Delegates
- (void)googleService:(GoogleService *)geoService didFinishWithResult:(NSArray *)result{
    [MBProgressHUD dismissGlobalHUD];
    if (geoService.tag ==1) {
        // Place api
        self.locationSearchBar.text = @"";
        NSLog(@"Place search ");
        self.searchedPlacesArray = [NSMutableArray arrayWithArray:result];
        [self.tableView reloadData];
        
    }
    if (geoService.tag ==2) {
        // Place api
        NSLog(@"nearby search ");
        
        NSArray *sortedArray = [NSMutableArray arrayWithArray:[result sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"self.distanceInMeter" ascending:YES]]]];
        self.nearByPlacesArray = [NSMutableArray arrayWithArray:[sortedArray subarrayWithRange:NSMakeRange(0, 5)]];
        
      //  NSLog(@"sdf %@",sorted);
        [self.tableView reloadData];
        
    }
}

- (void)googleService:(GoogleService *)geoService didFailWithError:(NSError *)error{
    [MBProgressHUD dismissGlobalHUD];
    [[[UIAlertView alloc] initWithTitle:@"Google Place Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
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
