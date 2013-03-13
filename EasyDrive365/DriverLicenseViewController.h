//
//  DriverLicenseViewController.h
//  EasyDrive365
//
//  Created by Fu Steven on 2/10/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetViewController.h"
#import "EditTableViewController.h"
@interface DriverLicenseViewController : NetViewController<UITableViewDelegate,UITableViewDataSource,EditDataDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
