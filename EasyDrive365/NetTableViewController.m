//
//  NetTableViewController.m
//  EasyDrive365
//
//  Created by Fu Steven on 2/27/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "NetTableViewController.h"

@interface NetTableViewController ()

@end

@implementation NetTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _helper = [[HttpHelper alloc] initWithTarget:self];
    [_helper loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setup{
    
}
-(void)processData:(id)json{
    
}

@end
