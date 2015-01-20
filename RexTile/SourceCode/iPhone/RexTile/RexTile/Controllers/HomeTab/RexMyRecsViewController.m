//
//  RexMyRecsViewController.m
//  RexTile
//
//  Created by Sweety Singh on 1/1/15.
//  Copyright (c) 2015 Perennial. All rights reserved.
//

#import "RexMyRecsViewController.h"
#import "RecommendationListWebServices.h"
#import <MapKit/MapKit.h>
#import "CustomRecsTableViewCell.h"
#import "iCarousel.h"
#import "CategoryView.h"
#import "RexLocationOverlayViewController.h"
#import "RexSettingsViewController.h"
#import "RexPlaceDetailViewController.h"

@interface RexMyRecsViewController ()<WebServiceDelegate, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, UISearchBarDelegate,iCarouselDataSource,iCarouselDelegate>
@property (nonatomic, strong) RecommendationListWebServices *recommendationWebService;

@property (nonatomic, strong) NSMutableArray *recsArray;
@property (nonatomic, strong) NSMutableArray *filteredRecsArray;

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet iCarousel *categoryCarousel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *categoryArray;

@property (strong, nonatomic) IBOutlet UIButton *btnCurrentLocation;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *btnLocationWidth;
@property (strong, nonatomic) IBOutlet UIImageView *categorybackgroundImage;

@end

@implementation RexMyRecsViewController
{
    CGFloat yOffset;
    BOOL isSearching;

    UITapGestureRecognizer *tapGesture;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    isSearching = NO;

    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
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
    self.navigationController.navigationBar.hidden = NO;

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"status_bar"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    self.filteredRecsArray = [[NSMutableArray alloc] init];
    [self.searchBar setBackgroundImage:[UIImage new]];
    [self fetchMyRecs];
    
    self.categoryArray = [NSMutableArray arrayWithObjects:@"food",@"shop",@"coffee",@"food 1",@"shop 1",@"coffee 2", nil];
    [self setUpCategoryView];
    [self setUpLocation];
    [self refreshMap];
}

-(void)refreshMap{
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([[[NSUserDefaults standardUserDefaults] objectForKey:UserChosenLatitude]doubleValue], [[[NSUserDefaults standardUserDefaults] objectForKey:UserChosenLongitude]doubleValue]);
    
    [self setUpMapView:coord];
    
}
-(void)setUpCategoryView{
    self.categoryCarousel.type = iCarouselTypeLinear;
    self.categoryCarousel.delegate = self;
    self.categoryCarousel.dataSource = self;
    self.categoryCarousel.contentOffset = CGSizeMake(([[UIScreen mainScreen] bounds].size.width-60)/2, 0);
   
    [self.categoryCarousel reloadData];
}
-(void)setUpLocation{
    
    
    CGFloat width = ceil([[[NSUserDefaults standardUserDefaults] objectForKey:UserChosenAddress] sizeWithAttributes:@{NSFontAttributeName:[self.btnCurrentLocation.titleLabel font]}].width);
    NSLog(@"Text widht %f",width);
    if (width > 270) {
        
        self.btnLocationWidth.constant = 280;
        [self.btnCurrentLocation setTitle:[NSString stringWithFormat:@" %@",[[NSUserDefaults standardUserDefaults] objectForKey:UserChosenAddress]] forState:UIControlStateNormal ];
        [self.btnCurrentLocation.layer setBorderColor:[UIColor whiteColor].CGColor];
        [self.btnCurrentLocation.layer setBorderWidth:1.0];
        self.btnCurrentLocation.layer.cornerRadius = 10.0;
        
    }else{
        
        width += 20 ;
        
        self.btnLocationWidth.constant = width;
        [self.btnCurrentLocation setTitle:[NSString stringWithFormat:@" %@",[[NSUserDefaults standardUserDefaults] objectForKey:UserChosenAddress]] forState:UIControlStateNormal ];
        [self.btnCurrentLocation.layer setBorderColor:[UIColor whiteColor].CGColor];
        [self.btnCurrentLocation.layer setBorderWidth:1.0];
        self.btnCurrentLocation.layer.cornerRadius = 10.0;
        self.btnCurrentLocation.layer.masksToBounds = YES;
        
    }
    
}

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
#pragma mark - WEBSERVICE CAll

-(void)fetchMyRecs{
    [MBProgressHUD showGlobalProgressHUDWithTitle:nil];
    self.recommendationWebService = [[RecommendationListWebServices alloc] init];
    self.recommendationWebService.tag =1;
    self.recommendationWebService.delegate = self;
    [self.recommendationWebService getMyRecs];
}

#pragma mark - UITABLEVIEW DELEGATES

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (isSearching) {
        
        return [self.filteredRecsArray count];
    }else{
        return [self.recsArray count];
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}





-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *CellIdentifier = @"RecsTableViewCell";
    CustomRecsTableViewCell *cell = (CustomRecsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[CustomRecsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
   // cell.selectionStyle=UITableViewCellSelectionStyleNone;
  //  cell.lblRecName.text = @"fhdjfhcdj dfhcdjkfhcdjkfc hdkfhcdjkfhdjk";
    GooglePlaceModel *placeModel;
    if (isSearching) {
        placeModel = [self.filteredRecsArray objectAtIndex:indexPath.row];
    }else{
        placeModel = [self.recsArray objectAtIndex:indexPath.row];
    }
        cell.lblRecName.text = placeModel.placeName;
        cell.lblRecDistance.text = placeModel.strDistance;
        cell.lblRecCount.text = [NSString stringWithFormat:@"Recommended by %d user",[placeModel.rec_recomended_users intValue]];
        cell.lblRecAddress.text = placeModel.placeAddress;
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:RextileStoryboard bundle:nil];
    
    RexPlaceDetailViewController *placeDetailView = (RexPlaceDetailViewController *)[storyBoard instantiateViewControllerWithIdentifier:PlaceDetailView];
    placeDetailView.placeIndex = indexPath.row;
    
    if (isSearching) {
        placeDetailView.placesArray = self.filteredRecsArray;
        
    }else{
        placeDetailView.placesArray = self.recsArray;
    }
   
    
    [self.navigationController pushViewController:placeDetailView animated:NO];

    
    
    
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    yOffset = scrollView.contentOffset.y;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < yOffset) {
        
        // scrolls down.
        yOffset = scrollView.contentOffset.y;
       // NSLog(@"scrolls down. %f",yOffset);
        if (yOffset <0) {
            
            [UIView animateWithDuration:0.2 animations:^{
                [self.tableView setFrame:CGRectMake(20, self.view.frame.size.height-70, self.tableView.frame.size.width, self.tableView.frame.size.height)];
            } completion:^(BOOL finished) {
               // [self.view bringSubviewToFront:self.mapView];
            }];
            
        }
    
    }
    else
    {
        //scrolls up.
        
        yOffset = scrollView.contentOffset.y;
       // NSLog(@"scrolls up. %f",yOffset);
        if (yOffset > 0) {
            [UIView animateWithDuration:0.2
                             animations:^{
                                 [self.tableView setFrame:CGRectMake(20, 200, self.tableView.frame.size.width, self.tableView.frame.size.height)];
                             }];
            
        }
        // Your Action goes here...
    }

    
}


#pragma mark - UISEARCHBAR DELEGATES
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self.searchBar becomeFirstResponder];
    if(searchBar.text.length == 0)
    {
        isSearching = NO;
        [self.filteredRecsArray removeAllObjects];
        [self.filteredRecsArray addObjectsFromArray:self.recsArray];
    }
    [self addTapGesture];
}// called when text starts editing
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    return YES;
}// return NO to not resign first responder
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;{
    // Call search
    //self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    if(tapGesture){
        [self.view removeGestureRecognizer:tapGesture];
        tapGesture=nil;
    }
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];

}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    
    if(searchText.length == 0)
    {
        isSearching = NO;
        [self.filteredRecsArray removeAllObjects];
        [self.filteredRecsArray addObjectsFromArray:self.recsArray];
    }
    else
    {
        isSearching = YES;
        [self.filteredRecsArray removeAllObjects];
        [self.tableView setFrame:CGRectMake(20, 200, self.tableView.frame.size.width, self.tableView.frame.size.height)];
        for (GooglePlaceModel *recModel in self.recsArray)
        {
            NSRange nameRange = [recModel.placeName rangeOfString:searchBar.text options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch)];
            if(nameRange.location != NSNotFound)
            {
                [self.filteredRecsArray addObject:recModel];
                NSLog(@"Filter %@",self.filteredRecsArray);
            }
        }
    }
    [self.tableView reloadData];
    
    
    
}

#pragma mark - MKMAPVIEW DELEGATES
-(void)setUpMapView:(CLLocationCoordinate2D )locations{
    MKCoordinateRegion coordinateRegion;      //Creating a local variable
    coordinateRegion.center = locations;   //See notes below
    coordinateRegion.span.latitudeDelta = .01;
    coordinateRegion.span.longitudeDelta = .01;
     [self.mapView setRegion:coordinateRegion animated:YES];
}
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"map Drag ");
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState
{
    NSLog(@"pin Drag");
    if (newState == MKAnnotationViewDragStateEnding) {
        // custom code when drag ends...
        CLLocationCoordinate2D droppedAt = annotationView.annotation.coordinate;
        NSLog(@"Pin dropped at %f,%f", droppedAt.latitude, droppedAt.longitude);
        // tell the annotation view that the drag is done
        [annotationView setDragState:MKAnnotationViewDragStateNone animated:YES];
    }
    
    else if (newState == MKAnnotationViewDragStateCanceling) {
        // custom code when drag canceled...
        
        // tell the annotation view that the drag is done
        [annotationView setDragState:MKAnnotationViewDragStateNone animated:YES];
    }
}

#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return [self.categoryArray count]+1;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    
    
    CategoryView *categoryView;
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CategoryView" owner:self options:nil];
    categoryView = [array objectAtIndex:0];
    if (index == 0) {
        [categoryView.btnCategoryCount setImage:[UIImage imageNamed:@"category_settings.png"] forState:UIControlStateNormal];
        [categoryView.btnCategoryCount setImage:[UIImage imageNamed:@"category_settings.png"] forState:UIControlStateHighlighted];
        categoryView.lblCategoryName.text = @"";
    }else{
        [categoryView.btnCategoryCount setTitle:@"25" forState:UIControlStateNormal];
        categoryView.lblCategoryName.text = [self.categoryArray objectAtIndex:index-1];
    }
    [categoryView.btnCategoryCount addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    return categoryView;

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

    NSLog(@"index %ld",(long)index);
    
}

#pragma mark -
#pragma mark Button tap event

- (void)buttonTapped:(UIButton *)sender
{
    //get item index for button
    NSInteger index = [self.categoryCarousel indexOfItemViewOrSubview:sender];
    
    
    if (index == 0) {
        
        [self.categoryCarousel scrollToItemAtIndex:self.categoryArray.count animated:YES];
    }else{
//        [[[UIAlertView alloc] initWithTitle:@"Button Tapped"
//                                    message:[NSString stringWithFormat:@"You tapped button number %i", index]
//                                   delegate:nil
//                          cancelButtonTitle:@"OK"
//                          otherButtonTitles:nil] show];
    }
}



#pragma mark - WEBSERVICE DELEGATES

-(void)request:(id)asynchroniousRequest didFinishWithResult:(NSArray *)result{
    
    [MBProgressHUD dismissGlobalHUD];
    
    switch ([asynchroniousRequest tag])
    {
        case 1://My Recs
        {
            
            NSLog(@"success %@",result);
            
            self.recsArray = [NSMutableArray arrayWithArray:result];
            [self.tableView reloadData];
            
            
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
