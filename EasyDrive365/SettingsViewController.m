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
#import "HttpClient.h"
#import "AppSettings.h"
#import "ButtonViewController.h"
#import "ResetPasswordViewController.h"

@interface SettingsViewController ()<ButtonViewControllerDelegate>{
    EditMaintainDataSource *_maintainDatasource;
    EditDriverLicenseDataSource *_driverDatasource;
    EditCarReigsterationDataSource *_carDatasource;
    ButtonViewController *logoutView;
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
    self.title = @"设置";
    
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
     @{@"key" :@"version",
     @"label":@"版本号",
     @"default":@"",
     @"placeholder":@"",
     @"ispassword":@"",
     @"value":@"V1.01",
     @"cell":@"default"  }]
    
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
    ;
    id items3= @[
    [[NSMutableDictionary alloc] initWithDictionary:
     @{@"key" :@"car_register",
     @"label":@"重设密码",
     @"default":@"",
     @"placeholder":
     @"",@"value":@"",
     @"cell":@"ChooseNextCell" }]];
    _list=[NSMutableArray arrayWithArray: @[
           @{@"count" : @1,@"list":@[@{@"cell":@"IntroduceCell"}],@"height":@100.0f,@"header":@"",@"footer":@""},
           
           @{@"count" : @3,@"list":items2,@"height":@44.0f,@"header":@"我的车辆",@"footer":@""},
           @{@"count" : @1,@"list":items3,@"height":@44.0f,@"header":@"",@"footer":@""},
           @{@"count" : @1,@"list":items,@"height":@44.0f,@"header":@"",@"footer":@""},
           ]];
}
-(void)setupCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    [super setupCell:cell indexPath:indexPath];
}
-(void)processSaving:(NSMutableDictionary *)parameters{
    NSLog(@"%@",parameters);
    
    
    NSString *password = [parameters objectForKey:@"password"];
    if([@"" isEqualToString:password]){
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入有效密码" delegate:self cancelButtonTitle:nil otherButtonTitles:@"继续", nil] show];
        return;
    }
    NSString *repassword=[parameters objectForKey:@"repassword"];
    if(![password isEqualToString:repassword]){
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"密码不匹配，请重新输入" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
    }
    
    [[HttpClient sharedHttp] get:[[AppSettings sharedSettings] url_change_password:password]  block:^(id json) {
        //
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"密码修改成功！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
    }];
    
   
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==1){
        if (indexPath.row==0){
            [self open_maintain_setup];
        }else if (indexPath.row==1){
            [self open_driver_setup];
        }else if (indexPath.row==2){
            [self open_car_setup];
        }
       
    }else if (indexPath.section==2){
        if (indexPath.row==0){
            ResetPasswordViewController *vc = [[ResetPasswordViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    NSLog(@"%@",indexPath);
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}
-(void)open_maintain_setup{
    NSString *url =[[AppSettings sharedSettings] url_for_get_maintain_record];
    [[HttpClient sharedHttp] get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            id temp=[json objectForKey:@"result"][@"data"];
            
            NSLog(@"%@",temp);
            NSEnumerator *enumerator =[temp keyEnumerator];
            id key;
            id result = [[NSMutableDictionary alloc] init];
            while ((key=[enumerator nextObject])) {
                id value = [temp objectForKey:key];
                if ([value isKindOfClass:[NSNull class]]){
                    [result setObject:@"" forKey:key];
                    
                }else{
                    [result setObject:value?value:@"" forKey:key];
                }
            }
            _maintainDatasource = [[EditMaintainDataSource alloc] initWithData:result];
            EditTableViewController *vc = [[EditTableViewController alloc] initWithDelegate:_maintainDatasource];
            [self.navigationController pushViewController:vc animated:YES];
        }
       
    }];
}
-(void)open_driver_setup{
    NSString *url =[[AppSettings sharedSettings] url_get_driver_license];
    [[HttpClient sharedHttp] get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            id result=[json objectForKey:@"result"][@"data"];
            
            
            _driverDatasource = [[EditDriverLicenseDataSource alloc] initWithData:result];
            EditTableViewController *vc = [[EditTableViewController alloc] initWithDelegate:_driverDatasource];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }];
}
-(void)open_car_setup{
    NSString *url =[[AppSettings sharedSettings] url_get_car_registration];
    [[HttpClient sharedHttp] get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            id result=[json objectForKey:@"result"][@"data"];
            
            
            _carDatasource = [[EditCarReigsterationDataSource alloc] initWithData:result];
            EditTableViewController *vc = [[EditTableViewController alloc] initWithDelegate:_carDatasource];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }];
}
-(void)buttonPress:(OneButtonCell *)sender{
    id item= [sender targetObject];
    if ([@"logout" isEqualToString:item[@"key"]]){
        [self.navigationController popViewControllerAnimated:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"logout" object:nil];
    
    }else if ([@"reset_password" isEqualToString:item[@"key"]]){
        //reset password;
        [self done];
    }
}
-(void)buttonPressed:(NVUIGradientButton *)button{
    [self.navigationController popViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"logout" object:nil];
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==3){
        if (!logoutView){
            logoutView = [[ButtonViewController alloc] initWithNibName:@"ButtonViewController" bundle:nil];
            NSLog(@"%@",logoutView.button);
            logoutView.buttonText=[NSString stringWithFormat:@"注销--%@",[AppSettings sharedSettings].firstName];
            logoutView.delegate = self;
            logoutView.buttonType =1;
        }
        return logoutView.view;
    }else{
        return nil;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==3){
        return 80;
    }else{
        return 22;
    }
    
}
@end
