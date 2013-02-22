//
//  AccidentRescueViewController.h
//  EasyDrive365
//
//  Created by Fu Steven on 2/10/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetViewController.h"

@interface AccidentRescueViewController : NetViewController
@property (weak, nonatomic) IBOutlet UILabel *lblShopName;

@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UITextView *textDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblPhone;
@end