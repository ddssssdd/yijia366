//
//  NetViewController.m
//  EasyDrive365
//
//  Created by Fu Steven on 2/14/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "NetViewController.h"



@interface NetViewController ()

@end

@implementation NetViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    _helper =[[HttpHelper alloc] initWithTarget:self];
    [_helper loadData];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
  
}
-(void)setup{
    
}
-(void)processData:(id)json{
    
}

@end
