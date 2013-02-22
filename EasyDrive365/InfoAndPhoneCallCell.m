//
//  InfoAndPhoneCallCell.m
//  EasyDrive365
//
//  Created by Fu Steven on 2/22/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "InfoAndPhoneCallCell.h"

@implementation InfoAndPhoneCallCell

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
- (IBAction)makeCall:(id)sender {
    if(self.phone){
        NSString *phoneNumber = [@"tel://" stringByAppendingString:self.phone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    }
}

@end
