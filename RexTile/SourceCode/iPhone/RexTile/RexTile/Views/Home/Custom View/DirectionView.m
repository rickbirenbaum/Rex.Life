//
//  InnerView2.m
//  ComponentDemo
//
//  Created by Sweety Singh on 1/9/15.
//  Copyright (c) 2015 Perennial. All rights reserved.
//

#import "DirectionView.h"

@implementation DirectionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib{
  //  self.mapView.delegate = self;
  //  CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(37.323323, -117.434334);
    
   // [self setUpMapView:coord];
}

#pragma mark - MKMAPVIEW DELEGATES

/*
-(void)setUpMapView:(CLLocationCoordinate2D )locations{
    MKCoordinateRegion coordinateRegion;      //Creating a local variable
    coordinateRegion.center = locations;   //See notes below
    coordinateRegion.span.latitudeDelta = .01;
    coordinateRegion.span.longitudeDelta = .01;
    [self.mapView setRegion:coordinateRegion animated:YES];
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
*/
@end
