//
//  ViewController.m
//  EasyDrive365
//
//  Created by Fu Steven on 1/29/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "ViewController.h"
#import "HttpClient.h"
#import "AppSettings.h"
#import "NavigationCell.h"
#import "Menu.h"
#import "MenuItem.h"
#import "WelcomeViewController.h"
#import "SettingsViewController.h"
#import "ShowLocationViewController.h"


@interface ViewController ()<UITabBarDelegate>{
    NSMutableArray *_list;
    RefreshHelper *_helper;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
#endif
    self.title = AppTitle;
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    _helper =[[RefreshHelper alloc] initWithDelegate:self];
    [_helper setupTableView:self.tableview parentView:self.view];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonSystemItemAction target:self action:@selector(settingsButtonPress:)];
    /*
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle =[[NSAttributedString alloc] initWithString:@"下拉刷新"];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableview addSubview:refreshControl];
    */
    [self.tableview reloadData];
    [self get_latest];
    
    [[HttpClient sharedHttp] online];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNews:) name:@"NavigationCell_01" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:@"logout" object:nil];
    
    self.tabBar.delegate = self;
    
    UITabBarItem *item1=[[UITabBarItem alloc] initWithTitle:@"地图" image:[UIImage imageNamed:@"0087.png"] tag:0];
    //UITabBarItem *item2 =[[UITabBarItem alloc] initWithTitle:@"易驾百科" image:[UIImage imageNamed:@"0017.png"] tag:1];
    //UITabBarItem *item3 = [[UITabBarItem alloc] initWithTitle:@"帮助" image:[UIImage imageNamed:@"0085.png"] tag:2];
    [self.tabBar setItems:@[item1/*,
     item2,
     item3*/]];
    [self.tabBar setSelectedItem:nil];
    
}
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSLog(@"%@",item);
    if (item.tag==0){
        ShowLocationViewController *vc = [[ShowLocationViewController alloc] initWithNibName:@"ShowLocationViewController" bundle:nil];
        vc.isFull = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)getNews:(NSNotification *)noti{
    [_helper endRefresh:self.tableview];
}
-(void)loadData:(int)reload{
    [self get_latest];
}
-(void)get_latest
{
    [[AppSettings sharedSettings] get_latest];
    
}
-(void)handleRefresh:(UIRefreshControl *)sender{
    NSLog(@"i need to refresh! %@",[sender class]);
    [self get_latest];
    [sender endRefreshing];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    BOOL islogin = [AppSettings sharedSettings].isLogin;
    /*
    if (!islogin){
        WelcomeViewController *vc = [[WelcomeViewController alloc] initWithNibName:@"WelcomeViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:NO];
        
    }else{
        if ([AppSettings sharedSettings].isNeedRefresh){
            [[AppSettings sharedSettings] get_latest];
        }
    }
     */
    if (!islogin){
        [AppSettings sharedSettings].userid=-1;
        self.navigationItem.rightBarButtonItem.title = @"登录";
        
    }else{
        self.navigationItem.rightBarButtonItem.title = @"设置";
    }
    if ([AppSettings sharedSettings].isNeedRefresh){
        [[AppSettings sharedSettings] get_latest];
    }
    
    
}

-(void)settingsButtonPress:(id)sender
{
    
    BOOL islogin = [AppSettings sharedSettings].isLogin;
    if (!islogin){
        WelcomeViewController *vc = [[WelcomeViewController alloc] initWithNibName:@"WelcomeViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:NO];
        return;
    }
   
    SettingsViewController *vc = [[SettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:vc animated:YES];
    

}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0){
        [self logout];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
   
    [[NSNotificationCenter defaultCenter] removeObserver:self];
   
    [self setTableview:nil];
   
    [self setTabBar:nil];
    [super viewDidUnload];
}
- (IBAction)logout {
    [AppSettings sharedSettings].isLogin = FALSE;
    [AppSettings sharedSettings].userid = -1;
    [[AppSettings sharedSettings] save];
    /*
    WelcomeViewController *vc = [[WelcomeViewController alloc] initWithNibName:@"WelcomeViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:NO];
     */
}


//Table view

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[Menu sharedMenu].list count] +2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        if (indexPath.row>=[[Menu sharedMenu].list count]){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }else{
        
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NavigationCell"  owner:self options:nil];
            cell =[nib objectAtIndex:0];
            
        }
      
    }
    
    if (indexPath.row<[[Menu sharedMenu].list count]){
        MenuItem *item = [[Menu sharedMenu].list objectAtIndex:indexPath.row];
        ((NavigationCell *)cell).titleLabel.text = item.title;
        ((NavigationCell *)cell).keyname = item.name;
    }
     return cell;

   
    */
    if (indexPath.row>=[[Menu sharedMenu].list count]){
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        return cell;
    }else{
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NavigationCell"  owner:self options:nil];
        NavigationCell *cell =[nib objectAtIndex:0];
        MenuItem *item = [[Menu sharedMenu].list objectAtIndex:indexPath.row];
        ((NavigationCell *)cell).titleLabel.text = item.title;
        ((NavigationCell *)cell).keyname = item.name;
        cell.rootController = self.navigationController;
        return cell;
        
    }
    
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row>=[[Menu sharedMenu].list count]){
        return ;
    }
    MenuItem *item = [[Menu sharedMenu].list objectAtIndex:indexPath.row];
    NSLog(@"Select %@",item.title);
    [[Menu sharedMenu] pushToController:self.navigationController key:item.name title:item.title url:nil];
   

}

#pragma mark UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_helper.refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_helper.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

@end
