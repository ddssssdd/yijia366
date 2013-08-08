//
//  SignupStep3ViewController.m
//  EasyDrive366
//
//  Created by Fu Steven on 8/6/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "SignupStep3ViewController.h"
#import "HttpClient.h"
#import "AppSettings.h"
#import "SignUpTableViewController.h"
@interface SignupStep3ViewController ()

@end

@implementation SignupStep3ViewController
-(void)init_setup{
    _saveButtonName = @"下一步";
}
-(void)initData{
    
    id items=@[
               [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"name",@"label":@"姓名：",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"EditTextCell",@"value":self.name }],
               [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"car_type",@"label":@"准驾车型：",@"default":@"",@"placeholder":@"",@"ispassword":@"capital",@"cell":@"ChooseNextCell",@"value":self.car_type }],
               [[NSMutableDictionary alloc] initWithDictionary:@{@"key" :@"init_date",@"label":@"初登日期：",@"default":@"",@"placeholder":@"DatePickerViewController",@"ispassword":@"no",@"cell":@"ChooseNextCell",@"value":self.car_init_date }]
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
    NSString *name=[parameters objectForKey:@"name"];
    NSString *car_type = [parameters objectForKey:@"car_type"];
    NSString *init_date = [parameters objectForKey:@"init_date"];
    /*
    
    if([@"" isEqualToString:name]){
        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"姓名不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
    }
    
    if([@"" isEqualToString:car_type]){
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"准驾车型不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"继续", nil] show];
        return;
    }
    
    if([@"" isEqualToString:init_date]){
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"初登日期不能为空！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"继续", nil] show];
        return;
    }
   
     */
    NSString *path =[NSString stringWithFormat:@"api/initstep3?userid=%d&name=%@&type=%@&init_date=%@",[AppSettings sharedSettings].userid,name,car_type,init_date];
    
    [[HttpClient sharedHttp] get:path block:^(id json) {
        NSLog(@"%@",json);
        if ([[AppSettings sharedSettings] isSuccess:json]){
            SignUpTableViewController *vc =[[SignUpTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            vc.username =json[@"result"][@"username"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

@end
