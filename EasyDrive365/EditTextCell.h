//
//  EditTextCell.h
//  EasyDrive365
//
//  Created by Fu Steven on 3/2/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditTextCell : UITableViewCell{
    BOOL _inListen;
}

@property (weak, nonatomic) IBOutlet UILabel *keyLabel;
@property (weak, nonatomic) IBOutlet UITextField *valueText;
@property (strong,nonatomic) NSString *key;
@property (nonatomic) id targetObject;

@property (weak, nonatomic) IBOutlet UILabel *lblUnit;

-(void)setUnit:(NSString *)unit;
-(void)textChanged:(id)sender;
@end
