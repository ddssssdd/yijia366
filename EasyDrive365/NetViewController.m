//
//  NetViewController.m
//  EasyDrive365
//
//  Created by Fu Steven on 2/14/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "NetViewController.h"
#import "HttpClient.h"
#import "AppSettings.h"

@interface NetViewController ()

@end

@implementation NetViewController


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setup];
    [self loadData];
}
-(void)setup{
    
}
-(void)processData:(id)json{
    
}


-(void)loadData{
    /* test offline 
    id json= [[AppSettings sharedSettings] loadJsonBy:NSStringFromClass([self class])];
    [self processData:json];
    return;
    */
    
    //not setup _url;
    if (!_url){
        return;
    }
    [[HttpClient sharedHttp] get:_url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            
            [[AppSettings sharedSettings] saveJsonWith:NSStringFromClass( [self class]) data:json];
            [self processData:json];
            
        }else{
            //get nothing from server;
        }
    }];
}



@end
