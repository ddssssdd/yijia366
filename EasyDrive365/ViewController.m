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
#import "BusinessInsViewController.h"


//new
#import "MaintanViewController.h"


//test
#import "LoginTableViewController.h"
#import "SignUpTableViewController.h"

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
    
   
    //[self.navigationController setToolbarHidden:[AppSettings sharedSettings].isLogin];
    //self.toolBarLogin.hidden = [AppSettings sharedSettings].isLogin;
    [self.navigationController setNavigationBarHidden:![AppSettings sharedSettings].isLogin];
    
    self.tableview.hidden = ![AppSettings sharedSettings].isLogin;
    [AppSettings sharedSettings].userid = 65;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注销" style:UIBarButtonSystemItemAction target:self action:@selector(refresh:)];
    
    //[self.tableview reloadData];
    
    
    
    //NSLog(@"local_data=%@",[AppSettings sharedSettings].local_data);
     
}
-(void)refresh:(id)sender
{
    //LoginTableViewController *vc = [[LoginTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    //SignUpTableViewController *vc =[[SignUpTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    //[self.navigationController pushViewController:vc animated:YES];

   [self logout];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    //[self setToolBarLogin:nil];

   
    [self setTableview:nil];
    [self setImage:nil];
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
        //[cell getLatest];
        MenuItem *item = [[Menu sharedMenu].list objectAtIndex:indexPath.row];
        cell.titleLabel.text = item.title;
        cell.descriptionLabel.text = item.description;
        //cell.imageView.image =[UIImage imageNamed:item.imagePath];
        cell.phone = item.phone;
        cell.keyname = item.name;
        cell.dataLabel.text=@"";
        [cell getLatest];
    }
    
    
   /*
    MenuItem *item = [[Menu sharedMenu].list objectAtIndex:indexPath.row];
    cell.titleLabel.text = item.title;
    cell.descriptionLabel.text = item.description;
    //cell.imageView.image =[UIImage imageNamed:item.imagePath];
    cell.phone = item.phone;
    cell.keyname = item.name;
    cell.dataLabel.text=@"";
    [cell getLatest];
    */
   return cell;
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuItem *item = [[Menu sharedMenu].list objectAtIndex:indexPath.row];
    NSLog(@"Select %@",item.title);
    if ([item.name isEqualToString:@"01"]){
        InformationViewController *vc = [[InformationViewController alloc] initWithNibName:@"InformationViewController" bundle:nil];
        vc.title = item.title;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([item.name isEqualToString:@"02"]){
        HelpCallViewController *vc = [[HelpCallViewController alloc] initWithNibName:@"HelpCallViewController" bundle:nil];
        vc.title = item.title;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([item.name isEqualToString:@"03"]){
        AccidentRescueViewController *vc = [[AccidentRescueViewController alloc] initWithNibName:@"AccidentRescueViewController" bundle:nil];
        vc.title = item.title;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if ([item.name isEqualToString:@"04"]){
        //MaintainSuggestionViewController *vc =[[MaintainSuggestionViewController alloc] initWithNibName:@"MaintainSuggestionViewController" bundle:nil];
        MaintanViewController *vc = [[MaintanViewController alloc] initWithNibName:@"MaintanViewController" bundle:nil];
        vc.title = item.title;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([item.name isEqualToString:@"05"]){
        DriverLicenseViewController *vc =[[DriverLicenseViewController alloc] initWithNibName:@"DriverLicenseViewController" bundle:nil];
        vc.title = item.title;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([item.name isEqualToString:@"06"]){
        CarRegistrationViewController *vc =[[CarRegistrationViewController alloc] initWithNibName:@"CarRegistrationViewController" bundle:nil];
        vc.title = item.title;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([item.name isEqualToString:@"07"]){
        TaxForCarShipViewController *vc = [[TaxForCarShipViewController alloc] initWithNibName:@"TaxForCarShipViewController" bundle:nil];
        vc.title = item.title;
        [self.navigationController pushViewController:vc animated:YES];

    }
    if ([item.name isEqualToString:@"08"]){
        CompulsoryInsuranceViewController *vc = [[CompulsoryInsuranceViewController alloc] initWithNibName:@"CompulsoryInsuranceViewController" bundle:nil];
        vc.title = item.title;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    if ([item.name isEqualToString:@"09"]){
        BusinessInsViewController *vc = [[BusinessInsViewController alloc] initWithNibName:@"BusinessInsViewController" bundle:nil];
        vc.title = item.title;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    if ([item.name isEqualToString:@"10"]){
        InsuranceRecordsViewController *vc = [[InsuranceRecordsViewController alloc] initWithNibName:@"InsuranceRecordsViewController" bundle:nil];
        vc.title = item.title;
        [self.navigationController pushViewController:vc animated:YES];
        
    }

    if ([item.name isEqualToString:@"11"]){
        MaintainListViewController *vc = [[MaintainListViewController alloc] initWithNibName:@"MaintainListViewController" bundle:nil];
        vc.title = item.title;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    if ([item.name isEqualToString:@"00"]){
        BrowserViewController *vc = [[BrowserViewController alloc] initWithNibName:@"BrowserViewController" bundle:nil];
        
        [self.navigationController pushViewController:vc animated:YES];
        [vc go:@"http://www.baidu.com/"];
    }

}
- (IBAction)loginAction:(id)sender {
    LoginTableViewController *vc = [[LoginTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    //SignUpTableViewController *vc =[[SignUpTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)signupAction:(id)sender {
    //LoginTableViewController *vc = [[LoginTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    SignUpTableViewController *vc =[[SignUpTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
