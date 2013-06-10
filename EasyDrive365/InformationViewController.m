//
//  InformationViewController.m
//  EasyDrive365
//
//  Created by Fu Steven on 2/8/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "InformationViewController.h"

#import "AppSettings.h"
#import "InformationCell.h"
#import "BrowserViewController.h"
#import "PhoneView.h"
#import "Menu.h"

#import "InfromationDetailViewController.h"

@interface InformationViewController (){
    NSMutableArray *_list;
}

@end

@implementation InformationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self setupTableView:self.tableView];
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonSystemItemTrash target:self action:@selector(deleteInformation)];
    
}
-(void)deleteInformation{
    self.tableView.editing = YES;
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _list?[_list count]:0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentitifier = @"Cell";
    InformationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentitifier];
    if (cell == nil){
        //cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentitifier];
        cell =[[[NSBundle mainBundle] loadNibNamed:@"InformationCell" owner:nil options:nil] objectAtIndex:0];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    id item = [_list objectAtIndex:indexPath.row];
    
    cell.titleLabel.text=[NSString stringWithFormat:@"%@",[item objectForKey:@"fmt_createDate"]];
    cell.detailLabel.text=[NSString stringWithFormat:@"%@",[item objectForKey:@"description"]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id item = [_list objectAtIndex:indexPath.row];
    /*
    NSString *action = item[@"action"];
    
    [[[UIAlertView alloc] initWithTitle:@"action" message:action delegate:self cancelButtonTitle:nil otherButtonTitles:@"go" , nil] show ];
    */
    
    NSLog(@"%@",item);
    NSString *action =item[@"action"];
    NSString *url = item[@"url"];
    if (url && ![url isEqualToString:@""]){
        action=@"00";
    }
    if ([action isEqualToString:@"01"]){
        
        InfromationDetailViewController *vc = [[InfromationDetailViewController alloc] initWithNibName:@"InfromationDetailViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
        [vc loadInformation:item[@"id"]];
        return;
    }
    
    NSString *title = [[Menu sharedMenu] getTitleByKey:action];
    [[Menu sharedMenu] pushToController:self.navigationController key:action title:title url:url];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0){
        PhoneView *phoneView = [[[NSBundle mainBundle] loadNibNamed:@"PhoneView" owner:nil options:nil] objectAtIndex:0];
        [phoneView initWithPhone:_company phone:_phone];
        phoneView.backgroundColor = tableView.backgroundColor;
        return phoneView;
    }else{
        return nil;
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 80;
}

-(void)setup{
    _helper.url = [AppSettings sharedSettings].url_for_get_news;
}
-(void)processData:(id)json{
    NSLog(@"%@",json);
    if (_list){
        [_list removeAllObjects];
    }else{
        _list =[[NSMutableArray alloc] init];
    }
    [_list addObjectsFromArray:[json objectForKey:@"result"][@"data"]];
    _phone =json[@"result"][@"phone"];
    _company =json[@"result"][@"company"];
    [self.tableView reloadData];
    [self endRefresh:self.tableView];
}
-(void)responseError:(id)json{
    [self endRefresh:self.tableView];
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==UITableViewCellEditingStyleDelete){
        id item = [_list objectAtIndex:indexPath.row];
        NSString *url = [NSString stringWithFormat:@"api/del_news?userid=%d&newsid=%@",[AppSettings sharedSettings].userid,item[@"id"]];
        [[AppSettings sharedSettings].http get:url block:^(id json) {
            NSLog(@"%@",json);
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [cell removeFromSuperview];
        }];
        
        
    }
}
@end
