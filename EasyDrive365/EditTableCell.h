//
//  EditTableCell.h
//  EasyDrive365
//
//  Created by Fu Steven on 2/18/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditTableCell : UITableViewCell{
    BOOL _inListen;
}

@property (weak, nonatomic) IBOutlet UILabel *displayLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UITextField *valueText;
@property (nonatomic,copy) NSString *key;
@property (nonatomic,copy) NSString *value;
-(void)setEditable:(BOOL)isedit;
-(void)setValueByKey:(NSString *)key value:(NSString *)value;
-(void)endEdit;
-(void)start_listen;
@end
