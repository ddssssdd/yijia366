//
//  NetViewController.m
//  EasyDrive365
//
//  Created by Fu Steven on 2/14/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "NetViewController.h"
#import "NVUIGradientButton.h"



@interface NetViewController (){
   
}

@end

@implementation NetViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    _helper =[[HttpHelper alloc] initWithTarget:self];
    [_helper restoreData];
    [_helper loadData];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
  
}
-(void)setup{
    
}
-(void)processData:(id)json{
    
}
-(void)makePhone:(id)sender{
    if (_phone && ![_phone isEqualToString:@""]){
        NSString *phoneNumber = [@"tel://" stringByAppendingString:_phone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    }
}
-(void)setupTableView:(UITableView *)tableView{
    if (_refreshHeaderView==nil){
        EGORefreshTableHeaderView *view =[[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f-tableView.bounds.size.height, self.view.frame.size.width, tableView.bounds.size.height)];
        view.delegate = self;
        [tableView addSubview:view];
        _refreshHeaderView = view;
        
    }
    [_refreshHeaderView refreshLastUpdatedDate];
}
-(void)endRefresh:(UITableView *)tableView{
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:tableView];
}
#pragma mark UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}
#pragma mark EGORefreshTableHeaderViewDelegate
-(void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view{
    [_helper loadData];
}
-(BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view{
    return _reloading;
}
-(NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view{
    return [NSDate date];
}
@end
