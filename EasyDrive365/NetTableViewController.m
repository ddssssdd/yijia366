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

    _refreshHelper = [[RefreshHelper alloc] initWithDelegate:self];
    [_refreshHelper setupTableView:self.tableView parentView:self.view];
     self.clearsSelectionOnViewWillAppear = NO;
    _helper = [[HttpHelper alloc] initWithTarget:self];
    [_helper restoreData];
    [_helper loadData];
    /*
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"phone_Blue.png"] style:UIBarButtonItemStylePlain target:self action:@selector(makePhone:)];
     */
    
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
-(void)makePhone:(id)sender{
    
}
-(void)loadData:(int)reload{
    [_helper loadData:reload];
}

#pragma mark UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_refreshHelper.refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_refreshHelper.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}
@end
