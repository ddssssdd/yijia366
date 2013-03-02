//
//  MaintainSuggestionViewController.m
//  EasyDrive365
//
//  Created by Fu Steven on 2/10/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "MaintainSuggestionViewController.h"

@interface MaintainSuggestionViewController ()

@end

@implementation MaintainSuggestionViewController

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
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addRecord:)];
}
-(void)addRecord:(id)sender{
    id parameter = @{@"max_distance":self.txtMax_ditance.text,
    @"max_time":self.txtMax_time.text,
    @"current_distance":self.txtCurrent_distance.text,
    @"prev_date":self.txtPre_time.text,
    @"prev_distance":self.txtPre_distance.text,
    @"average_mileage":self.txtAva_miles.text};

    [[_helper httpClient] post:[_helper appSetttings].url_for_post_maintain_record parameters:parameter block:^(id json) {
        if ([[_helper appSetttings] isSuccess:json]){
            NSLog(@"return=%@",json);
        }
    }];
}
-(void)setup{
    _helper.url =[_helper appSetttings].url_for_get_maintain_record;
}
-(void)processData:(id)json{
    id result=[json objectForKey:@"result"];
    self.txtMax_ditance.text = [NSString stringWithFormat:@"%@", [result objectForKey:@"max_distance"]];
    self.txtMax_time.text = [NSString stringWithFormat:@"%@", [result objectForKey:@"max_time"]];
    self.txtCurrent_distance.text = [NSString stringWithFormat:@"%@", [result objectForKey:@"current_distance"]];
    self.txtPre_time.text = [NSString stringWithFormat:@"%@", [result objectForKey:@"prev_date"]];
    self.txtPre_distance.text = [NSString stringWithFormat:@"%@", [result objectForKey:@"prev_distance"]];
    self.txtCurrent_time.text = [NSString stringWithFormat:@"%@", [result objectForKey:@"current_date"]];
    self.txtCurrent_miles.text = [NSString stringWithFormat:@"%@", [result objectForKey:@"current_miles"]];
    self.txtAva_miles.text =[NSString stringWithFormat:@"%@", [result objectForKey:@"average_mileage"]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTxtMax_ditance:nil];
    [self setTxtMax_time:nil];
    [self setTxtCurrent_distance:nil];
    [self setTxtPre_time:nil];
    [self setTxtPre_distance:nil];
    [self setTxtCurrent_time:nil];
    [self setTxtCurrent_miles:nil];
    [self setTxtAva_miles:nil];
    [super viewDidUnload];
}
@end
