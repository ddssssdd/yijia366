//
//  AfterPayController.m
//  EasyDrive366
//
//  Created by Steven Fu on 2/22/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import "AfterPayController.h"
#import "OrderFinishedController.h"
#import "OrderAddressController.h"
#import "OrderContentController.h"
#import "OrderAccidentController.h"
#import "AppSettings.h"

@implementation AfterPayController
-(void)pushToNext:(UINavigationController *)controller json:(id)json hasBack:(BOOL)hasBack{
    NSString *next_form =json[@"result"][@"next_form"];
    NSLog(@"%@",json[@"result"]);
    if ([next_form isEqualToString:@"finished"]){
        OrderFinishedController *vc = [[OrderFinishedController alloc] initWithNibName:@"OrderFinishedController" bundle:Nil];
        vc.content_data= json[@"result"];

        [controller pushViewController:vc animated:YES];
    }else if ([next_form isEqualToString:@"address"]){
        OrderAddressController *vc =[[OrderAddressController alloc] initWithStyle:UITableViewStyleGrouped];
        vc.address_data = json[@"result"];
        vc.hasBack = hasBack;
        [controller pushViewController:vc animated:YES];
    }else if ([next_form isEqualToString:@"ins_contents"]){
        OrderContentController *vc =[[OrderContentController alloc] initWithStyle:UITableViewStyleGrouped];
        vc.ins_data = json[@"result"];
        vc.hasBack = hasBack;
        [controller pushViewController:vc animated:YES];
    }else if ([next_form isEqualToString:@"ins_accident"]){
        OrderAccidentController *vc =[[OrderAccidentController alloc] initWithStyle:UITableViewStyleGrouped];
        vc.ins_data = json[@"result"];
        vc.hasBack = hasBack;
        [controller pushViewController:vc animated:YES];
    }
}
-(void)pushToNext:(UINavigationController *)controller order_id:(NSString *)order_id{
    NSString *url =[NSString stringWithFormat:@"order/order_exform?userid=%d&orderid=%@",[AppSettings sharedSettings].userid,order_id];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            [self pushToNext:controller json:json hasBack:YES];
        }
    }];
}
@end
