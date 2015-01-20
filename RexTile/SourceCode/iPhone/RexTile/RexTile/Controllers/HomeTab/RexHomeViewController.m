//
//  HomeViewController.m
//  RexTile
//
//  Created by Sweety Singh on 12/18/14.
//  Copyright (c) 2014 Perennial. All rights reserved.
//

#import "RexHomeViewController.h"
#import "Constants.h"
#import "GoogleService.h"

#import "GeoCodeModel.h"
#import "RexSettingsViewController.h"
#import "ActivityTableViewCell.h"
#import "iCarousel.h"
#import "GooglePlaceModel.h"
#import "CustomPlaceView.h"
#import "RexPlaceDetailViewController.h"
#import "AddressBookUtility.h"
#import "ContactModel.h"
#import "UserWebServiceClient.h"
#import "RecommendationListWebServices.h"
#import "RexLocationOverlayViewController.h"
#import "RexMyFriendsRecsViewController.h"
#import "RexMyRecsViewController.h"

@interface RexHomeViewController ()<GoogleServiceDelegate, UITableViewDataSource, UITableViewDelegate,iCarouselDataSource,iCarouselDelegate,AddressBookUtilityDelegate,WebServiceDelegate>


@property (strong, nonatomic) IBOutlet UIButton *btnCurrentLocation;
@property (strong, nonatomic) IBOutlet UIImageView *imageBackground;
@property (strong, nonatomic) IBOutlet UIButton *btnMyRecs;
@property (strong, nonatomic) IBOutlet UIButton *btnFriendsRecs;
@property (nonatomic, strong) IBOutlet iCarousel *viewForNearByPlaces;
@property (strong, nonatomic) IBOutlet UITableView *tableViewRecentActivity;
@property (nonatomic, strong) NSMutableArray *placesArray;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *btnLocationWidth;
@property (strong, nonatomic) UserWebServiceClient *userService;
@property (strong, nonatomic) RecommendationListWebServices *recsService;
@property (nonatomic, strong) NSMutableArray *recommendedPlacesArray;

@end

@implementation RexHomeViewController
{
    NSString *myRecsCount;
    NSString *myFriendsRecCount;
}

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
   
    [self setUp];
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self setUpNavigationBar];
     [self setUpLocation];
     [self queryGooglePlaces];
     [self viewHomeScreenCount];
}

-(void)setUp{
    [self getAllContact];
    self.viewForNearByPlaces.type = iCarouselTypeLinear;
    self.viewForNearByPlaces.delegate = self;
    self.viewForNearByPlaces.dataSource = self;
    [self.viewForNearByPlaces reloadData];
}

-(void)setUpNavigationBar{
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,Helvetica_RegularWithSize(17.0),NSFontAttributeName, nil];
    self.navigationController.navigationBar.titleTextAttributes = attributes;
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

-(void)getAllContact
{
    AddressBookUtility *address=[[AddressBookUtility alloc]init];
    address.delegate=self;
    [address getAllContact];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - UIButtons IBACTIONS
- (IBAction)btnLocationClicked:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:RextileStoryboard bundle:nil];
    
    RexLocationOverlayViewController *locationOverlayView = (RexLocationOverlayViewController *)[storyBoard instantiateViewControllerWithIdentifier:LocationOverlay];
    
    [self.navigationController pushViewController:locationOverlayView animated:NO];
}

- (IBAction)btnSettingsClicked:(id)sender {
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:RextileStoryboard bundle:nil];
    
    RexSettingsViewController *settingsViewController = (RexSettingsViewController *)[storyBoard instantiateViewControllerWithIdentifier:SettingsView];
    
    [self.navigationController pushViewController:settingsViewController animated:NO];
    
    
}
- (IBAction)btnMyRecsClicked:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:RextileStoryboard bundle:nil];
    
    RexMyRecsViewController *myRecsViewController = (RexMyRecsViewController *)[storyBoard instantiateViewControllerWithIdentifier:MyRecs];
    
    [self.navigationController pushViewController:myRecsViewController animated:NO];
}
- (IBAction)btnFriendsRecsClicked:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:RextileStoryboard bundle:nil];
    
    RexMyFriendsRecsViewController *myFriendRecsViewController = (RexMyFriendsRecsViewController *)[storyBoard instantiateViewControllerWithIdentifier:MyFriendsRecs];
    
    [self.navigationController pushViewController:myFriendRecsViewController animated:NO];
}
- (IBAction)btnAddRecsClicked:(id)sender {
    
   

}


#pragma mark - Google API Services

-(void) queryGooglePlaces{
    [MBProgressHUD showGlobalProgressHUDWithTitle:nil];
    GoogleService *service = [[GoogleService alloc] init];
    service.tag = 1;
    service.delegate = self;
    [service getNearByPlaces];
   
}


#pragma mark - Google API Delegates
- (void)googleService:(GoogleService *)geoService didFinishWithResult:(NSArray *)result{
    [MBProgressHUD dismissGlobalHUD];
    if (geoService.tag ==1) {
        // Place api
        NSLog(@"Place api ");
       // self.placesArray = [NSMutableArray arrayWithArray:result];
        
        self.placesArray = [NSMutableArray arrayWithArray:[result sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"self.distanceInMeter" ascending:YES]]]];
        
        [self.viewForNearByPlaces reloadData];
      
        
    }
}
- (void)googleService:(GoogleService *)geoService didFailWithError:(NSError *)error{
     [MBProgressHUD dismissGlobalHUD];
     [[[UIAlertView alloc] initWithTitle:@"Google Place Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}



#pragma mark - UITableView Delegates
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return 65;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}





-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    ActivityTableViewCell *cell = (ActivityTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ActivityCell" forIndexPath:indexPath];
    
    cell.lblActivityDetail.text = @"Rick recommended 3 new places in San Francisco";
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return [self.placesArray count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    
    GooglePlaceModel *placeModel = [self.placesArray objectAtIndex:index];
    
    CustomPlaceView *placeView;
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CustomPlaceView" owner:self options:nil];
    placeView = [array objectAtIndex:0];
    placeView.lblPlaceName.text = placeModel.placeName;
    placeView.lblPlaceAddress.text = placeModel.placeAddress;
    placeView.lblDistance.text = placeModel.strDistance;

    
    return placeView;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option == iCarouselOptionSpacing)
    {
        return value * 1.1f;
    }
    return value;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:RextileStoryboard bundle:nil];
    
    RexPlaceDetailViewController *placeDetailView = (RexPlaceDetailViewController *)[storyBoard instantiateViewControllerWithIdentifier:PlaceDetailView];
    placeDetailView.placeIndex = index;
    placeDetailView.placesArray = self.placesArray;
    
    [self.navigationController pushViewController:placeDetailView animated:NO];
    
    
}

#pragma mark - AddressBook Utility Delegates

-(void)addressBookUtilityError:(CFErrorRef)error{
     NSLog(@"Error %@",error);
}
-(void)addressBookUtilityDeniedAcess{
     NSLog(@"Just denied");
    UIAlertView *cantAddContactAlert = [[UIAlertView alloc] initWithTitle: @"Cannot Fetch Contact" message: @"You must give the app permission to add the contact first." delegate:nil cancelButtonTitle: @"OK" otherButtonTitles: nil];
    [cantAddContactAlert show];
}
-(void)addressbookUtilityAllContacts:(NSMutableArray *)contacts{
    
    NSMutableArray *contactArray = [[NSMutableArray alloc] init];
    for (int i =0; i < contacts.count ; i++) {
        ContactModel *contact = [contacts objectAtIndex:i];
      //  NSLog(@"contact %d name %@ number %@",i,contact.fullName,contact.phoneNumbers);
        [contactArray addObjectsFromArray:contact.phoneNumbers];
    }
    if (contactArray.count > 0) {
        [self syncAllContact:contactArray];
    }
    
}

#pragma mark - WEBSERVICE CALLS

-(void)viewHomeScreenCount{
    [MBProgressHUD showGlobalProgressHUDWithTitle:nil];
    self.recsService = [[RecommendationListWebServices alloc] init];
    self.recsService.tag =1;
    self.recsService.delegate = self;
    [self.recsService getHomeRecsCount];
}
-(NSMutableArray *)getPlaceIdArray{
    NSMutableArray *placeIdArray = [[NSMutableArray alloc] init];
    for (GooglePlaceModel *place in self.placesArray) {
        [placeIdArray addObject:[NSString stringWithFormat:@"'%@'",place.placeID] ];
    }
    return placeIdArray;
}
-(void)getRecommendationCountForPlaces{
    NSArray *placesArray = [NSArray arrayWithArray:[self getPlaceIdArray]];
    if (placesArray.count >0) {
        [MBProgressHUD showGlobalProgressHUDWithTitle:nil];
        self.userService = [[UserWebServiceClient alloc] init];
        self.userService.tag =2;
        self.userService.delegate = self;
        [self.userService getRecommendationCountForPlaces:placesArray];
    }
}

-(void)syncAllContact:(NSMutableArray *)arrayOfPhoneNo{
    [MBProgressHUD showGlobalProgressHUDWithTitle:nil];
    self.userService = [[UserWebServiceClient alloc] init];
    self.userService.tag =1;
    self.userService.delegate = self;
    [self.userService syncUserContact:arrayOfPhoneNo];
}




#pragma mark - WEBSERVICE DELEGATES

-(void)request:(id)asynchroniousRequest didFinishWithResult:(NSArray *)result{
    
    [MBProgressHUD dismissGlobalHUD];
    if (asynchroniousRequest == self.recsService) {
        switch ([asynchroniousRequest tag])
        {
            case 1://Recs Count
            {
                
                NSLog(@"success");
                NSDictionary *tempDict = result[0];
                myRecsCount = [tempDict valueForKey:@"my_recs"];
                myFriendsRecCount = [tempDict valueForKey:@"my_friend_recs"];
                [self.btnMyRecs setTitle:myRecsCount forState:UIControlStateNormal];
                [self.btnFriendsRecs setTitle:myFriendsRecCount forState:UIControlStateNormal];
                
            }
                break;
           
               
            default:
                break;
        }

    }else{
        switch ([asynchroniousRequest tag])
        {
            case 1://SYNC Contact
            {
                
                NSLog(@"SYNC Contact success");
                
            }
                break;
            case 2:{
                
                NSLog(@"success");
                
            }
            
               
                break;
            default:
                break;
        }

    }
    
    
}

-(void)request:(id)asynchroniousRequest didFailWithError:(NSError *)error
{
    [MBProgressHUD dismissGlobalHUD];
    
    
    [[[UIAlertView alloc] initWithTitle:@"ERROR" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}
@end
