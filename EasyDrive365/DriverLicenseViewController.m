//
//  DriverLicenseViewController.m
//  EasyDrive365
//
//  Created by Fu Steven on 2/10/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "DriverLicenseViewController.h"
#import "LicenseTypeViewController.h"

@interface DriverLicenseViewController (){
    NSArray *_sections;
    NSArray *_items;
}

@end

@implementation DriverLicenseViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
   
    [self setTableView:nil];
    [super viewDidUnload];
}

-(void)initData{
    _sections=@[@"基本信息",@"计分情况",@"提醒"];
    _items=@[@[ @{@"name":@"证件号码",@"description":@"",@"vcname":@""},
                @{@"name":@"姓名",@"description":@"",@"vcname":@""},
                @{@"name":@"准驾车型",@"description":@"",@"vcname":@"LicenseTypeViewController"},
                @{@"name":@"初领日期",@"description":@"",@"vcname":@""}],
             @[ @{@"name":@"有效期限",@"description":@"",@"vcname":@""},
                @{@"name":@"计分到期日",@"description":@"",@"vcname":@""},
                @{@"name":@"计分情况",@"description":@"",@"vcname":@""}],
             @[@{@"name":@"提醒日期",@"description":@"",@"vcname":@""}]];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_sections count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[_items objectAtIndex:section] count];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [_sections objectAtIndex:section];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell=nil;
    cell =[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    id item =[[_items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = item[@"name"];
    cell.detailTextLabel.text = item[@"name"];
    NSLog(@"vcname=%@",item[@"vcname"]);
    if (![item[@"vcname"] isEqualToString:@""]){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id item =[[_items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSString *vcname=item[@"vcname"];
    if (![vcname isEqualToString:@""]){
        LicenseTypeViewController *vc = [[LicenseTypeViewController alloc] initWithNibName:vcname bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
