//
//  SignupStep2ViewController.m
//  EasyDrive366
//
//  Created by Fu Steven on 8/6/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "SignupStep2ViewController.h"
#import "HttpClient.h"
#import "AppSettings.h"
#import "SignupStep3ViewController.h"

@interface SignupStep2ViewController ()

@end

@implementation SignupStep2ViewController
-(void)init_setup{
    _saveButtonName = @"下一步";
}
-(void)initData{
    id items=@[
               [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"vin",@"label":@"VIN：",@"default":@"",@"placeholder":@"VIN",@"ispassword":@"no",@"cell":@"EditTextCell",@"value":self.vin }],
               [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"engine_no",@"label":@"发动机号：",@"default":@"",@"placeholder":@"",@"ispassword":@"no",@"cell":@"EditTextCell",@"value":self.engine_no }],
               [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"registration_date",@"label":@"初登日期：",@"default":@"",@"placeholder":@"DatePickerViewController",@"ispassword":@"no",@"cell":@"ChooseNextCell",@"value":self.registration_date }]
               ];
    _list=[NSMutableArray arrayWithArray: @[
           @{@"count" : @1,@"list":@[@{@"cell":@"IntroduceCell"}],@"height":@100.0f},
           @{@"count" : @3,@"list":items,@"height":@44.0f},
           //@{@"count" : @1,@"cell":@"OneButtonCell",@"list":@[],@"height":@44.0f}
           ]];
}
-(void)setupCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    [super setupCell:cell indexPath:indexPath];
}
-(void)processSaving:(NSMutableDictionary *)parameters{
    NSLog(@"%@",parameters);
    NSString *vin=[parameters objectForKey:@"vin"];
    if([@"" isEqualToString:vin]){
        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"VIN不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
    }
    NSString *engine_no = [parameters objectForKey:@"engine_no"];
    if([@"" isEqualToString:engine_no]){
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"发动机号不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"继续", nil] show];
        return;
    }
    NSString *registration_date = [parameters objectForKey:@"registration_date"];
    if([@"" isEqualToString:registration_date]){
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"初登日期不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"继续", nil] show];
        return;
    }
    /*
    SignupStep3ViewController *vc = [[SignupStep3ViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:vc animated:YES];
    return;
    */
    NSString *path =[NSString stringWithFormat:@"api/initstep2?userid=%d&vin=%@&engine_no=%@&registration_date=%@",[AppSettings sharedSettings].userid,vin,engine_no,registration_date];
    
    [[HttpClient sharedHttp] get:path block:^(id json) {
        NSLog(@"%@",json);
        if ([[AppSettings sharedSettings] isSuccess:json]){
            
            SignupStep3ViewController *vc = [[SignupStep3ViewController alloc] initWithStyle:UITableViewStyleGrouped];
            vc.name = json[@"result"][@"name"];
            vc.car_type =json[@"result"][@"car_type"];
            vc.car_init_date =json[@"result"][@"init_date"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}
@end