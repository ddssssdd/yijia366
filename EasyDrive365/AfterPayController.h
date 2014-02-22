//
//  AfterPayController.h
//  EasyDrive366
//
//  Created by Steven Fu on 2/22/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AfterPayController : NSObject

-(void)pushToNext:(UINavigationController *)controller  json:(id)json hasBack:(BOOL)hasBack;
-(void)pushToNext:(UINavigationController *)controller  order_id:(NSString *)order_id;
@end
