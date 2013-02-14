//
//  CarRegistrationViewController.m
//  EasyDrive365
//
//  Created by Fu Steven on 2/10/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "CarRegistrationViewController.h"
#import "IllegallyListViewController.h"

@interface CarRegistrationViewController ()

@end

@implementation CarRegistrationViewController

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
- (IBAction)get_illegally:(id)sender {
    IllegallyListViewController *vc =[[IllegallyListViewController alloc] initWithNibName:@"IllegallyListViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
