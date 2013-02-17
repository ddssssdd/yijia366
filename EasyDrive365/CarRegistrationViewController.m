//
//  CarRegistrationViewController.m
//  EasyDrive365
//
//  Created by Fu Steven on 2/10/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "CarRegistrationViewController.h"
#import "IllegallyListViewController.h"

@interface CarRegistrationViewController (){
    NSArray *_sections;
    NSArray *_items;
}

@end

@implementation CarRegistrationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)initData{
    _sections=@[@"基本信息",@"违章信息"];
    _items=@[@[ @{@"name":@"车牌号",@"description":@"",@"vcname":@""},
    @{@"name":@"发动机号",@"description":@"",@"vcname":@""},
    @{@"name":@"VIN",@"description":@"",@"vcname":@""},
    @{@"name":@"初登日期",@"description":@"",@"vcname":@""}],
    @[ @{@"name":@"违章查询",@"description":@"",@"vcname":@"IllegallyListViewController"}]
  ];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)get_illegally:(id)sender {
    IllegallyListViewController *vc =[[IllegallyListViewController alloc] initWithNibName:@"IllegallyListViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
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
        IllegallyListViewController *vc =[[IllegallyListViewController alloc] initWithNibName:@"IllegallyListViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];    }
}
@end
