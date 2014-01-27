//
//  InsuranceStep3Controller.m
//  EasyDrive366
//
//  Created by Steven Fu on 1/26/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import "InsuranceStep3Controller.h"
#import "InsuranceStep4Controller.h"
#import "AppSettings.h"

@interface InsuranceStep3Controller ()

@end

@implementation InsuranceStep3Controller

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
    
    id items=@[
               [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"brand",@"label":@"品牌型号：",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"default",@"value":self.car_data[@"brand"] }],
               
               [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"model",@"label":@"车款：",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"default",@"value":self.car_data[@"model"] }],
               [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"exhause",@"label":@"排气量：",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"default",@"value":self.car_data[@"exhause"] }],
               [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"gear",@"label":@"排挡：",@"default":@"",@"placeholder":@"DatePickerViewController",@"ispassword":@"no",@"cell":@"default",@"value":self.car_data[@"gear"] }],
               [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"price",@"label":@"参考价格：",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"default",@"value":self.car_data[@"price"] }]
               ];
    id items2=@[
                [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"biz_valid",@"label":@"商业险起期：",@"default":@"",@"placeholder":@"DatePickerViewController",@"ispassword":@"no",@"cell":@"ChooseNextCell",@"value":self.car_data[@"biz_valid"] }],
                [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"com_valid",@"label":@"交强险起期：",@"default":@"",@"placeholder":@"DatePickerViewController",@"ispassword":@"no",@"cell":@"ChooseNextCell",@"value":self.car_data[@"com_valid"] }]
                ];
    _list=[NSMutableArray arrayWithArray: @[
                                            
                                            @{@"count" : @5,@"list":items,@"height":@44.0f},
                                            @{@"count" : @2,@"list":items2,@"height":@44.0f}
                                            ]];
    [self.tableView reloadData];
    
    self.title = @"第三步";
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0)
        return @"车辆基本信息-确认";
    else
        return @"上年保险";
}
-(void)setupCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    [super setupCell:cell indexPath:indexPath];
}
-(void)processSaving:(NSMutableDictionary *)parameters{
    NSLog(@"%@",parameters);
    
    NSString *biz_valid=[parameters objectForKey:@"biz_valid"];
    if([@"" isEqualToString:biz_valid]){
        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"商业险起期不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
        
    }
    NSString *com_valid=[parameters objectForKey:@"com_valid"];
    if([@"" isEqualToString:com_valid]){
        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"交强险起期不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
        
    }
   
    
    
    NSString *path =[NSString stringWithFormat:@"ins/carins_clause?userid=%d&biz_valid=%@&com_valid=%@",[AppSettings sharedSettings].userid,biz_valid,com_valid];
    
    [[HttpClient sharedHttp] get:path block:^(id json) {
        NSLog(@"%@",json);
        if ([[AppSettings sharedSettings] isSuccess:json]){
            InsuranceStep4Controller *vc = [[InsuranceStep4Controller alloc] initWithStyle:UITableViewStyleGrouped];
            vc.insurance_data = json[@"result"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}
@end
