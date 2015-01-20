//
//  CustomPlaceDetailView.m
//  RexTile
//
//  Created by Sweety Singh on 12/29/14.
//  Copyright (c) 2014 Perennial. All rights reserved.
//

#import "CustomPlaceDetailView.h"
#import "AddressAnnotation.h"
#import "CallView.h"
#import "DirectionView.h"


@implementation CustomPlaceDetailView
{
    UIScrollView *localScrollView;
    UIView *localContentView;
    void (^phoneCallBlock)(BOOL) ;
    void (^websiteCallBlock)(BOOL) ;
    void (^recListCallBlock)(BOOL);
    void (^tryListCallBlock)(BOOL) ;
    void (^shareCallBlock)(void);
    
    AddressAnnotation *mapPinAnnotation;
    UISwipeGestureRecognizer *swipeRight, *swipeLeft;
    UITapGestureRecognizer *tapGesture;
    CGRect rectForMap;
    CallView *view1;
    DirectionView *view2;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)init{
     self = [super init];
    if (self) {
        // Custom initialization
    
    }
    return self;
}


-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
 
       
        
    }
    return self;
}



-(void)setPlaceDetailModel:(GooglePlaceModel *)placeDetailModel{
    if(_placeDetailModel!=placeDetailModel){
        _placeDetailModel=placeDetailModel;
        [self refreshUI];
    }
}


-(void)refreshUI{
//    rectForMap=view2.mapView.frame;
//    
//    [view2.mapView removeFromSuperview];
//    view2.mapView=nil;
    [self.pagingView reloadData];

}
-(void)awakeFromNib{
    if(IS_IPHONE_5){
        self.scrollView.contentInset=UIEdgeInsetsMake(0, 0, 0, 0);
    }else{
         self.scrollView.contentInset=UIEdgeInsetsMake(0, 0, 50, 0);
    }
    self.pagingView.delegate = self;
    self.pagingView.dataSource = self;
   
    //[self.pagingView reloadData];
   
    [self setUpConstraints];
    

    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

-(void)getPhoneCallback:(void (^)(BOOL success))phoneCallBack{
    phoneCallBlock = phoneCallBack;
}
-(void)getWebsiteCallback:(void (^)(BOOL success))websiteCallBack{
    websiteCallBlock = websiteCallBack;
}

-(void)getRecListCallback:(void (^)(BOOL))recListCallBack{
    recListCallBlock = recListCallBack;
}
-(void)getTryListCallback:(void (^)(BOOL))tryListCallBack{
    tryListCallBlock = tryListCallBack;
}
-(void)getShareCallback:(void (^)(void))shareCallBack{
    shareCallBlock = shareCallBack;
}


-(void)setUpConstraints{
    
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    localScrollView = self.scrollView;
    localContentView = self.contentView;
    NSDictionary* viewDict = NSDictionaryOfVariableBindings(localScrollView,localContentView);
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[localScrollView]|" options:0 metrics:0 views:viewDict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[localScrollView]|" options:0 metrics:0 views:viewDict]];
    
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[localContentView]|" options:0 metrics:0 views:viewDict]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[localContentView]|" options:0 metrics:0 views:viewDict]];
    
}
-(IBAction)callButtonClicked:(id)sender{
    phoneCallBlock(YES);
}
-(IBAction)websiteButtonClicked:(id)sender{
    websiteCallBlock(YES);
}
- (IBAction)recListClicked:(id)sender {
    if ([view1.btnRecList.titleLabel.text isEqualToString:@"+ Rec"]) {
        recListCallBlock(YES);
    }else{
        recListCallBlock(NO);
    }
    
}
- (IBAction)tryListClicked:(id)sender {
    tryListCallBlock(YES);
}
- (IBAction)shareClicked:(id)sender {
    shareCallBlock();
}
- (IBAction)directionClicked:(id)sender {
    
    [self.pagingView scrollToPage:1 animation:YES];
   
}

-(void)updateRecsButtonTitle:(NSString *)title{
    [view1.btnRecList setTitle:title forState:UIControlStateNormal];
}
-(void)updateTryButtonTitle:(NSString *)title{
    [view1.btnTryList setTitle:title forState:UIControlStateNormal];
}

#pragma mark - MKMAPVIEW DELEGATES

-(void)setUpMapView:(CLLocationCoordinate2D )locations{
    
    [view2.mapView removeAnnotation:mapPinAnnotation];
    
    
    mapPinAnnotation = [[AddressAnnotation alloc] initWithCoordinate:locations];
    //    tempuserLocationAnnotation.coordinate = coOrdinates;
    //    self.userLocationAnnotation = tempuserLocationAnnotation;
    mapPinAnnotation.title =_placeDetailModel.placeName;
    // tempuserLocationAnnotation.title =self.searchLocationText.text;
    
    [view2.mapView  addAnnotation:mapPinAnnotation];
     view2.mapView.delegate = self;
    
    
    MKCoordinateRegion coordinateRegion;      //Creating a local variable
    coordinateRegion.center = locations;   //See notes below
    coordinateRegion.span.latitudeDelta = .01;
    coordinateRegion.span.longitudeDelta = .01;
    
    
    [view2.mapView setRegion:coordinateRegion animated:YES];
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






#pragma mark - PHPageScrollViewDelegate

- (NSInteger)numberOfPageInPageScrollView:(PHPageScrollView*)pageScrollView
{
    return 2;
}

- (CGSize)sizeCellForPageScrollView:(PHPageScrollView*)pageScrollView
{
               
    return CGSizeMake(280, 278);
}

- (UIView*)pageScrollView:(PHPageScrollView*)pageScrollView viewForRowAtIndex:(int)index
{
  //  NSLog(@"model %@",self.placeDetailModel);
    switch (index%2) {
        case 0:{
            
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CallView" owner:nil options:nil];
            view1 = [array objectAtIndex:0];
             [view1.btnPhoneNo setTitle:self.placeDetailModel.placePhoneNo forState:UIControlStateNormal];
            [self setUpCallView];
            return view1;
        }
            break;
        case 1:{
            
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"DirectionView" owner:nil options:nil];
            view2 = [array objectAtIndex:0];
            
            return view2;
        }
            break;
        default:
            return nil;
            break;
    }
    
}

-(void)removeMap{
    [view2.mapView removeFromSuperview];
    view2.mapView=nil;
}
- (void)pageScrollView:(PHPageScrollView*)pageScrollView willScrollToPageAtIndex:(NSInteger)index{
    if (index == 1) {
        view2.mapView = [[MKMapView alloc]initWithFrame:view2.bounds];
        [view2 addSubview:view2.mapView];
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(self.placeLatitude, self.placeLongitude);
        [self setUpMapView:coord];
    }
}

-(void)setUpCallView{
    if (self.placeDetailModel.placePhoneNo) {
           [view1.btnPhoneNo setTitle:self.placeDetailModel.placePhoneNo forState:UIControlStateNormal];
           [view1.btnPhoneNo addTarget:self action:@selector(callButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (self.placeDetailModel.placeWebsite) {
           [view1.btnWebsite setTitle:self.placeDetailModel.placeWebsite forState:UIControlStateNormal];
           [view1.btnWebsite addTarget:self action:@selector(websiteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
  
//    if (self.placeDetailModel.isAddedRec) {
//        [view1.btnRecList setTitle:@"- Rec" forState:UIControlStateNormal];
//    }else{
//        [view1.btnRecList setTitle:@"+ Rec" forState:UIControlStateNormal];
//    }
    
    if (self.placeDetailModel.openHours) {
        // Setting text of open hours for the place
        
         view1.lblMonday.text = [NSString stringWithFormat:@"Mon   %@",[self getOpenHoursStr:[self.placeDetailModel.openHours objectAtIndex:0]]];
         view1.lblTuesday.text =[NSString stringWithFormat:@"Tue     %@",[self getOpenHoursStr:[self.placeDetailModel.openHours objectAtIndex:1]]];
         view1.lblWednesday.text =[NSString stringWithFormat:@"Wed   %@",[self getOpenHoursStr:[self.placeDetailModel.openHours objectAtIndex:2]]];
         view1.lblThursday.text =[NSString stringWithFormat:@"Thu    %@",[self getOpenHoursStr:[self.placeDetailModel.openHours objectAtIndex:3]]];
         view1.lblFriday.text =[NSString stringWithFormat:@"Fri      %@",[self getOpenHoursStr:[self.placeDetailModel.openHours objectAtIndex:4]]];
         view1.lblSaturday.text =[NSString stringWithFormat:@"Sat     %@",[self getOpenHoursStr:[self.placeDetailModel.openHours objectAtIndex:5]]];
         view1.lblSunday.text =[NSString stringWithFormat:@"Sun    %@",[self getOpenHoursStr:[self.placeDetailModel.openHours objectAtIndex:6]]];
         
         }
    
    if (self.placeDetailModel.category) {
          [self setUpCategoryView:self.placeDetailModel.category andView:view1.categoryView];
    }
    [view1.btnRecList addTarget:self action:@selector(recListClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view1.btnTryList addTarget:self action:@selector(tryListClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view1.btnShare addTarget:self action:@selector(shareClicked:) forControlEvents:UIControlEventTouchUpInside];

}
-(NSString *)getOpenHoursStr:(NSString *)str{
    
    return [[str componentsSeparatedByString:@": "] objectAtIndex:1];
    
}



/**
 To set up the category views depending upon the width of category text
 */
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
        
        label.layer.cornerRadius = 9.0;
        label.clipsToBounds = YES;
        label.font = Helvetica_RegularWithSize(13.0);//[UIFont systemFontOfSize:12.0];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = UIColorFromRGB(255, 255, 255, 0.4);
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
        
        label.frame = CGRectMake(currentX, currentY, width, 18.0);
        currentX += width+5;
        
    }
    
}

@end
