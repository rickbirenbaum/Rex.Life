//
//  RexPlaceDetailViewController.m
//  RexTile
//
//  Created by Sweety Singh on 12/29/14.
//  Copyright (c) 2014 Perennial. All rights reserved.
//

#import "RexPlaceDetailViewController.h"
#import "GoogleService.h"
#import "GooglePlaceModel.h"
#import "PHPageScrollView.h"
#import "CustomPlaceDetailView.h"
#import "RecommendationListWebServices.h"



@interface RexPlaceDetailViewController ()<GoogleServiceDelegate, PHPageScrollViewDataSource, PHPageScrollViewDelegate,UIAlertViewDelegate,WebServiceDelegate>

@property (nonatomic, strong) IBOutlet PHPageScrollView *placeDetailScrollView;
@property (nonatomic, strong) RecommendationListWebServices *recommendationWebService;
//@property (strong, nonatomic) IBOutlet NSLayoutConstraint *widtdsah;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topSpace;

@property (nonatomic, strong) NSMutableArray *recommendedPlacesArray;
@end

@implementation RexPlaceDetailViewController
{
    GooglePlaceModel *currentPlaceModel;
    UIAlertView *alertViewForCall;
    CustomPlaceDetailView *placeDetailView;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.placeDetailScrollView.delegate = self;
    self.placeDetailScrollView.dataSource = self;
    //self.width.constant = [[UIScreen mainScreen] bounds].size.width;
    if ([[UIScreen mainScreen] bounds].size.height > 500) {
        self.topSpace.constant = 100;
    }else{
        self.topSpace.constant = 72;
    }
   // Do any additional setup after loading the view.
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
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setUpNavigationBar];
    
    NSLog(@"index %ld",(long)self.placeIndex);
    [self.placeDetailScrollView reloadData];
    [self getRecommendationStatusForPlaces];
    [self.placeDetailScrollView scrollToPage:self.placeIndex animation:YES];
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



-(IBAction)backButtonClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:NO];
}


#pragma mark - Google API Services

-(void)queryPlacesDetail:(NSString *)placeId{
    [MBProgressHUD showGlobalProgressHUDWithTitle:nil];
    GoogleService *service = [[GoogleService alloc] init];
    service.tag = 1;
    service.delegate = self;
    [service fetchPlaceDetail:placeId];
    
}
#pragma mark - Google API Delegates
- (void)googleService:(GoogleService *)geoService didFinishWithResult:(NSArray *)result{
    
    [MBProgressHUD dismissGlobalHUD];
    if (geoService.tag ==1) {
        // Place api
    //    NSLog(@"Place detail api %@",result);
        currentPlaceModel = result[0];
        [self.placesArray replaceObjectAtIndex:self.placeIndex withObject:currentPlaceModel];
     //   NSLog(@"%@\n%@\n%@\n%@\n%@",currentPlaceModel.placePhoneNo,currentPlaceModel.placeWebsite,currentPlaceModel.placeName,[NSString stringWithFormat:@"%@",[currentPlaceModel.openHours objectAtIndex:0]],currentPlaceModel.category);
      
       // [self.placeDetailView reloadData];
        [self refreshPlaceModelWithRecs];
      //  [self refreshPlace];

    }
}
- (void)googleService:(GoogleService *)geoService didFailWithError:(NSError *)error{
    [MBProgressHUD dismissGlobalHUD];
    [[[UIAlertView alloc] initWithTitle:@"Google Place Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}


#pragma mark - PHPageScrollViewDelegate

- (NSInteger)numberOfPageInPageScrollView:(PHPageScrollView*)pageScrollView
{
    return [self.placesArray count];
}

- (CGSize)sizeCellForPageScrollView:(PHPageScrollView*)pageScrollView
{
    return CGSizeMake(300, 410);
}

- (UIView*)pageScrollView:(PHPageScrollView*)pageScrollView viewForRowAtIndex:(int)index
{
    
    GooglePlaceModel *placeModel = [self.placesArray objectAtIndex:index];
    
    
    //CustomPlaceDetailView *placeDetailView;
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CustomPlaceDetailView" owner:nil options:nil];
    placeDetailView = [array objectAtIndex:0];
       
    placeDetailView.lblPlaceName.text = placeModel.placeName;
    placeDetailView.lblPlaceAddress.text =placeModel.placeAddress;
    placeDetailView.lblDistance.text = placeModel.strDistance;
    placeDetailView.placeLatitude = placeModel.latitude;
    placeDetailView.placeLongitude = placeModel.longitude;
    placeDetailView.placeDetailModel = placeModel;
    
//    if (placeModel.isAddedRec) {
//        [placeDetailView updateRecsButtonTitle:@"- Rec"];
//    }else{
//        [placeDetailView updateRecsButtonTitle:@"+ Rec"];
//    }
    
    
    /// Adding blocks for call back from custom view on button actions
    [placeDetailView getPhoneCallback:^(BOOL success) {
        if (success) {
            alertViewForCall=[[UIAlertView alloc] initWithTitle:currentPlaceModel.placePhoneNo message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: @"Call",nil];
            
            [alertViewForCall show];
        }
    }];
    [placeDetailView getWebsiteCallback:^(BOOL success) {
        [self btnWebsiteClicked];
    }];
    
    [placeDetailView getTryListCallback:^(BOOL isAdd){
        
        [self tryListClicked:isAdd];
    }];
    
    [placeDetailView getRecListCallback:^(BOOL isAdd){
       
        [self recListClicked:isAdd];
    }];
    
    [placeDetailView getShareCallback:^{
        [self shareClicked];
    }];
    
   
    
    return placeDetailView;
    
}

- (void)pageScrollView:(PHPageScrollView*)pageScrollView willScrollToPageAtIndex:(NSInteger)index
{
    NSLog(@"scroll to index %ld",(long)index);
    NSLog(@"phone %@",[[self.placesArray objectAtIndex:index] placePhoneNo]);
    if (self.placeIndex != index && (!([[self.placesArray objectAtIndex:index] placePhoneNo]) ||!([[self.placesArray objectAtIndex:index] placeWebsite])) ) {
        self.placeIndex = index;
        NSString *placeID = [[self.placesArray objectAtIndex:self.placeIndex] placeID];
        [self queryPlacesDetail:placeID];
    }
    
    CustomPlaceDetailView *previousView=(CustomPlaceDetailView *)[pageScrollView viewForRowAtIndex:index-1];
        if(previousView){
            [previousView removeMap];
            [previousView.pagingView scrollToPage:0 animation:YES];
        }
    
    CustomPlaceDetailView *nextView=(CustomPlaceDetailView *)[pageScrollView viewForRowAtIndex:index+1];
    if(nextView){
        [nextView removeMap];
        [nextView.pagingView scrollToPage:0 animation:YES];
    }


}
-(NSString *)getOpenHoursStr:(NSString *)str{
    
    return [[str componentsSeparatedByString:@": "] objectAtIndex:1];
   
}
-(void)refreshPlace{
  
    GooglePlaceModel *placeModel = [self.placesArray objectAtIndex:self.placeIndex];
    CustomPlaceDetailView *currentView =(CustomPlaceDetailView *)[self.placeDetailScrollView viewForRowAtIndex:self.placeIndex];
    currentView.lblPlaceName.text = placeModel.placeName;
    currentView.lblPlaceAddress.text =placeModel.placeAddress;
    currentView.lblDistance.text = placeModel.strDistance;
    currentView.placeLatitude = placeModel.latitude;
    currentView.placeLongitude = placeModel.longitude;
    currentView.placeDetailModel = placeModel;
    if (placeModel.isAddedRec) {
        [currentView updateRecsButtonTitle:@"- Rec"];
    }else{
        [currentView updateRecsButtonTitle:@"+ Rec"];
    }
}


/**
 To set up the category views depending upon the width of category text
 *//*
-(void)setUpCategoryView:(NSArray *)array andView:(UIView *)view{
    
    float currentX = 20.0;
    float currentY = 0.0;
    NSArray *subViewArray = view.subviews;
    for (int i = 0; i<[array count]; i++)
    {
        UILabel *label = nil;
        if (i < subViewArray.count) {
            label = [subViewArray objectAtIndex:i];
        }else{
            label = [[UILabel alloc] init];
            [view addSubview:label];
            
        }
        
        label.text = [NSString stringWithFormat:@"  %@  ",[array objectAtIndex:i]];
        //label.numberOfLines = 0;
        
        label.layer.cornerRadius = 7.0;
        label.clipsToBounds = YES;
        label.font = Helvetica_RegularWithSize(12.0);;//[UIFont systemFontOfSize:12.0];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = UIColorFromRGB(148, 143, 140, 1);
        [label sizeToFit];
        
        float width =  label.frame.size.width;
       
        if ((currentX + width) > 260) {
            
            currentX = 20.0;
            currentY += currentY+20;
            if (currentY>=40) {
                currentX = 0.0;
                currentY = 0.0;
                          // NSLog(@"in frame");
                [label removeFromSuperview];
                 return;
            }
        }
       
        label.frame = CGRectMake(currentX, currentY, width, 16.0);
        currentX += width+5;
        
    }
    
}
 */
#pragma mark - UIActions 


-(void)btnWebsiteClicked{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:currentPlaceModel.placeWebsite]];
}

-(void)openCallingApplication:(NSString *)number{
    NSString *phoneNumber =[@"tel://" stringByAppendingString:[number stringByReplacingOccurrencesOfString:@" " withString:@""]];
    
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    
}
-(void)recListClicked:(BOOL)isAdd{
    NSLog(@"recListClicked");
    if (isAdd) {
        // Call webservice to add rec
         [MBProgressHUD showGlobalProgressHUDWithTitle:nil];
        self.recommendationWebService = [[RecommendationListWebServices alloc] init];
        self.recommendationWebService.tag =1;
        self.recommendationWebService.delegate = self;
        [self.recommendationWebService addRecommendation:currentPlaceModel];
    }else{
        // Call webservice to remove rec
         [MBProgressHUD showGlobalProgressHUDWithTitle:nil];
        self.recommendationWebService = [[RecommendationListWebServices alloc] init];
        self.recommendationWebService.tag =2;
        self.recommendationWebService.delegate = self;
        [self.recommendationWebService removeRecommendation:currentPlaceModel.placeID];

    }
    
}
-(void)tryListClicked:(BOOL)isAdd{
     NSLog(@"tryListClicked");
   /* if (isAdd) {
        // Call webservice to add rec
         [MBProgressHUD showGlobalProgressHUDWithTitle:nil];
        self.recommendationWebService = [[RecommendationListWebServices alloc] init];
        self.recommendationWebService.tag =3;
        self.recommendationWebService.delegate = self;
        [self.recommendationWebService addTryList:currentPlaceModel];
    }else{
        // Call webservice to remove rec
         [MBProgressHUD showGlobalProgressHUDWithTitle:nil];
        self.recommendationWebService = [[RecommendationListWebServices alloc] init];
        self.recommendationWebService.tag =4;
        self.recommendationWebService.delegate = self;
        [self.recommendationWebService removeTryList:currentPlaceModel.placeID];
        
    }*/
}
-(void)shareClicked{
     NSLog(@"shareClicked");
}




#pragma mark - WEBSERVICE CALLS
-(NSMutableArray *)getPlaceIdArray{
    NSMutableArray *placeIdArray = [[NSMutableArray alloc] init];
    for (GooglePlaceModel *place in self.placesArray) {
        [placeIdArray addObject:[NSString stringWithFormat:@"'%@'",place.placeID] ];
    }
    return placeIdArray;
}
-(void)getRecommendationStatusForPlaces{
    NSArray *placesArray = [NSArray arrayWithArray:[self getPlaceIdArray]];
    if (placesArray.count >0) {
        [MBProgressHUD showGlobalProgressHUDWithTitle:nil];
        self.recommendationWebService = [[RecommendationListWebServices alloc] init];
        self.recommendationWebService.tag = 5;
        self.recommendationWebService.delegate = self;
        [self.recommendationWebService getRecommendationStatus:placesArray];
    }
}

#pragma mark - UIAlertView Delegates

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView==alertViewForCall){
        switch (buttonIndex) {
            case 0:{
                
                break;
            }
            case 1:
            {
                [self openCallingApplication:currentPlaceModel.placePhoneNo];
                break;
            }
            default:
                break;
        }
    }
}




#pragma mark - WEBSERVICE DELEGATES

-(void)request:(id)asynchroniousRequest didFinishWithResult:(NSArray *)result{
    
    [MBProgressHUD dismissGlobalHUD];
    
    switch ([asynchroniousRequest tag])
    {
        case 1://Add Rec
        {
            
            NSLog(@"success");
            
            [[self.placesArray objectAtIndex:self.placeIndex] setIsAddedRec:YES];
            
            CustomPlaceDetailView *placeView = (CustomPlaceDetailView *)[self.placeDetailScrollView viewForRowAtIndex:self.placeIndex];
            [placeView updateRecsButtonTitle:@"- Rec"];
            
            
        }
            break;

        case 2://Remove Rec
        {
            
            NSLog(@"success");
            CustomPlaceDetailView *placeView = (CustomPlaceDetailView *)[self.placeDetailScrollView viewForRowAtIndex:self.placeIndex];
            [placeView updateRecsButtonTitle:@"+ Rec"];

            
        }
            break;

        case 3://Add TRY
        {
            
            NSLog(@"success");
            
        }
            break;

        case 4://Remove TRY
        {
            
            NSLog(@"success");
            
        }
            break;

        case 5://Get recommended places
        {
            self.recommendedPlacesArray = result[0];
            NSString *placeID = [[self.placesArray objectAtIndex:self.placeIndex] placeID];
            [self queryPlacesDetail:placeID];
            [self refreshPlaceModelWithRecs];
           
         
        }
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


-(void)refreshPlaceModelWithRecs{
    NSMutableString *predicateString = [NSMutableString string];
    
    [self.recommendedPlacesArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [predicateString appendFormat:@"self.placeID == '%@' OR ",obj[@"place_id"]];
    }];
    if (predicateString.length > 0) {
        NSString *finalPredicateString = [predicateString substringToIndex:predicateString.length-4];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:finalPredicateString];
        NSArray *tempArray  = [self.placesArray filteredArrayUsingPredicate:predicate];
        
        [tempArray makeObjectsPerformSelector:@selector(setIsAddedRecByNumber:) withObject:@(1)];
    }
   
    [self refreshPlace];
}
@end
