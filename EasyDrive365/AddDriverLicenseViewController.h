//
//  AddDriverLicenseViewController.h
//  EasyDrive365
//
//  Created by Fu Steven on 3/2/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickupData.h"


@protocol EditDataDelegate <NSObject>
-(NSArray *)getSections;
-(NSArray *)getItems;
-(NSDictionary *)getInitData;
-(void)saveData:(NSDictionary *)paramters;

@end

@interface AddDriverLicenseViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,PickupData>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,weak) id<EditDataDelegate> delegate;

-(id)initWithDelegate:(id)delegate;
@end
