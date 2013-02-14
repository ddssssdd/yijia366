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
        
        _list=[NSArray arrayWithObjects:[[MenuItem alloc] initWithName:@"001" title:@"信息" description:@"description" imagePath:@"01.png" phone:@"123"],
            [[MenuItem alloc] initWithName:@"002" title:@"紧急求助" description:@"description" imagePath:@"02.png" phone:@"1234"],
            [[MenuItem alloc] initWithName:@"003" title:@"事故救援" description:@"description" imagePath:@"03.png" phone:@"1235"],
            [[MenuItem alloc] initWithName:@"004" title:@"保养建议" description:@"description" imagePath:@"04.png" phone:@"1236"],
            [[MenuItem alloc] initWithName:@"005" title:@"驾驶证" description:@"description" imagePath:@"05.png" phone:@"1237"],
            [[MenuItem alloc] initWithName:@"006" title:@"行驶证" description:@"description" imagePath:@"06.png" phone:@"1238"],
            [[MenuItem alloc] initWithName:@"007" title:@"车船税" description:@"description" imagePath:@"06.png" phone:@"1238"],
            [[MenuItem alloc] initWithName:@"008" title:@"交强险" description:@"description" imagePath:@"06.png" phone:@"1238"],
            [[MenuItem alloc] initWithName:@"009" title:@"商业险" description:@"description" imagePath:@"06.png" phone:@"1238"],
            [[MenuItem alloc] initWithName:@"010" title:@"理赔记录" description:@"description" imagePath:@"06.png" phone:@"1238"],
            [[MenuItem alloc] initWithName:@"011" title:@"维修记录" description:@"description" imagePath:@"06.png" phone:@"1238"],
            nil];
    }
    return self;
}

@end
