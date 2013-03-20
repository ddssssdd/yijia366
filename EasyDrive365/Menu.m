//
//  Menu.m
//  EasyDrive365
//
//  Created by Fu Steven on 2/6/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "Menu.h"
#import "MenuItem.h"
#import "InformationViewController.h"
#import "HelpCallViewController.h"
#import "AccidentRescueViewController.h"

#import "DriverLicenseViewController.h"
#import "CarRegistrationViewController.h"
#import "TaxForCarShipViewController.h"
#import "CompulsoryInsuranceViewController.h"
#import "BusinessInsuranceViewController.h"
#import "InsuranceRecordsViewController.h"
#import "MaintainListViewController.h"
#import "BrowserViewController.h"
#import "BusinessInsViewController.h"
#import "MaintanViewController.h"

#import "CIViewController.h"

@implementation Menu
@synthesize list = _list;
+(Menu *)sharedMenu
{
    static Menu*_instance;
    static dispatch_once_t once;
    dispatch_once(&once,^{
        
        _instance =[[Menu alloc] init];
    });
    return _instance;
    
}

-(id)init
{
    self =[super init];
    if (self){
        NSString *defaultInfo = @"";
        NSString *defaultPhone=@"";
        _list=[NSArray arrayWithObjects:[[MenuItem alloc] initWithName:@"01" title:@"最新信息" description:defaultInfo imagePath:@"0001.png" phone:defaultPhone],
            [[MenuItem alloc] initWithName:@"02" title:@"紧急救助" description:defaultInfo imagePath:@"0002.png" phone:defaultPhone],
            [[MenuItem alloc] initWithName:@"03" title:@"事故救援" description:defaultInfo imagePath:@"0003.png" phone:defaultPhone],
            [[MenuItem alloc] initWithName:@"04" title:@"保养建议" description:defaultInfo imagePath:@"0004.png" phone:defaultPhone],
               [[MenuItem alloc] initWithName:@"05" title:@"驾驶证" description:defaultInfo imagePath:@"0005.png" phone:defaultPhone],
            [[MenuItem alloc] initWithName:@"06" title:@"行驶证" description:defaultInfo imagePath:@"0006.png" phone:defaultPhone],
            [[MenuItem alloc] initWithName:@"07" title:@"车船税" description:defaultInfo imagePath:@"0007.png" phone:defaultPhone],
            [[MenuItem alloc] initWithName:@"08" title:@"交强险" description:defaultInfo imagePath:@"0008.png" phone:defaultPhone],
            [[MenuItem alloc] initWithName:@"09" title:@"商业险" description:defaultInfo imagePath:@"0009.png" phone:defaultPhone],
            [[MenuItem alloc] initWithName:@"10" title:@"理赔记录" description:defaultInfo imagePath:@"0010.png" phone:defaultPhone],
            //[[MenuItem alloc] initWithName:@"11" title:@"维修记录" description:defaultInfo imagePath:@"0011.png" phone:defaultPhone],
            nil];
    }
    return self;
}
-(NSString *)getTitleByKey:(NSString *)key{
    for(MenuItem *item in _list){
        if ([item.name isEqualToString:key]){
            return item.title;
        }
    }
    return AppTitle;
}
-(void)pushToController:(UINavigationController *)controller key:(NSString *)key title:(NSString *)title url:(NSString *)url{
    
    if ([key isEqualToString:@"01"]){
        InformationViewController *vc = [[InformationViewController alloc] initWithNibName:@"InformationViewController" bundle:nil];
        vc.title = title;
        [controller pushViewController:vc animated:YES];
    }
    if ([key isEqualToString:@"02"]){
        HelpCallViewController *vc = [[HelpCallViewController alloc] initWithNibName:@"HelpCallViewController" bundle:nil];
        vc.title = title;
        [controller pushViewController:vc animated:YES];
    }
    if ([key isEqualToString:@"03"]){
        AccidentRescueViewController *vc = [[AccidentRescueViewController alloc] initWithNibName:@"AccidentRescueViewController" bundle:nil];
        vc.title = title;
        [controller pushViewController:vc animated:YES];
    }
    
    if ([key isEqualToString:@"04"]){
        
        MaintanViewController *vc = [[MaintanViewController alloc] initWithNibName:@"MaintanViewController" bundle:nil];
        vc.title = title;
        [controller pushViewController:vc animated:YES];
    }
    if ([key isEqualToString:@"05"]){
        DriverLicenseViewController *vc =[[DriverLicenseViewController alloc] initWithNibName:@"DriverLicenseViewController" bundle:nil];
        vc.title = title;
        [controller pushViewController:vc animated:YES];
    }
    if ([key isEqualToString:@"06"]){
        CarRegistrationViewController *vc =[[CarRegistrationViewController alloc] initWithNibName:@"CarRegistrationViewController" bundle:nil];
        vc.title = title;
        [controller pushViewController:vc animated:YES];
    }
    if ([key isEqualToString:@"07"]){
        TaxForCarShipViewController *vc = [[TaxForCarShipViewController alloc] initWithNibName:@"TaxForCarShipViewController" bundle:nil];
        vc.title = title;
        [controller pushViewController:vc animated:YES];
        
    }
    if ([key isEqualToString:@"08"]){
        //CompulsoryInsuranceViewController *vc = [[CompulsoryInsuranceViewController alloc] initWithNibName:@"CompulsoryInsuranceViewController" bundle:nil];
        CIViewController *vc = [[CIViewController alloc] initWithNibName:@"CIViewController" bundle:nil];
        vc.title = title;
        [controller pushViewController:vc animated:YES];
        
    }
    
    if ([key isEqualToString:@"09"]){
        BusinessInsViewController *vc = [[BusinessInsViewController alloc] initWithNibName:@"BusinessInsViewController" bundle:nil];
        vc.title = title;
        [controller pushViewController:vc animated:YES];
        
    }
    if ([key isEqualToString:@"10"]){
        InsuranceRecordsViewController *vc = [[InsuranceRecordsViewController alloc] initWithNibName:@"InsuranceRecordsViewController" bundle:nil];
        vc.title = title;
        [controller pushViewController:vc animated:YES];
        
    }
    /*
    if ([key isEqualToString:@"11"]){
//        MaintainListViewController *vc = [[MaintainListViewController alloc] initWithNibName:@"MaintainListViewController" bundle:nil];
        CIViewController *vc = [[CIViewController alloc] initWithNibName:@"CIViewController" bundle:nil];
        vc.title = title;
        [controller pushViewController:vc animated:YES];
        
    }
     */
     
    if ([key isEqualToString:@"00"] && url){
        BrowserViewController *vc = [[BrowserViewController alloc] initWithNibName:@"BrowserViewController" bundle:nil];
        vc.title = title;
        [controller pushViewController:vc animated:YES];
        [vc go:url];
    }
}

@end
