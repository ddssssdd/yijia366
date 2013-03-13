//
//  LoginTableViewController.m
//  EasyDrive365
//
//  Created by Fu Steven on 3/8/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "LoginTableViewController.h"
#import "HttpClient.h"
#import "AppSettings.h"


@implementation LoginTableViewController




-(void)initData{
    id items=@[
    @{@"key" :@"username",@"label":@"用户名：",@"default":@"",@"placeholder":@"",@"ispassword":@"no" },
    @{@"key" :@"password",@"label":@"密码：",@"default":@"",@"placeholder":@"",@"ispassword":@"yes" },
    
    ];
    _list=[NSMutableArray arrayWithArray: @[
           @{@"count" : @1,@"cell":@"IntroduceCell",@"list":@[],@"height":@100.0f},
           @{@"count" : @2,@"cell":@"EditTextCell",@"list":items,@"height":@44.0f},
           
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
    [self login:username password:password];

}

- (void)login:(NSString *)username password:(NSString *)password {
    //[self doLogin];
    NSString *path  =[NSString stringWithFormat:@"api/login?username=%@&password=%@",username,password];
    [[HttpClient sharedHttp] get:path block:^(id json) {
        if (json){
            NSString *status =[json objectForKey:@"status"];
            if (status && [status isEqualToString:@"success"]){
                //success login
                
                NSNumber *userid=[[json objectForKey:@"result"] objectForKey:@"id"];

                [[AppSettings sharedSettings] login:username userid:[userid intValue]];
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }else{
                //self.txtUsername.text = [json objectForKey:@"message"];
                [[[UIAlertView alloc] initWithTitle:@"提示" message:[json objectForKey:@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"继续", nil] show];
            }
        }
    }];
    
}
@end
