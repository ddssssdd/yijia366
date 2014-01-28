//
//  OrderFinishedController.m
//  EasyDrive366
//
//  Created by Steven Fu on 1/28/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import "OrderFinishedController.h"
#import "OrderDetailController.h"

@interface OrderFinishedController ()

@end

@implementation OrderFinishedController

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
    self.title = @"订单完成";
    self.txtContent.text = self.content;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)gobackGoodsPressed:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:OPEN_GOODS object:Nil];
}
- (IBAction)goOrderDetailPressed:(id)sender {
    OrderDetailController *vc = [[OrderDetailController alloc] initWithStyle:UITableViewStyleGrouped];
    vc.order_id = self.order_id;
    [self.navigationController pushViewController:vc animated:YES];
}
@end