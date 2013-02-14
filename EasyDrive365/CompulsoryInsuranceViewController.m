//
//  CompulsoryInsuranceViewController.m
//  EasyDrive365
//
//  Created by Fu Steven on 2/14/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "CompulsoryInsuranceViewController.h"

@interface CompulsoryInsuranceViewController ()

@end

@implementation CompulsoryInsuranceViewController

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
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.sc.selectedSegmentIndex =0;
    self.text1.hidden = NO;
    self.text2.hidden = YES;
}
- (IBAction)segmentedSelectChanged:(UISegmentedControl *)sender {

    NSInteger index = sender.selectedSegmentIndex;
    if (index==0){
        self.text1.hidden = NO;
        self.text2.hidden = YES;
    }else{
        self.text1.hidden = YES;
        self.text2.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setText1:nil];
    [self setText2:nil];
    [self setSc:nil];
    [super viewDidUnload];
}
@end
