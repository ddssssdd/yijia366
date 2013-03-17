//
//  OneButtonCell.h
//  EasyDrive365
//
//  Created by Fu Steven on 3/8/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NVUIGradientButton.h"
@protocol OneButtonCellDelegate<NSObject>
-(void)buttonPress:(id)sender;
@end;
@interface OneButtonCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NVUIGradientButton *button;
@property (nonatomic,weak) id<OneButtonCellDelegate> delegate;

@end