//
//  NetViewController.m
//  EasyDrive365
//
//  Created by Fu Steven on 2/14/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "NetViewController.h"
#import "NVUIGradientButton.h"



@interface NetViewController (){
   
}

@end

@implementation NetViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    _helper =[[HttpHelper alloc] initWithTarget:self];
    [_helper restoreData];
    [_helper loadData];
    /*
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back setTitle:@"客服" forState:UIControlStateNormal];
    [back setFrame:CGRectMake(0, 0, 100, 32)];
    [back setBackgroundColor:[UIColor greenColor]];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    self.navigationItem.rightBarButtonItem = backButtonItem;
     */
    
    
    /*
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"phone_s.png"] style:UIBarButtonItemStylePlain target:self action:@selector(makePhone:)];
    */
    /*
    NVUIGradientButton *button = [[NVUIGradientButton alloc] initWithFrame:CGRectMake(0, 0, 100, 32)];
    button.text=@"咨询客服";
    UIBarButtonItem *baritem =[[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = baritem;
     */
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
  
}
-(void)setup{
    
}
-(void)processData:(id)json{
    
}
-(void)makePhone:(id)sender{
    if (_phone && ![_phone isEqualToString:@""]){
        NSString *phoneNumber = [@"tel://" stringByAppendingString:_phone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    }
}

@end
