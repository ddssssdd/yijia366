//
//  InsuranceStep1Controller.m
//  EasyDrive366
//
//  Created by Steven Fu on 1/26/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import "InsuranceStep1Controller.h"
#import "AppSettings.h"
#import "InsuranceStep2Controller.h"


#import "InsuranceStep7Controller.h"

@interface InsuranceStep1Controller ()

@end

@implementation InsuranceStep1Controller

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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonSystemItemAction target:self action:@selector(nextStep)];
    [self load_data];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)load_data{
    NSString *url =[NSString stringWithFormat:@"ins/carins_intro?userid=%d",[AppSettings sharedSettings].userid];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            NSString *content_url = @"http://m.yijia366.com/html/20140123.htm";
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:content_url]]];
        }
    }];
}

-(void)nextStep{
    //InsuranceStep2Controller *vc =[[InsuranceStep2Controller alloc] initWithStyle:UITableViewStyleGrouped];
    
    InsuranceStep7Controller *vc =[[InsuranceStep7Controller alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
