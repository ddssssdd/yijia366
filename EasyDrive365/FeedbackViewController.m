//
//  FeedbackViewController.m
//  EasyDrive366
//
//  Created by Fu Steven on 5/20/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "FeedbackViewController.h"
#import "HttpClient.h"
#import "AppSettings.h"
#import <QuartzCore/QuartzCore.h>
@interface FeedbackViewController ()<UITextViewDelegate,UIAlertViewDelegate>

@end

@implementation FeedbackViewController

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
    self.txtfeedback.delegate = self;
    
    [self textViewDidChange:self.txtfeedback];
    self.btnOK.text = @"确定";
    //[self.txtfeedback becomeFirstResponder];
    self.txtfeedback.layer.borderWidth = 2.0f;
    self.txtfeedback.layer.borderColor = [[UIColor grayColor] CGColor];
    [self.txtfeedback becomeFirstResponder];

}

-(void)textViewDidChange:(UITextView *)textView{
    int count = 200- textView.text.length;
    self.lblCount.text= [NSString stringWithFormat:@"还可以输入%d个字",count];
    if (textView.text.length>=200){
        [textView resignFirstResponder];

    
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)buttonPressed:(id)sender {
    if (self.txtfeedback.text.length>0 && self.txtfeedback.text.length<=200){
        NSString *url = [NSString stringWithFormat:@"api/add_feeback?userid=%d&communication=%@&content=%@",[AppSettings sharedSettings].userid,self.txtCommunication.text,self.txtfeedback.text];
        [[HttpClient sharedHttp] get:url block:^(id json) {
            if ([[AppSettings sharedSettings] isSuccess:json]){
                [[[UIAlertView alloc] initWithTitle:AppTitle message:@"反馈已经提交，请耐心等候。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
                
            }
            
        }];
    }else{
        [[[UIAlertView alloc] initWithTitle:AppTitle message:@"请输入反馈信息，字数小于200." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidUnload {
    [self setTxtfeedback:nil];
    [self setLblCount:nil];
    [self setTxtCommunication:nil];
    [self setBtnOK:nil];
    [super viewDidUnload];
}
@end
