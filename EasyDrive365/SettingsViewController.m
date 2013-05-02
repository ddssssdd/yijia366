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
#import "BindCellPhoneViewController.h"

@interface SettingsViewController ()<ButtonViewControllerDelegate>{
    EditMaintainDataSource *_maintainDatasource;
    EditDriverLicenseDataSource *_driverDatasource;
    EditCarReigsterationDataSource *_carDatasource;
    ButtonViewController *logoutView;
    NSString *_phone;
    NSString *_phoneStatus;
    int isbind;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initData) name:@"Update_settings" object:nil];
}
-(void)viewDidUnload{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initData{
    NSString *url = [NSString stringWithFormat:@"api/get_user_phone?userid=%d",[AppSettings sharedSettings].userid];
     _phoneStatus = @"绑定手机";
    _phone = @"";
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            _phone=json[@"result"][@"phone"];
            isbind = 1;
            if ([json[@"result"][@"status"] isEqual:@"02"]){
                _phoneStatus = @"解除绑定";
                isbind = 0;
        
            }            
        }
        [self init_dataSource];
    }];
    
    
}
-(void)init_dataSource{
    id items=@[
    [[NSMutableDictionary alloc] initWithDictionary:
     @{@"key" :@"version",
     @"label":@"版本号",
     @"default":@"",
     @"placeholder":@"",
     @"ispassword":@"",
     @"value":[NSString stringWithFormat:@"V%@",AppVersion],
     @"cell":@"ChooseNextCell"  }]
    
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
     @"cell":@"ChooseNextCell" }],
    [[NSMutableDictionary alloc] initWithDictionary:
     @{@"key" :@"cellphone",
     @"label":_phoneStatus,
     @"default":@"",
     @"placeholder":@"",
     @"ispassword":@"",
     @"value":_phone,
     @"cell":@"ChooseNextCell"  }]];
    _list=[NSMutableArray arrayWithArray: @[
           @{@"count" : @1,@"list":@[@{@"cell":@"IntroduceCell"}],@"height":@100.0f,@"header":@"",@"footer":@""},
           
           @{@"count" : @3,@"list":items2,@"height":@44.0f,@"header":@"我的车辆",@"footer":@""},
           @{@"count" : @2,@"list":items3,@"height":@44.0f,@"header":@"",@"footer":@""},
           @{@"count" : @1,@"list":items,@"height":@44.0f,@"header":@"",@"footer":@""},
           ]];
    [self.tableView reloadData];
}
-(void)setupCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    [super setupCell:cell indexPath:indexPath];
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
        }else if (indexPath.row==1){
            BindCellPhoneViewController *vc =[[BindCellPhoneViewController alloc] initWithStyle:UITableViewStyleGrouped];
            vc.isbind = isbind;
            vc.phone = _phone;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (indexPath.section==3){
        if (indexPath.row==0){
            [AppSettings sharedSettings].isCancelUpdate = NO;
            [[AppSettings sharedSettings] check_update:YES];
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
