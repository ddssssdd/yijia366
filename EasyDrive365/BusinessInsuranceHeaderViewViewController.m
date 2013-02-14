//
//  BusinessInsuranceHeaderViewViewController.m
//  EasyDrive365
//
//  Created by Fu Steven on 2/14/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "BusinessInsuranceHeaderViewViewController.h"

@interface BusinessInsuranceHeaderViewViewController ()

@end

@implementation BusinessInsuranceHeaderViewViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTxtNo:nil];
    [self setTxtCompany:nil];
    [super viewDidUnload];
}
- (IBAction)getInformation:(id)sender {
    NSLog(@"i get inforamtion from server.");
}

@end
