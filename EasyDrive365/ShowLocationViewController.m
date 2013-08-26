//
//  ShowLocationViewController.m
//  EasyDrive366
//
//  Created by Fu Steven on 8/26/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "ShowLocationViewController.h"
#import "BMapKit.h"
@interface ShowLocationViewController ()<BMKMapViewDelegate>{
    BMKMapView *_mapView;
    BMKPointAnnotation* pointAnnotation;
}

@end

@implementation ShowLocationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     _mapView= [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    self.view = _mapView;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeNone;
    _mapView.showsUserLocation = YES;
    
    
    pointAnnotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = 39.915;
    coor.longitude = 116.404;
    pointAnnotation.coordinate = coor;
    pointAnnotation.title = @"test";
    pointAnnotation.subtitle = @"此Annotation可拖拽!";
    [_mapView addAnnotation:pointAnnotation];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate =nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)mapViewWillStartLocatingUser:(BMKMapView *)mapView{
    NSLog(@"Start locate...");
}
-(void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation{
    if (userLocation != nil) {
		NSLog(@"%f %f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
	}
}
-(void)mapViewDidStopLocatingUser:(BMKMapView *)mapView{
    NSLog(@"Stop locate.");
}
-(void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view{
    NSLog(@"pao");
}
@end
