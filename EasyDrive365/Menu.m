//
//  Menu.m
//  EasyDrive365
//
//  Created by Fu Steven on 2/6/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "Menu.h"
#import "MenuItem.h"

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
        
        _list=[NSArray arrayWithObjects:[[MenuItem alloc] initWithName:@"01" title:@"最新信息" description:@"description" imagePath:@"0001.png" phone:@"123"],
            [[MenuItem alloc] initWithName:@"02" title:@"紧急求助" description:@"description" imagePath:@"0002.png" phone:@"1234"],
            [[MenuItem alloc] initWithName:@"03" title:@"事故救援" description:@"description" imagePath:@"0003.png" phone:@"1235"],
            [[MenuItem alloc] initWithName:@"04" title:@"保养建议" description:@"description" imagePath:@"0004.png" phone:@"1236"],
            [[MenuItem alloc] initWithName:@"05" title:@"驾驶证" description:@"description" imagePath:@"0005.png" phone:@"1237"],
            [[MenuItem alloc] initWithName:@"06" title:@"行驶证" description:@"description" imagePath:@"0006.png" phone:@"1238"],
            [[MenuItem alloc] initWithName:@"07" title:@"车船税" description:@"description" imagePath:@"0007.png" phone:@"1238"],
            [[MenuItem alloc] initWithName:@"08" title:@"交强险" description:@"description" imagePath:@"0008.png" phone:@"1238"],
            [[MenuItem alloc] initWithName:@"09" title:@"商业险" description:@"description" imagePath:@"0009.png" phone:@"1238"],
            [[MenuItem alloc] initWithName:@"10" title:@"理赔记录" description:@"description" imagePath:@"0010.png" phone:@"1238"],
            [[MenuItem alloc] initWithName:@"11" title:@"维修记录" description:@"description" imagePath:@"0011.png" phone:@"1238"],
            nil];
    }
    return self;
}

@end
