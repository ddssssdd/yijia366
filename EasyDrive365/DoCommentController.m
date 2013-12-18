//
//  DoCommentController.m
//  EasyDrive366
//
//  Created by Steven Fu on 12/18/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "DoCommentController.h"
#import "AMRatingControl.h"
#import "AppSettings.h"
#import <QuartzCore/QuartzCore.h>
@interface DoCommentController ()<UITextViewDelegate>{
    AMRatingControl *_ratingView;
}

@end

@implementation DoCommentController

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
    self.btnOK.text = @"保存";
    [self textViewDidChange:self.txtComment];
    self.txtComment.layer.borderWidth=2.0f;
    self.txtComment.layer.borderColor=[[UIColor grayColor] CGColor];
    self.txtComment.delegate = self;
    _ratingView = [[AMRatingControl alloc] initWithLocation:CGPointMake(10, 10) andMaxRating:5];
    [self.view addSubview:_ratingView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)textViewDidChange:(UITextView *)textView{
    int count = 200- textView.text.length;
    self.lblLeft.text= [NSString stringWithFormat:@"还可以输入%d个字",count];
    if (textView.text.length>=200){
        [textView resignFirstResponder];
        
        
    }
}
- (IBAction)buttonPressed:(id)sender {
    NSString *url = [NSString stringWithFormat:@"comment/edit_comment?userid=%d&id=%@&type=%@&comment=%@&star=%d",
                     [AppSettings sharedSettings].userid,
                     self.item_id,
                     self.item_type,
                     self.txtComment.text,
                     _ratingView.rating
                     ];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
@end
