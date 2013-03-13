//
//  OneButtonCell.m
//  EasyDrive365
//
//  Created by Fu Steven on 3/8/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "OneButtonCell.h"

@implementation OneButtonCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)buttonPress:(id)sender {
    if (self.delegate){
        [self.delegate buttonPress:sender];
    }
}

@end
