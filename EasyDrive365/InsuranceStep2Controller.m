//
//  InsuranceStep2Controller.m
//  EasyDrive366
//
//  Created by Steven Fu on 1/26/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import "InsuranceStep2Controller.h"
#import "AppSettings.h"
#import "InsuranceStep3Controller.h"

@interface InsuranceStep2Controller ()

@end

@implementation InsuranceStep2Controller

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)init_setup{
    _saveButtonName = @"下一步";
    
}
-(void)backTo{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)initData{
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"上一步" style:UIBarButtonSystemItemAction target:self action:@selector(backTo)];
    
    NSString *url = [NSString stringWithFormat:@"ins/carins_info?userid=%d",[AppSettings sharedSettings].userid];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        NSString *r_date = json[@"result"][@"registration_date"];
        if ([r_date length]>10){
            r_date = [r_date substringToIndex:10];
        }
        id items=@[
                   [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"car_id",@"label":@"车牌号：",@"default":@"",@"placeholder":@"鲁BFK982",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":json[@"result"][@"car_id"] }],
                   
                   [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"vin",@"label":@"VIN：",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":json[@"result"][@"vin"] }],
                   [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"engine_no",@"label":@"发动机号：",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":json[@"result"][@"engine_no"] }],
                   [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"registration_date",@"label":@"  初登日期：",@"default":@"",@"placeholder":@"DatePickerViewController",@"ispassword":@"no",@"cell":@"ChooseNextCell",@"value":r_date }],
                   [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"owner_name",@"label":@"车主姓名：",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":json[@"result"][@"owner_name"] }]
                   ];
        id items2=@[
                    [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"name",@"label":@"姓名：",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":json[@"result"][@"name"] }],
                    [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"license_id",@"label":@"身份证号：",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":json[@"result"][@"license_id"] }],
                    [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"phone",@"label":@"手机号：",@"default":@"",@"placeholder":@"",@"ispassword":@"number",@"cell":@"EditTextCell",@"value":json[@"result"][@"phone"] }]
                    ];
        _list=[NSMutableArray arrayWithArray: @[

                                                @{@"count" : @5,@"list":items,@"height":@44.0f},
                                                @{@"count" : @3,@"list":items2,@"height":@44.0f}
                                                ]];
        [self.tableView reloadData];
    }];
    
    self.title = @"第二步";
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0)
        return @"车辆基本信息";
    else
        return @"被保险人信息";
}
-(void)setupCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    [super setupCell:cell indexPath:indexPath];
}
-(void)processSaving:(NSMutableDictionary *)parameters{
    NSLog(@"%@",parameters);
    NSString *car_id=[parameters objectForKey:@"car_id"];
    if([@"" isEqualToString:car_id]){
        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"车牌号码不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
    }
    NSString *vin=[parameters objectForKey:@"vin"];
    if([@"" isEqualToString:car_id]){
         [[[UIAlertView alloc] initWithTitle:AppTitle message:@"车牌号码不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
         return;
        
    }
    NSString *engine_no=[parameters objectForKey:@"engine_no"];
    if([@"" isEqualToString:engine_no]){
        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"发动机号码不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
        
    }
    NSString *registration_date=[parameters objectForKey:@"registration_date"];
    if([@"" isEqualToString:registration_date]){
        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"初等日期不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
        
    }
    NSString *owner_name=[parameters objectForKey:@"owner_name"];
    if([@"" isEqualToString:owner_name]){
        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"车主姓名不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
        
    }
    NSString *name=[parameters objectForKey:@"name"];
    if([@"" isEqualToString:name]){
        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"被保险人姓名不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
        
    }
    
    NSString *license_id = [parameters objectForKey:@"license_id"];
    if([@"" isEqualToString:license_id]){
        
         [[[UIAlertView alloc] initWithTitle:@"提示" message:@"身份证号码不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"继续", nil] show];
         return;
        
    }else{
        if ([license_id length]!=18){
            [[[UIAlertView alloc] initWithTitle:@"易驾366" message:@"身份证号码必须18位" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
            return;
        }
        NSString *temp =[license_id stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
        NSLog(@"%@=%d",temp,[temp length]);
        if (([temp length]==0) || (([temp length]==1) && ([license_id hasSuffix:@"X"]))){
            
            
        }else{
            [[[UIAlertView alloc] initWithTitle:@"易驾366" message:@"身份证号码必须18位,只有最后一位允许是X" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
            return;
        }
    }
    NSString *phone=[parameters objectForKey:@"phone"];
    if([@"" isEqualToString:phone]){
         [[[UIAlertView alloc] initWithTitle:AppTitle message:@"手机号码不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
         return;
        
    }
    
    
    
    
    NSString *path =[NSString stringWithFormat:@"ins/carins_confirm?userid=%d&car_id=%@&vin=%@&engine_no=%@&registration_date=%@&owner_name=%@&name=%@&license_id=%@&phone=%@",[AppSettings sharedSettings].userid, car_id,vin,engine_no,registration_date,owner_name,name,license_id,phone];
    
    [[HttpClient sharedHttp] get:path block:^(id json) {
        NSLog(@"%@",json);
        if ([[AppSettings sharedSettings] isSuccess:json]){
            InsuranceStep3Controller *vc = [[InsuranceStep3Controller alloc] initWithStyle:UITableViewStyleGrouped];
            vc.car_data = json[@"result"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}
@end
