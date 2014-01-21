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
#import "GoodsListController.h"
#import "ProviderListController.h"
#import "ArticleListController.h"
#define TAG_HOMEPAGE 0
#define TAG_MAP 1
#define TAG_GOODS 2
#define TAG_PROVIDER 3
#define TAG_ARTICLE 4
#import "SignupStep1ViewController.h"


@interface ViewController ()<UITabBarDelegate,UIAlertViewDelegate>{
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(need_set:) name:NEED_SET object:nil];
    /*
    self.tabBar.delegate = self;
    UITabBarItem *item0=[[UITabBarItem alloc] initWithTitle:@"主页" image:[UIImage imageNamed:@"toolbar/zhuye.png"] tag:TAG_HOMEPAGE];
    UITabBarItem *item1=[[UITabBarItem alloc] initWithTitle:@"保险" image:[UIImage imageNamed:@"toolbar/baoxian.png"] tag:TAG_MAP];
    UITabBarItem *item2 =[[UITabBarItem alloc] initWithTitle:@"附近" image:[UIImage imageNamed:@"toolbar/shanghu.png"] tag:TAG_GOODS];
    UITabBarItem *item3 = [[UITabBarItem alloc] initWithTitle:@"百科" image:[UIImage imageNamed:@"toolbar/baike.png"] tag:TAG_PROVIDER];

    UITabBarItem *item4 = [[UITabBarItem alloc] initWithTitle:@"用户" image:[UIImage imageNamed:@"toolbar/yonghu.png"] tag:TAG_ARTICLE];

    
    [self.tabBar setItems:@[item0,item1,
     item2,
     item3,
     item4]];
    [self.tabBar setSelectedItem:nil];
     */
    
}
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSLog(@"%@",item);
    if (item.tag==TAG_MAP){//baoxian
        ShowLocationViewController *vc = [[ShowLocationViewController alloc] initWithNibName:@"ShowLocationViewController" bundle:nil];
        vc.isFull = YES;
        [self.navigationController pushViewController:vc animated:YES];
        

    }else if (item.tag==TAG_GOODS){
        ProviderListController *vc =[[ProviderListController alloc] initWithStyle:UITableViewStylePlain];
        [self.navigationController pushViewController:vc animated:YES];

//        GoodsListController *vc=[[GoodsListController alloc] initWithStyle:UITableViewStylePlain];
//        [self.navigationController pushViewController:vc animated:YES];
    }else if (item.tag==TAG_PROVIDER){
        ArticleListController *vc=[[ArticleListController alloc] initWithStyle:UITableViewStylePlain];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (item.tag==TAG_ARTICLE){
        [self settingsButtonPress:nil];
    }else if (item.tag==TAG_HOMEPAGE){
        //home page
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
        if (item.imagePath && ![item.imagePath isEqualToString:@""]){
            ((NavigationCell *)cell).imgeIcon.image = [UIImage imageNamed:item.imagePath];
        }
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

-(void)need_set:(NSNotification *)notification{
    NSString *message = [notification object];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:AppTitle message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
    [alertView show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1){
        SignupStep1ViewController *vc = [[SignupStep1ViewController alloc] initWithStyle:UITableViewStyleGrouped];
        vc.isFromHome = YES;
        [self.navigationController pushViewController:vc animated:YES];

    }
}
@end
