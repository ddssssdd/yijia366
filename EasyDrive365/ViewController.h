//
//  ViewController.h
//  EasyDrive365
//
//  Created by Fu Steven on 1/29/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshHelper.h"

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,  RefreshHelperDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end
