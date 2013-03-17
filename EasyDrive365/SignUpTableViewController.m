//
//  SignUpTableViewController.m
//  EasyDrive365
//
//  Created by Fu Steven on 3/8/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "SignUpTableViewController.h"
#import "HttpClient.h"
#import "AppSettings.h"

@interface SignUpTableViewController ()

@end

@implementation SignUpTableViewController
-(void)init_setup{
    _saveButtonName = @"注册";
}

-(void)initData{
    id items=@[
    @{@"key" :@"username",@"label":@"用户名：",@"default":@"",@"placeholder":@"",@"ispassword":@"no" },
    @{@"key" :@"password",@"label":@"密码：",@"default":@"",@"placeholder":@"",@"ispassword":@"yes" },
    @{@"key" :@"repassword",@"label":@"再输一遍：",@"default":@"",@"placeholder":@"",@"ispassword":@"yes" }
    ];
    _list=[NSMutableArray arrayWithArray: @[
           @{@"count" : @1,@"cell":@"IntroduceCell",@"list":@[],@"height":@100.0f},
           @{@"count" : @3,@"cell":@"EditTextCell",@"list":items,@"height":@44.0f},
           //@{@"count" : @1,@"cell":@"OneButtonCell",@"list":@[],@"height":@44.0f}
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
    NSString *repassword = [parameters objectForKey:@"repassword"];
    if (![repassword isEqualToString:password]){
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"密码不匹配，请重新输入" delegate:self cancelButtonTitle:nil otherButtonTitles:@"继续", nil] show];
        return;
    }
  
    NSString *path =[NSString stringWithFormat:@"api/signup?username=%@&password=%@",username,password];
   
    [[HttpClient sharedHttp] get:path block:^(id json) {
        NSLog(@"%@",json);
        if (json){
            NSString *status =[json objectForKey:@"status"];
            if (status && [status isEqualToString:@"success"]){
                
                NSNumber *userid=[[json objectForKey:@"result"] objectForKey:@"id"];
                
                [[AppSettings sharedSettings] login:username userid:[userid intValue]];
                //[[AppSettings sharedSettings] login:username userid:65];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                //self.lblInfor.text = [json objectForKey:@"message"];
                [[[UIAlertView alloc] initWithTitle:@"提示" message:[json objectForKey:@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"继续", nil] show];
            }
        }
    }];
}

@end
