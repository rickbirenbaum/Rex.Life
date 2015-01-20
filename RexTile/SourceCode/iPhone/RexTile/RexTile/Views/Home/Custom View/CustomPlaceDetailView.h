//
//  CustomPlaceDetailView.h
//  RexTile
//
//  Created by Sweety Singh on 12/29/14.
//  Copyright (c) 2014 Perennial. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "PHPageScrollView.h"
#import "GooglePlaceModel.h"



@interface CustomPlaceDetailView : UIView <UIScrollViewDelegate,MKMapViewDelegate,PHPageScrollViewDelegate, PHPageScrollViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *lblPlaceName;
@property (weak, nonatomic) IBOutlet UILabel *lblPlaceAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblDistance;

@property (weak, nonatomic) IBOutlet UIButton *btnCall;
@property (weak, nonatomic) IBOutlet UIButton *btnDirection;

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic)  IBOutlet UIView *contentView;

@property (readwrite, nonatomic) double placeLatitude;
@property (readwrite, nonatomic) double placeLongitude;

@property (nonatomic, strong)IBOutlet PHPageScrollView *pagingView;

@property (nonatomic, strong) GooglePlaceModel *placeDetailModel;

-(void)removeMap;
-(void)updateRecsButtonTitle:(NSString *)title;
-(void)updateTryButtonTitle:(NSString *)title;


-(void)getPhoneCallback:(void (^)(BOOL success))phoneCallBack;
-(void)getWebsiteCallback:(void (^)(BOOL success))websiteCallBack;
-(void)getRecListCallback:(void (^)(BOOL))recListCallBack;
-(void)getTryListCallback:(void (^)(BOOL))tryListCallBack;
-(void)getShareCallback:(void (^)(void))shareCallBack;




@end
