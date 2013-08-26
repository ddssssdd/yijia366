//
//  ShowLocationViewController.m
//  EasyDrive366
//
//  Created by Fu Steven on 8/26/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "ShowLocationViewController.h"
#import "BMapKit.h"
#import "AppSettings.h"
@interface ShowLocationViewController ()<BMKMapViewDelegate>{
    BMKMapView *_mapView;
    BMKPointAnnotation* pointAnnotation;
    CGFloat _lat;
    CGFloat _long;
    BOOL _hasLocation;
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
    _mapView.zoomLevel = 16;
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeNone;
    _mapView.showsUserLocation = YES;
    
    
    
    
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
        if (!_hasLocation){
            _hasLocation = !_hasLocation;
            [self showMineLocation:userLocation.location.coordinate.latitude longtitude:userLocation.location.coordinate.longitude];
        }
	}
}
-(void)mapViewDidStopLocatingUser:(BMKMapView *)mapView{
    NSLog(@"Stop locate.");
}
-(void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view{
    NSLog(@"pao");
}

-(void)goLocation:(CGFloat)latitude longtitude:(CGFloat)longtitude{
    _lat = latitude;
    _long = longtitude;
    pointAnnotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = _lat;
    coor.longitude = _long;
    pointAnnotation.coordinate = coor;
    pointAnnotation.title = @"test";
    pointAnnotation.subtitle = @"Detail information";

    [_mapView addAnnotation:pointAnnotation];
   
    [_mapView setCenterCoordinate:coor animated:YES];

}
-(void)createPin:(CGFloat)latitude longtitude:(CGFloat)longtitude title:(NSString *)title description:(NSString *)description{
    BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = latitude;
    coor.longitude = longtitude;
    annotation.coordinate = coor;
    annotation.title = title;
    annotation.subtitle = description;
    [_mapView addAnnotation:annotation];
}
-(void)showMineLocation:(CGFloat)latitude longtitude:(CGFloat)longtitude{
    CLLocationCoordinate2D coor;
    coor.latitude = latitude;
    coor.longitude = longtitude;

    [_mapView setCenterCoordinate:coor animated:YES];

    NSString *url =[NSString stringWithFormat:@"api/get_position?userid=%d&x=%f&y=%f&type=09",[AppSettings sharedSettings].userid,longtitude,latitude];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            for (id item  in json[@"result"]) {
                [self createPin:[item[@"y"] floatValue] longtitude:[item[@"x"] floatValue] title:item[@"name"] description:item[@"description"]];
            }
        }
    }];
}
@end
