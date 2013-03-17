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

@interface ViewController (){
    NSMutableArray *_list;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注销" style:UIBarButtonSystemItemAction target:self action:@selector(refresh:)];
    
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle =[[NSAttributedString alloc] initWithString:@"下拉刷新"];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableview addSubview:refreshControl];
    
    [self.tableview reloadData];
    [self get_latest];
    
    [[HttpClient sharedHttp] online];
    
    
    
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
    if (!islogin){
        WelcomeViewController *vc = [[WelcomeViewController alloc] initWithNibName:@"WelcomeViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:NO];
        
    }
    
}

-(void)refresh:(id)sender
{
    [self logout];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
   

   
    [self setTableview:nil];
   
    [super viewDidUnload];
}
- (IBAction)logout {
    [AppSettings sharedSettings].isLogin = FALSE;
    [[AppSettings sharedSettings] save];
 
    WelcomeViewController *vc = [[WelcomeViewController alloc] initWithNibName:@"WelcomeViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:NO];
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

@end
