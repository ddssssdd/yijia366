//
//  SearchShopController.h
//  EasyDrive366
//
//  Created by Fu Steven on 9/18/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ServiceType:NSObject
@property (nonatomic) Boolean checked;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *code;
-(id)initWithJson:(id)json;
@end

@interface SearchShopController : UITableViewController

@end
