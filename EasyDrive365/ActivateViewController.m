//
//  ActivateViewController.m
//  EasyDrive366
//
//  Created by Fu Steven on 8/6/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "ActivateViewController.h"
#import "AppSettings.h"
#import "ShowActivateViewController.h"
@interface ActivateViewController ()

@end

@implementation ActivateViewController

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
    self.buttonOK.text =@"激活账户";
    self.title = @"激活账户";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTextCode:nil];
    [self setButtonOK:nil];
    [super viewDidUnload];
}
- (IBAction)buttonPressed:(id)sender {
    if ([self.textCode.text isEqual:@""]){
        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"请输入激活码。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
        [self.textCode becomeFirstResponder];
        return;
    }
    NSString *url = [NSString stringWithFormat:@"api/add_activate_code?userid=%d&code=%@",[AppSettings sharedSettings].userid,self.textCode.text];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            //go to next window;
            ShowActivateViewController *vc =[[ShowActivateViewController alloc] initWithNibName:@"ShowActivateViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}
@end
