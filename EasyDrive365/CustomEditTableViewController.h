//
//  CustomEditTableViewController.h
//  EasyDrive365
//
//  Created by Fu Steven on 3/8/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomEditTableViewController : UITableViewController{
    NSMutableArray *_list;
    NSString *_saveButtonName;
}
-(void)init_setup;
-(void)initData;
-(void)setupCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;
-(void)processSaving:(NSMutableDictionary *)parameters;
@end
