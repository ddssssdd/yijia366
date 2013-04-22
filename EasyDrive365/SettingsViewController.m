//
//  SettingsViewController.m
//  EasyDrive366
//
//  Created by Fu Steven on 4/20/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "SettingsViewController.h"
#import "OneButtonCell.h"
#import "EditTableViewController.h"
#import "MaintanViewController.h"
#import "DriverLicenseViewController.h"
#import "CarRegistrationViewController.h"

@interface SettingsViewController (){
    EditMaintainDataSource *_maintainDatasource;
    EditDriverLicenseDataSource *_driverDatasource;
    EditCarReigsterationDataSource *_carDatasource;
}

@end

@implementation SettingsViewController

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
    self.navigationItem.rightBarButtonItem = nil;
    
    _maintainDatasource = [[EditMaintainDataSource alloc] initWithData: [[AppSettings sharedSettings] loadJsonBy:@"maintain_data"]];
    
    _driverDatasource =[[EditDriverLicenseDataSource alloc] initWithData:[[AppSettings sharedSettings] loadJsonBy:@"license_data"]];
    
    _carDatasource =[[EditCarReigsterationDataSource alloc] initWithData:[[AppSettings sharedSettings] loadJsonBy:@"car_data"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initData{
    id items=@[
    [[NSMutableDictionary alloc] initWithDictionary:
     @{@"key" :@"password",
     @"label":@"新密码：",
     @"default":@"",
     @"placeholder":@"新密码",
     @"ispassword":@"yes",
     @"value":@"",
     @"cell":@"EditTextCell"  }],
    [[NSMutableDictionary alloc] initWithDictionary:
     @{@"key" :@"repassword",
     @"label":@"再输一遍：",
     @"default":@"",
     @"placeholder":@"再输一遍",
     @"ispassword":@"yes",
     @"value":@"",
     @"cell":@"EditTextCell"  }],
    [[NSMutableDictionary alloc] initWithDictionary:
     @{@"key" :@"reset_password",
     @"label":@"重设密码",
     @"default":@"",
     @"placeholder":
     @"",@"value":@"",
     @"cell":@"OneButtonCell" }]
    
    ];
    id items2=@[
    [[NSMutableDictionary alloc] initWithDictionary:
     @{@"key" :@"maintain",
        @"label":@"保养设置",
        @"default":@"",
        @"placeholder":@"",
        @"value":@"",
        @"cell":@"ChooseNextCell" }],
    [[NSMutableDictionary alloc] initWithDictionary:
        @{@"key" :@"driver",
        @"label":@"驾驶证",
        @"default":@"",
        @"placeholder":
        @"",@"value":@"",
        @"cell":@"ChooseNextCell" }],
    [[NSMutableDictionary alloc] initWithDictionary:
                                   @{@"key" :@"car_register",
                                   @"label":@"我的车辆",
                                   @"default":@"",
                                   @"placeholder":
                                   @"",@"value":@"",
                                   @"cell":@"ChooseNextCell" }]];
    id items3= @[
    [[NSMutableDictionary alloc] initWithDictionary:
     @{@"key" :@"logout",
     @"label":@"注销",
     @"default":@"0",
     @"placeholder":
     @"",@"value":@"",
     @"cell":@"OneButtonCell" }]];
    _list=[NSMutableArray arrayWithArray: @[
           @{@"count" : @1,@"list":@[@{@"cell":@"IntroduceCell"}],@"height":@100.0f,@"header":@"",@"footer":@""},
           @{@"count" : @3,@"list":items,@"height":@44.0f,@"header":@"重设密码",@"footer":@""},
           @{@"count" : @3,@"list":items2,@"height":@44.0f,@"header":@"我的车辆",@"footer":@""},
           @{@"count" : @1,@"list":items3,@"height":@44.0f,@"header":@"",@"footer":@""},
           ]];
}
-(void)setupCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    [super setupCell:cell indexPath:indexPath];
}
-(void)processSaving:(NSMutableDictionary *)parameters{
    NSLog(@"%@",parameters);
    
    NSString *username=[parameters objectForKey:@"username"];
    if([@"" isEqualToString:username]){
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名称不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
    }
    NSString *password = [parameters objectForKey:@"password"];
    if([@"" isEqualToString:password]){
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入有效密码" delegate:self cancelButtonTitle:nil otherButtonTitles:@"继续", nil] show];
        return;
    }
   
    
   
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==2){
        if (indexPath.row==0){
            EditTableViewController *vc = [[EditTableViewController alloc] initWithDelegate:_maintainDatasource];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row==1){
            EditTableViewController *vc =[[EditTableViewController alloc] initWithDelegate:_driverDatasource];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row==2){
            EditTableViewController *vc =[[EditTableViewController alloc] initWithDelegate:_carDatasource];
            [self.navigationController pushViewController:vc animated:YES];
        }
       
    }
    NSLog(@"%@",indexPath);
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}
-(void)buttonPress:(OneButtonCell *)sender{
    id item= [sender targetObject];
    if ([@"logout" isEqualToString:item[@"key"]]){
        [self.navigationController popViewControllerAnimated:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"logout" object:nil];
    
    }else if ([@"reset_password" isEqualToString:item[@"key"]]){
        //reset password;
        
    }
}

@end
