//
//  ViewController.m
//  EasyDrive365
//
//  Created by Fu Steven on 1/29/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"
#import "AppSettings.h"
#import "NavigationCell.h"
#import "Menu.h"
#import "MenuItem.h"
#import "HttpClient.h"




#import "InformationViewController.h"
#import "HelpCallViewController.h"
#import "AccidentRescueViewController.h"
#import "MaintainSuggestionViewController.h"
#import "DriverLicenseViewController.h"
#import "CarRegistrationViewController.h"
#import "TaxForCarShipViewController.h"
#import "CompulsoryInsuranceViewController.h"
#import "BusinessInsuranceViewController.h"
#import "InsuranceRecordsViewController.h"
#import "MaintainListViewController.h"
#import "BrowserViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    [self.tableview reloadData];
    
    [[HttpClient sharedHttp] online];
    
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self initView];
}
-(void)initView
{
   
    self.toolBarLogin.hidden = [AppSettings sharedSettings].isLogin;
    self.menuView.hidden = ![AppSettings sharedSettings].isLogin;
    //self.title = [AppSettings sharedSettings].firstName;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];
    
    //[self.tableview reloadData];
    
    
    
    //NSLog(@"local_data=%@",[AppSettings sharedSettings].local_data);
     
}
-(void)refresh:(id)sender
{
   /*
    NSString *path =[NSString stringWithFormat:@"admin/get_content?tablename=%@",@"Person_Test"];
    
    [[HttpClient sharedHttp] get:path];
    */
    [self logout];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setToolBarLogin:nil];

    [self setMenuView:nil];
    [self setTableview:nil];
    [super viewDidUnload];
}
- (IBAction)logout {
    [AppSettings sharedSettings].isLogin = FALSE;
    [[AppSettings sharedSettings] save];
    [self initView];
}


//Table view

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[Menu sharedMenu].list count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    NavigationCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
       // cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NavigationCell"  owner:self options:nil];
        cell =[nib objectAtIndex:0];
    }
    
    
   
    MenuItem *item = [[Menu sharedMenu].list objectAtIndex:indexPath.row];
    cell.titleLabel.text = item.title;
    cell.descriptionLabel.text = item.description;
   // cell.image.image =[UIImage imageNamed:item.imagePath];
    cell.phone = item.phone;
    cell.keyname = item.title;
    [cell getLatest];
   return cell;
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuItem *item = [[Menu sharedMenu].list objectAtIndex:indexPath.row];
    NSLog(@"Select %@",item.title);
    if ([item.name isEqualToString:@"001"]){
        InformationViewController *vc = [[InformationViewController alloc] initWithNibName:@"InformationViewController" bundle:nil];
        vc.title = item.title;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([item.name isEqualToString:@"002"]){
        HelpCallViewController *vc = [[HelpCallViewController alloc] initWithNibName:@"HelpCallViewController" bundle:nil];
        vc.title = item.title;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([item.name isEqualToString:@"003"]){
        AccidentRescueViewController *vc = [[AccidentRescueViewController alloc] initWithNibName:@"AccidentRescueViewController" bundle:nil];
        vc.title = item.title;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if ([item.name isEqualToString:@"004"]){
        MaintainSuggestionViewController *vc =[[MaintainSuggestionViewController alloc] initWithNibName:@"MaintainSuggestionViewController" bundle:nil];
        vc.title = item.title;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([item.name isEqualToString:@"005"]){
        DriverLicenseViewController *vc =[[DriverLicenseViewController alloc] initWithNibName:@"DriverLicenseViewController" bundle:nil];
        vc.title = item.title;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([item.name isEqualToString:@"006"]){
        CarRegistrationViewController *vc =[[CarRegistrationViewController alloc] initWithNibName:@"CarRegistrationViewController" bundle:nil];
        vc.title = item.title;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([item.name isEqualToString:@"007"]){
        TaxForCarShipViewController *vc = [[TaxForCarShipViewController alloc] initWithNibName:@"TaxForCarShipViewController" bundle:nil];
        vc.title = item.title;
        [self.navigationController pushViewController:vc animated:YES];

    }
    if ([item.name isEqualToString:@"008"]){
        CompulsoryInsuranceViewController *vc = [[CompulsoryInsuranceViewController alloc] initWithNibName:@"CompulsoryInsuranceViewController" bundle:nil];
        vc.title = item.title;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    if ([item.name isEqualToString:@"009"]){
        BusinessInsuranceViewController *vc = [[BusinessInsuranceViewController alloc] initWithNibName:@"BusinessInsuranceViewController" bundle:nil];
        vc.title = item.title;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    if ([item.name isEqualToString:@"010"]){
        InsuranceRecordsViewController *vc = [[InsuranceRecordsViewController alloc] initWithNibName:@"InsuranceRecordsViewController" bundle:nil];
        vc.title = item.title;
        [self.navigationController pushViewController:vc animated:YES];
        
    }

    if ([item.name isEqualToString:@"011"]){
        MaintainListViewController *vc = [[MaintainListViewController alloc] initWithNibName:@"MaintainListViewController" bundle:nil];
        vc.title = item.title;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    if ([item.name isEqualToString:@"000"]){
        BrowserViewController *vc = [[BrowserViewController alloc] initWithNibName:@"BrowserViewController" bundle:nil];
        
        [self.navigationController pushViewController:vc animated:YES];
        [vc go:@"http://www.baidu.com/"];
    }

}
@end
